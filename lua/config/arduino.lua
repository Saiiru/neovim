-- Arduino & ESP32 editor integration (KORA-03)
-- Build/upload/monitor responsibility lives in mise tasks and CLI tools.

local M = {}

M.profiles = {
  { id = "uno", name = "Arduino Uno", fqbn = "arduino:avr:uno", baud = "9600" },
  { id = "nano", name = "Arduino Nano", fqbn = "arduino:avr:nano", baud = "9600" },
  { id = "mega", name = "Arduino Mega 2560", fqbn = "arduino:avr:mega", baud = "9600" },
  { id = "esp32", name = "ESP32 Dev Module", fqbn = "esp32:esp32:esp32", baud = "115200" },
  { id = "esp32doit", name = "ESP32 DOIT DevKit V1", fqbn = "esp32:esp32:esp32doit-devkit-v1", baud = "115200" },
  { id = "esp32s3", name = "ESP32-S3 Dev Module", fqbn = "esp32:esp32:esp32s3", baud = "115200" },
  { id = "esp32c3", name = "ESP32-C3 Dev Module", fqbn = "esp32:esp32:esp32c3", baud = "115200" },
}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Arduino" })
end

local function executable(bin)
  return vim.fn.executable(bin) == 1
end

local function buffer_name(bufnr)
  return vim.api.nvim_buf_get_name(bufnr or 0)
end

local function has_sketch_file(dir)
  return #vim.fn.globpath(dir, "*.ino", false, true) > 0 or #vim.fn.globpath(dir, "*.pde", false, true) > 0
end

local function has_project_marker(dir)
  local markers = { "arduino-cli.yaml", "sketch.yaml", "platformio.ini" }
  for _, marker in ipairs(markers) do
    if vim.fn.filereadable(dir .. "/" .. marker) == 1 then
      return true
    end
  end
  return false
end

local function sketch_ancestor(fname)
  local dir = vim.fn.fnamemodify(fname, ":p:h")

  while dir and dir ~= "" do
    if has_project_marker(dir) or has_sketch_file(dir) then
      return dir
    end

    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end
end

function M.root_dir(fname)
  fname = fname or buffer_name(0)
  if fname == "" then
    return nil
  end

  if fname:match("%.ino$") or fname:match("%.pde$") then
    return vim.fn.fnamemodify(fname, ":p:h")
  end

  return sketch_ancestor(fname)
end

function M.is_context_buffer(bufnr)
  bufnr = bufnr or 0
  local file = buffer_name(bufnr)
  if file == "" then
    return false
  end

  local ft = vim.bo[bufnr].filetype
  if ft == "arduino" then
    return true
  end

  return M.root_dir(file) ~= nil
end

function M.get_fqbn()
  return vim.g.arduino_fqbn or "arduino:avr:uno"
end

function M.get_baud()
  return tostring(vim.g.arduino_baud or "9600")
end

function M.profile_label()
  local id = vim.g.arduino_profile
  if not id or id == "" then
    return "Arduino Uno"
  end

  for _, profile in ipairs(M.profiles) do
    if profile.id == id then
      return profile.name
    end
  end

  return id
end

function M.context(bufnr)
  bufnr = bufnr or 0
  local file = buffer_name(bufnr)
  local ft = vim.bo[bufnr].filetype
  local root = file ~= "" and M.root_dir(file) or nil
  if ft == "arduino" and not root and file ~= "" then
    root = vim.fn.fnamemodify(file, ":p:h")
  end

  local active = ft == "arduino" or root ~= nil
  local port = vim.g.arduino_port
  if not port or port == "" then
    port = "Auto"
  end

  return {
    active = active,
    board = M.profile_label(),
    profile = vim.g.arduino_profile or "default",
    fqbn = M.get_fqbn(),
    baud = M.get_baud(),
    port = port,
    root = root or vim.fn.getcwd(),
    file = file ~= "" and vim.fn.fnamemodify(file, ":~:.") or "[No Name]",
    filetype = ft ~= "" and ft or "arduino",
    runner = "mise tasks",
  }
end

function M.context_label(bufnr)
  local ctx = M.context(bufnr)
  if not ctx.active then
    return ""
  end

  return string.format("%s · %s", ctx.board, ctx.port)
end

function M.context_summary(bufnr)
  local ctx = M.context(bufnr)
  if not ctx.active then
    return "No active Arduino/ESP context."
  end

  return table.concat({
    "Board: " .. ctx.board,
    "FQBN: " .. ctx.fqbn,
    "Port: " .. ctx.port,
    "Baud: " .. ctx.baud,
    "Root: " .. ctx.root,
    "File: " .. ctx.file,
    "Filetype: " .. ctx.filetype,
    "Runner: " .. ctx.runner,
  }, "\n")
end

function M.status()
  notify(M.context_summary(), vim.log.levels.INFO)
end

