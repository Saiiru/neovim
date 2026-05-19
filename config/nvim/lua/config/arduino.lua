-- Arduino/ESP32 workflow for Neovim.
--
-- Um pipeline único para Uno, Nano, Mega e ESP32. O estado fica em `vim.g`
-- para ser fácil de inspecionar, e o arduino-language-server recebe o FQBN
-- atual através de ARDUINO_FQBN.

local M = {}

M.profiles = {
  { id = "uno", name = "Arduino Uno", fqbn = "arduino:avr:uno", baud = "9600", core = "arduino:avr" },
  { id = "nano", name = "Arduino Nano", fqbn = "arduino:avr:nano", baud = "9600", core = "arduino:avr" },
  { id = "mega", name = "Arduino Mega 2560", fqbn = "arduino:avr:mega", baud = "9600", core = "arduino:avr" },
  { id = "esp32", name = "ESP32 Dev Module", fqbn = "esp32:esp32:esp32", baud = "115200", core = "esp32:esp32" },
  {
    id = "esp32doit",
    name = "ESP32 DOIT DevKit V1",
    fqbn = "esp32:esp32:esp32doit-devkit-v1",
    baud = "115200",
    core = "esp32:esp32",
  },
  { id = "esp32s3", name = "ESP32-S3 Dev Module", fqbn = "esp32:esp32:esp32s3", baud = "115200", core = "esp32:esp32" },
  { id = "esp32c3", name = "ESP32-C3 Dev Module", fqbn = "esp32:esp32:esp32c3", baud = "115200", core = "esp32:esp32" },
}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Arduino" })
end

local function executable(bin)
  return vim.fn.executable(bin) == 1
end

local function exepath(bin)
  local path = vim.fn.exepath(bin)
  if path ~= "" then
    return path
  end

  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/" .. bin
  if vim.fn.executable(mason_bin) == 1 then
    return mason_bin
  end

  return ""
end

local function esc(value)
  return vim.fn.shellescape(value)
end

local function current_file()
  return vim.api.nvim_buf_get_name(0)
end

local function find_profile(predicate)
  for _, profile in ipairs(M.profiles) do
    if predicate(profile) then
      return profile
    end
  end
end

local function profile_by_id(id)
  return find_profile(function(profile)
    return profile.id == id
  end)
end

local function profile_by_fqbn(fqbn)
  return find_profile(function(profile)
    return profile.fqbn == fqbn
  end)
end

local function display_profile(profile)
  return ("%s  [%s]"):format(profile.name, profile.fqbn)
end

local function config_path()
  local home = vim.env.HOME
  local candidates = {
    home .. "/.arduino15/arduino-cli.yaml",
    home .. "/.config/arduino-cli/arduino-cli.yaml",
  }

  for _, path in ipairs(candidates) do
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end

  return home .. "/.arduino15/arduino-cli.yaml"
end

local function has_sketch_file(dir)
  return #vim.fn.globpath(dir, "*.ino", false, true) > 0 or #vim.fn.globpath(dir, "*.pde", false, true) > 0
end

local function sketch_ancestor(start)
  local dir = vim.fn.isdirectory(start) == 1 and start or vim.fn.fnamemodify(start, ":p:h")

  while dir and dir ~= "" do
    if has_sketch_file(dir) then
      return dir
    end

    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end
end

local function sketch_dir()
  local file = current_file()
  if file ~= "" and (file:match("%.ino$") or file:match("%.pde$")) then
    return vim.fn.fnamemodify(file, ":p:h")
  end

  local start = file ~= "" and file or vim.fn.getcwd()
  local root = vim.fs.root(start, { "sketch.yaml", "arduino-cli.yaml", "platformio.ini" })
  if root then
    return root
  end

  local sketch_root = sketch_ancestor(start)
  if sketch_root then
    return sketch_root
  end

  if file ~= "" then
    local git_root = vim.fs.root(start, { ".git" })
    if git_root and has_sketch_file(git_root) then
      return git_root
    end
    return vim.fn.fnamemodify(file, ":p:h")
  end

  return vim.fn.getcwd()
end

local function build_path(dir)
  local base = vim.fn.stdpath("cache") .. "/arduino/build"
  return base .. "/" .. vim.fn.sha256(dir):sub(1, 16)
end

