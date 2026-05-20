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

local function sketch_dir()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" and (file:match("%.ino$") or file:match("%.pde$")) then
    return vim.fn.fnamemodify(file, ":p:h")
  end
  return vim.fn.getcwd()
end

function M.get_fqbn()
  return vim.g.arduino_fqbn or "arduino:avr:uno"
end

function M.get_baud()
  return tostring(vim.g.arduino_baud or "9600")
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

local function run_project_task(cmd)
  set_env()

  local ok, tmux = pcall(require, "config.tmux")
  local wrapped = string.format("ARDUINO_FQBN=%q ARDUINO_BAUD=%q %s", M.get_fqbn(), M.get_baud(), cmd)

  if vim.g.arduino_port and vim.g.arduino_port ~= "" then
    wrapped = string.format("ARDUINO_FQBN=%q ARDUINO_BAUD=%q ARDUINO_PORT=%q %s", M.get_fqbn(), M.get_baud(), vim.g.arduino_port, cmd)
  end

  if ok then
    tmux.split(wrapped, { cwd = sketch_dir(), size = 15, title = "Arduino Task" })
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

function M.status()
  notify(
    string.format(
      "Board: %s\nFQBN: %s\nPort: %s\nBaud: %s\nRunner: mise tasks",
      vim.g.arduino_profile or "Default",
      M.get_fqbn(),
      vim.g.arduino_port or "Auto",
      M.get_baud()
    )
  )
end

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "arduino",
    callback = function()
      vim.keymap.set("n", "<leader>Ac", M.build, { desc = "Arduino: Build (mise)", buffer = true })
      vim.keymap.set("n", "<leader>Au", M.upload, { desc = "Arduino: Upload (mise)", buffer = true })
      vim.keymap.set("n", "<leader>Am", M.monitor, { desc = "Arduino: Monitor (mise)", buffer = true })
      vim.keymap.set("n", "<leader>Ab", M.board_select, { desc = "Arduino: Select Board", buffer = true })
      vim.keymap.set("n", "<leader>Ao", M.port_select, { desc = "Arduino: Select Port", buffer = true })
      vim.keymap.set("n", "<leader>As", M.status, { desc = "Arduino: Status", buffer = true })
    end,
  })
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