local function detect_ports()
  if not executable("arduino-cli") then
    return {}
  end

  local out = vim.fn.system({ "arduino-cli", "board", "list", "--format", "json" })
  local ok, data = pcall(vim.json.decode, out)
  if not ok or not data then
    return {}
  end

  local detected = data.detected_ports or data
  local ports = {}
  for _, entry in ipairs(detected) do
    local addr = entry.port and entry.port.address or ""
    if addr:match("ttyUSB") or addr:match("ttyACM") then
      local boards = entry.matching_boards or {}
      local board = boards[1] or {}
      table.insert(ports, {
        address = addr,
        fqbn = board.fqbn or "",
        name = board.name or "Unknown",
        label = string.format("%s | %s", addr, board.name or "Unknown Device"),
      })
    end
  end
  return ports
end

local function best_port()
  local ports = detect_ports()
  return ports[1] and ports[1].address or nil
end

local function set_env()
  vim.env.ARDUINO_FQBN = M.get_fqbn()
  vim.env.ARDUINO_BAUD = M.get_baud()
  if vim.g.arduino_port and vim.g.arduino_port ~= "" then
    vim.env.ARDUINO_PORT = vim.g.arduino_port
  end
end

function M.set_profile(profile)
  if not profile then
    return
  end

  vim.g.arduino_profile = profile.id
  vim.g.arduino_fqbn = profile.fqbn
  vim.g.arduino_baud = profile.baud
  set_env()

  notify("Profile set: " .. profile.name)

  for _, client in ipairs(vim.lsp.get_clients({ name = "arduino_language_server" })) do
    client.stop(true)
  end
  vim.defer_fn(function()
    vim.cmd("LspStart arduino_language_server")
  end, 200)
end

function M.board_select()
  vim.ui.select(M.profiles, {
    prompt = "Select Board Profile:",
    format_item = function(item)
      return item.name .. " (" .. item.fqbn .. ")"
    end,
  }, function(choice)
    M.set_profile(choice)
  end)
end

function M.port_select()
  local ports = detect_ports()
  if #ports == 0 then
    notify("No USB ports found.", vim.log.levels.WARN)
    return
  end

  vim.ui.select(ports, {
    prompt = "Select Serial Port:",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if choice then
      vim.g.arduino_port = choice.address
      set_env()
      notify("Port set: " .. choice.address)
    end
  end)
end

local function sketch_dir(bufnr)
  bufnr = bufnr or 0
  local file = buffer_name(bufnr)
  local root = file ~= "" and M.root_dir(file) or nil
  if root then
    return root
  end

  if file ~= "" then
    return vim.fn.fnamemodify(file, ":p:h")
  end

  return vim.fn.getcwd()
end

local function run_project_task(cmd)
  set_env()

  local ok, tmux = pcall(require, "config.tmux")
  local wrapped = string.format("ARDUINO_FQBN=%q ARDUINO_BAUD=%q %s", M.get_fqbn(), M.get_baud(), cmd)

  if vim.g.arduino_port and vim.g.arduino_port ~= "" then
    wrapped = string.format("ARDUINO_FQBN=%q ARDUINO_BAUD=%q ARDUINO_PORT=%q %s", M.get_fqbn(), M.get_baud(), vim.g.arduino_port, cmd)
  end

  if ok then
    tmux.split(wrapped, { cwd = sketch_dir(0), size = 15, title = "Arduino Task" })
  else
    vim.cmd("botright split | resize 15 | terminal " .. wrapped)
  end
end

function M.build()
  run_project_task("mise run arduino-build")
end

function M.upload()
  if not vim.g.arduino_port or vim.g.arduino_port == "" then
    vim.g.arduino_port = best_port()
  end
  run_project_task("mise run arduino-upload")
end

function M.monitor()
  if not vim.g.arduino_port or vim.g.arduino_port == "" then
    vim.g.arduino_port = best_port()
  end
  run_project_task("mise run arduino-monitor")
end

local function attach_context_keymaps(bufnr)
  if vim.b[bufnr].arduino_context_maps then
    return
  end

  vim.b[bufnr].arduino_context_maps = true

  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = bufnr, silent = true })
  end

  map("<leader>Ac", M.build, "Arduino: Build (mise)")
  map("<leader>Au", M.upload, "Arduino: Upload (mise)")
  map("<leader>Am", M.monitor, "Arduino: Monitor (mise)")
  map("<leader>Ab", M.board_select, "Arduino: Select Board")
  map("<leader>Ao", M.port_select, "Arduino: Select Port")
  map("<leader>As", M.status, "Arduino: Status")
  map("<leader>Ai", function()
    notify(M.context_summary(bufnr), vim.log.levels.INFO)
  end, "Arduino: Context")
end

function M.setup()
  local group = vim.api.nvim_create_augroup("sairu_arduino_context", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufReadPost", "FileType" }, {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      if M.is_context_buffer(bufnr) then
        attach_context_keymaps(bufnr)
      end
    end,
    desc = "Attach Arduino/ESP context keymaps when relevant",
  })

  vim.api.nvim_create_user_command("ArduinoContext", function()
    M.status()
  end, { desc = "Show current Arduino/ESP context" })

  if M.is_context_buffer(0) then
    attach_context_keymaps(0)
  end
end

function M.lsp_cmd()
  if not executable("arduino-language-server") then
    return nil
  end

  set_env()

  return {
    "arduino-language-server",
    "-cli-config",
    vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
    "-fqbn",
    M.get_fqbn(),
  }
end

return M