local function tmux_split(command, title)
  local ok, tmux = pcall(require, "config.tmux")
  if ok then
    tmux.split(command, { cwd = sketch_dir(), size = 16, title = title or "Arduino" })
    return
  end

  vim.cmd("botright split")
  vim.cmd("resize 16")
  vim.cmd("terminal " .. command)
end

local function board_list_json()
  if not executable("arduino-cli") then
    return nil
  end

  local out = vim.fn.system({ "arduino-cli", "board", "list", "--format", "json" })
  if vim.v.shell_error ~= 0 or not out or out == "" then
    return nil
  end

  local ok, data = pcall(vim.json.decode, out)
  if not ok then
    return nil
  end

  return data.detected_ports or data
end

local function plain_ports()
  local ports = {}
  local seen = {}
  for _, pattern in ipairs({ "/dev/ttyUSB*", "/dev/ttyACM*", "/dev/serial/by-id/*" }) do
    for _, port in ipairs(vim.fn.glob(pattern, false, true)) do
      if port ~= "" and not seen[port] then
        seen[port] = true
        table.insert(ports, port)
      end
    end
  end
  table.sort(ports)
  return ports
end

function M.detect_ports()
  local rows = board_list_json()
  local out = {}

  if type(rows) == "table" then
    for _, row in ipairs(rows) do
      local port = row.port or {}
      local address = port.address
      if address and address ~= "" then
        local matches = row.matching_boards or row.boards or {}
        local board = matches[1] or {}
        local fqbn = board.fqbn or ""
        local name = board.name or "Unknown board"
        local score = fqbn == M.get_fqbn() and 100 or fqbn ~= "" and 50 or 0
        table.insert(out, {
          address = address,
          fqbn = fqbn,
          name = name,
          score = score,
          label = ("%s  |  %s  |  %s"):format(address, name, fqbn ~= "" and fqbn or (port.protocol or "serial")),
        })
      end
    end
  end

  if #out == 0 then
    for _, port in ipairs(plain_ports()) do
      table.insert(out, { address = port, fqbn = "", name = "Serial", score = 0, label = port })
    end
  end

  table.sort(out, function(a, b)
    if a.score == b.score then
      return a.address < b.address
    end
    return a.score > b.score
  end)

  return out
end

local function best_port()
  return M.detect_ports()[1]
end

function M.get_fqbn()
  return vim.g.arduino_fqbn or vim.env.ARDUINO_FQBN or "arduino:avr:uno"
end

function M.get_profile()
  return profile_by_fqbn(M.get_fqbn()) or M.profiles[1]
end

function M.get_port()
  return vim.g.arduino_port
end

function M.get_baud()
  return tostring(vim.g.arduino_baud or M.get_profile().baud or "115200")
end

local function sync_env()
  vim.env.ARDUINO_FQBN = M.get_fqbn()
end

local function restart_lsp()
  sync_env()
  vim.defer_fn(function()
    for _, client in ipairs(vim.lsp.get_clients({ name = "arduino_language_server" })) do
      client.stop(true)
    end
    pcall(vim.cmd, "LspStart arduino_language_server")
  end, 150)
end

function M.set_profile(profile)
  if not profile then
    notify("Perfil inválido.", vim.log.levels.ERROR)
    return
  end

  vim.g.arduino_profile = profile.id
  vim.g.arduino_fqbn = profile.fqbn
  vim.g.arduino_baud = profile.baud
  sync_env()
  notify("Board: " .. display_profile(profile))
  restart_lsp()
end

function M.set_profile_by_id(id)
  M.set_profile(profile_by_id(id))
end

function M.set_fqbn(fqbn, baud)
  if not fqbn or fqbn == "" then
    return
  end
  local known = profile_by_fqbn(fqbn)
  vim.g.arduino_profile = known and known.id or "custom"
  vim.g.arduino_fqbn = fqbn
  vim.g.arduino_baud = tostring(baud or vim.g.arduino_baud or (known and known.baud) or "115200")
  sync_env()
  notify("FQBN: " .. fqbn)
  restart_lsp()
end

function M.set_port(port)
  if not port or port == "" then
    notify("Porta inválida.", vim.log.levels.ERROR)
    return
  end
  vim.g.arduino_port = port
  notify("Port: " .. port)
end

function M.board_select()
  vim.ui.select(M.profiles, {
    prompt = "Arduino board profile",
    format_item = display_profile,
  }, function(choice)
    if choice then
      M.set_profile(choice)
    end
  end)
end

function M.custom_fqbn()
  vim.ui.input({ prompt = "FQBN: ", default = M.get_fqbn() }, function(fqbn)
    if not fqbn or fqbn == "" then
      return
    end
    vim.ui.input({ prompt = "Baud: ", default = M.get_baud() }, function(baud)
      M.set_fqbn(fqbn, baud or M.get_baud())
    end)
  end)
end

function M.port_select()
  local ports = M.detect_ports()
  if #ports == 0 then
    notify("Nenhuma porta encontrada (/dev/ttyUSB*, /dev/ttyACM*).", vim.log.levels.WARN)
    return
  end

  vim.ui.select(ports, {
    prompt = "Arduino port",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if choice then
      M.set_port(choice.address)
    end
  end)
end

function M.port_auto()
  local port = best_port()
  if not port then
    notify("Nenhuma porta detectada.", vim.log.levels.ERROR)
    return
  end
  M.set_port(port.address)
end

local function require_cli()
  if executable("arduino-cli") then
    return true
  end
  notify("arduino-cli não encontrado.", vim.log.levels.ERROR)
  return false
end

local function compile_cmd()
  local dir = sketch_dir()
  local build = build_path(dir)
  vim.fn.mkdir(build, "p")
  return table.concat({
    "arduino-cli compile",
    "--fqbn",
    esc(M.get_fqbn()),
    "--build-path",
    esc(build),
    esc(dir),
  }, " ")
end

function M.compile()
  if not require_cli() then
    return
  end
  tmux_split(compile_cmd(), "Arduino Compile")
end

function M.upload()
  if not require_cli() then
    return
  end

  local port = M.get_port() or (best_port() and best_port().address)
  if not port then
    notify("Porta não definida. Use :ArduinoPortSelect", vim.log.levels.ERROR)
    return
  end
  vim.g.arduino_port = port

  local dir = sketch_dir()
  local build = build_path(dir)
  local upload = table.concat({
    "arduino-cli upload",
    "-p",
    esc(port),
    "--fqbn",
    esc(M.get_fqbn()),
    "--build-path",
    esc(build),
    esc(dir),
  }, " ")

  tmux_split(compile_cmd() .. " && " .. upload, "Arduino Upload")
end

function M.upload_safe()
  local port = best_port()
  if port then
    M.set_port(port.address)
    if port.fqbn and port.fqbn ~= "" then
      M.set_fqbn(port.fqbn)
    end
  end
  M.upload()
end

function M.monitor()
  if not require_cli() then
    return
  end

  local port = M.get_port() or (best_port() and best_port().address)
  if not port then
    notify("Porta não definida. Use :ArduinoPortSelect", vim.log.levels.ERROR)
    return
  end
  vim.g.arduino_port = port

  local cmd = table.concat({
    "arduino-cli monitor",
    "-p",
    esc(port),
    "-b",
    esc(M.get_fqbn()),
    "--config",
    esc("baudrate=" .. M.get_baud()),
  }, " ")

  tmux_split(cmd, "Arduino Monitor")
end

function M.clean_build()
  local build = build_path(sketch_dir())
  vim.fn.delete(build, "rf")
  notify("Build cache limpo: " .. build)
end

function M.board_list()
  tmux_split("arduino-cli board list", "Arduino Board List")
end

function M.core_list()
  tmux_split("arduino-cli core list", "Arduino Core List")
end

function M.lib_list()
  tmux_split("arduino-cli lib list", "Arduino Library List")
end

function M.doctor()
  local cmd = table.concat({
    "printf '%s\\n' '== executables ==' ;",
    "command -v arduino-cli || true ;",
    "command -v arduino-language-server || true ;",
    "command -v clangd || true ;",
    "printf '\\n%s\\n' '== arduino-cli config ==' ;",
    "arduino-cli config dump || true ;",
    "printf '\\n%s\\n' '== cores ==' ;",
    "arduino-cli core list || true ;",
    "printf '\\n%s\\n' '== boards ==' ;",
    "arduino-cli board list || true ;",
    "printf '\\n%s\\n' '== ports ==' ;",
    "ls -l /dev/ttyUSB* /dev/ttyACM* /dev/serial/by-id/* 2>/dev/null || true ;",
    "printf '\\n%s\\n' '== groups ==' ;",
    "groups",
  }, " ")

  tmux_split(cmd, "Arduino Doctor")
end

function M.setup_avr()
  local cmd = table.concat({
    "arduino-cli config init || true",
    "arduino-cli core update-index",
    "arduino-cli core install arduino:avr",
  }, " && ")

  tmux_split(cmd, "Arduino Setup AVR")
end

function M.setup_esp32()
  local url = "https://espressif.github.io/arduino-esp32/package_esp32_index.json"
  local cmd = table.concat({
    "arduino-cli config init || true",
    "arduino-cli config add board_manager.additional_urls "
      .. esc(url)
      .. " || arduino-cli config set board_manager.additional_urls "
      .. esc(url),
    "arduino-cli core update-index",
    "arduino-cli core install esp32:esp32",
  }, " && ")

  tmux_split(cmd, "Arduino Setup ESP32")
end

function M.setup_cores()
  local url = "https://espressif.github.io/arduino-esp32/package_esp32_index.json"
  local cmd = table.concat({
    "arduino-cli config init || true",
    "arduino-cli config add board_manager.additional_urls "
      .. esc(url)
      .. " || arduino-cli config set board_manager.additional_urls "
      .. esc(url),
    "arduino-cli core update-index",
    "arduino-cli core install arduino:avr",
    "arduino-cli core install esp32:esp32",
  }, " && ")

  tmux_split(cmd, "Arduino Setup Cores")
end

function M.status()
  local profile = M.get_profile()
  notify(table.concat({
    "Arduino Status",
    "Profile: " .. tostring(vim.g.arduino_profile or profile.id),
    "Board:   " .. tostring(profile.name or "custom"),
    "FQBN:    " .. M.get_fqbn(),
    "Port:    " .. tostring(M.get_port() or "not set"),
    "Baud:    " .. M.get_baud(),
    "Config:  " .. config_path(),
    "Sketch:  " .. sketch_dir(),
  }, "\n"))
end

function M.prompt()
  local text = table.concat({
    "Estou trabalhando num projeto Arduino/ESP32 no Neovim.",
    "",
    "Contexto técnico:",
    "- Profile: " .. tostring(vim.g.arduino_profile or M.get_profile().id),
    "- Board: " .. tostring(M.get_profile().name or "custom"),
    "- FQBN: " .. M.get_fqbn(),
    "- Port: " .. tostring(M.get_port() or "not set"),
    "- Baud: " .. M.get_baud(),
    "- Arduino CLI config: " .. config_path(),
    "- Sketch dir: " .. sketch_dir(),
    "- Current file: " .. current_file(),
    "",
    "Ajude a diagnosticar compile/upload/monitor/LSP.",
  }, "\n")

  vim.fn.setreg("+", text)
  vim.fn.setreg("\"", text)
  notify("Arduino prompt copiado para o clipboard.")
end

function M.lsp_cmd()
  local ls = exepath("arduino-language-server")
  local cli = exepath("arduino-cli")
  local clangd = exepath("clangd")
  if ls == "" or cli == "" or clangd == "" then
    return nil
  end

  return {
    "bash",
    "-lc",
    table.concat({
      "exec",
      esc(ls),
      "-clangd",
      esc(clangd),
      "-cli",
      esc(cli),
      "-cli-config",
      esc(config_path()),
      "-fqbn",
      "\"${ARDUINO_FQBN:-" .. M.get_fqbn() .. "}\"",
    }, " "),
  }
end

function M.is_arduino_project(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr or 0)
  if file:match("%.ino$") or file:match("%.pde$") then
    return true
  end
  local start = file ~= "" and file or vim.fn.getcwd()
  local root = vim.fs.root(start, { "sketch.yaml", "arduino-cli.yaml", "platformio.ini" })
  if root then
    return true
  end
  if sketch_ancestor(start) then
    return true
  end
  local git_root = vim.fs.root(start, { ".git" })
  return git_root and has_sketch_file(git_root)
end

local function map_buffer(bufnr)
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map("<leader>Aa", function()
    M.set_profile_by_id("uno")
  end, "Arduino Uno")
  map("<leader>An", function()
    M.set_profile_by_id("nano")
  end, "Arduino Nano")
  map("<leader>Ag", function()
    M.set_profile_by_id("mega")
  end, "Arduino Mega")
  map("<leader>Ae", function()
    M.set_profile_by_id("esp32")
  end, "ESP32 Dev Module")
  map("<leader>AE", function()
    M.set_profile_by_id("esp32doit")
  end, "ESP32 DOIT DevKit V1")
  map("<leader>A3", function()
    M.set_profile_by_id("esp32s3")
  end, "ESP32-S3")
  map("<leader>AC", function()
    M.set_profile_by_id("esp32c3")
  end, "ESP32-C3")
  map("<leader>Ab", M.board_select, "Arduino Board Select")
  map("<leader>Af", M.custom_fqbn, "Arduino Custom FQBN")
  map("<leader>Ao", M.port_select, "Arduino Port Select")
  map("<leader>AP", M.port_auto, "Arduino Port Auto")
  map("<leader>Ac", M.compile, "Arduino Compile")
  map("<leader>Au", M.upload, "Arduino Upload")
  map("<leader>AU", M.upload_safe, "Arduino Upload Safe")
  map("<leader>Am", M.monitor, "Arduino Monitor")
  map("<leader>AK", M.clean_build, "Arduino Clean Build Cache")
  map("<leader>Al", M.board_list, "Arduino Board List")
  map("<leader>Ak", M.core_list, "Arduino Core List")
  map("<leader>Ai", M.lib_list, "Arduino Library List")
  map("<leader>As", M.status, "Arduino Status")
  map("<leader>Ad", M.doctor, "Arduino Doctor")
  map("<leader>Ap", M.prompt, "Arduino Prompt ChatGPT")
end

function M.setup()
  if not vim.g.arduino_fqbn then
    local default = profile_by_id("uno")
    vim.g.arduino_profile = default.id
    vim.g.arduino_fqbn = default.fqbn
    vim.g.arduino_baud = default.baud
  end
  sync_env()

  vim.filetype.add({
    extension = {
      ino = "arduino",
      pde = "arduino",
    },
  })

  vim.api.nvim_create_user_command("ArduinoEnvUno", function()
    M.set_profile_by_id("uno")
  end, {})
  vim.api.nvim_create_user_command("ArduinoEnvNano", function()
    M.set_profile_by_id("nano")
  end, {})
  vim.api.nvim_create_user_command("ArduinoEnvMega", function()
    M.set_profile_by_id("mega")
  end, {})
  vim.api.nvim_create_user_command("ArduinoEnvESP32", function()
    M.set_profile_by_id("esp32")
  end, {})
  vim.api.nvim_create_user_command("ArduinoEnvESP32Doit", function()
    M.set_profile_by_id("esp32doit")
  end, {})
  vim.api.nvim_create_user_command("ArduinoEnvESP32S3", function()
    M.set_profile_by_id("esp32s3")
  end, {})
  vim.api.nvim_create_user_command("ArduinoEnvESP32C3", function()
    M.set_profile_by_id("esp32c3")
  end, {})
  vim.api.nvim_create_user_command("ArduinoBoardSelect", M.board_select, {})
  vim.api.nvim_create_user_command("ArduinoFqbn", M.custom_fqbn, {})
  vim.api.nvim_create_user_command("ArduinoPortSelect", M.port_select, {})
  vim.api.nvim_create_user_command("ArduinoPortAuto", M.port_auto, {})
  vim.api.nvim_create_user_command("ArduinoCompile", M.compile, {})
  vim.api.nvim_create_user_command("ArduinoUpload", M.upload, {})
  vim.api.nvim_create_user_command("ArduinoUploadSafe", M.upload_safe, {})
  vim.api.nvim_create_user_command("ArduinoMonitor", M.monitor, {})
  vim.api.nvim_create_user_command("ArduinoCleanBuild", M.clean_build, {})
  vim.api.nvim_create_user_command("ArduinoBoardList", M.board_list, {})
  vim.api.nvim_create_user_command("ArduinoCoreList", M.core_list, {})
  vim.api.nvim_create_user_command("ArduinoLibList", M.lib_list, {})
  vim.api.nvim_create_user_command("ArduinoStatus", M.status, {})
  vim.api.nvim_create_user_command("ArduinoDoctor", M.doctor, {})
  vim.api.nvim_create_user_command("ArduinoSetupAVR", M.setup_avr, {})
  vim.api.nvim_create_user_command("ArduinoSetupESP32", M.setup_esp32, {})
  vim.api.nvim_create_user_command("ArduinoSetupCores", M.setup_cores, {})
  vim.api.nvim_create_user_command("ArduinoPrompt", M.prompt, {})

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("sairu_arduino", { clear = true }),
    pattern = { "arduino", "c", "cpp" },
    callback = function(args)
      if M.is_arduino_project(args.buf) then
        map_buffer(args.buf)
      end
    end,
  })
end

M.setup()

return M
