-- Tasks: Multi-language task runner with auto-detection
-- Provides shell wrapper integration (ab, au, am, anew, aI) and mise tasks
local M = {}

M.shell_wrappers = {
  ab = { desc = "Arduino Build (CLI)", cmd = { "arduino-cli", "compile" } },
  au = { desc = "Arduino Upload (CLI)", cmd = { "arduino-cli", "upload" } },
  am = { desc = "Arduino Monitor (CLI)", cmd = { "arduino-cli", "monitor" } },
  anew = { desc = "Arduino New Sketch", cmd = { "arduino-cli", "sketch", "new" } },
  aI = { desc = "Arduino LSP: Generate compile_commands.json", cmd = { "pio", "run", "-t", "compiledb" } },
  aup = { desc = "PlatformIO Upload", cmd = { "pio", "run", "-t", "upload" } },
  abp = { desc = "PlatformIO Build", cmd = { "pio", "run" } },
  amp = { desc = "PlatformIO Monitor", cmd = { "pio", "device", "monitor" } },
  acp = { desc = "PlatformIO Clean", cmd = { "pio", "run", "-t", "clean" } },
}

M.mise_tasks = {
  arduino = {
    "arduino-build",
    "arduino-upload",
    "arduino-monitor",
    "arduino-clean",
    "arduino-compiledb",
    "arduino-list",
    "arduino-new",
    "esp-build",
    "esp-flash",
    "esp-monitor",
  },
  csharp = { "dotnet-build", "dotnet-run", "dotnet-test", "dotnet-clean", "dotnet-watch", "dotnet-new" },
  go = { "go-build", "go-run", "go-test", "go-lint", "go-fmt", "go-tidy" },
  rust = { "cargo-build", "cargo-run", "cargo-test", "cargo-check", "cargo-clippy", "cargo-fmt", "cargo-doc" },
  python = { "pip-install", "uv-sync", "pytest", "ruff-lint", "ruff-fmt", "mypy" },
  node = { "npm-install", "npm-dev", "npm-build", "npm-test", "pnpm-dev", "pnpm-build" },
  cpp = { "cmake-configure", "cmake-build", "cmake-clean", "make", "ninja" },
  java = { "maven-build", "maven-test", "gradle-build", "gradle-test" },
  zig = { "zig-build", "zig-run", "zig-test" },
  lua = { "stylua", "luarocks-install", "busted" },
}

function M.get_available_mise_tasks()
  local tools = vim.fn.system("mise tools --json 2>/dev/null")
  local ok, data = pcall(vim.fn.json_decode, tools)
  if not ok or not data then
    return {}
  end
  local available = {}
  for _, tool in ipairs(data) do
    available[tool.name] = true
  end
  return available
end

function M.get_language_tasks(lang)
  local base = M.mise_tasks[lang] or {}
  local available = M.get_available_mise_tasks()
  local result = {}
  for _, task in ipairs(base) do
    -- Check if mise tool exists for this task
    local tool_name = task:match("^([^%-]+)")
    if available[tool_name] or tool_name == "arduino" then
      table.insert(result, task)
    end
  end
  return result
end

function M.run_mise_task(task, args)
  local cmd = { "mise", "run", task }
  if args then
    vim.list_extend(cmd, args)
  end
  local root = vim.fn.getcwd()
  vim.cmd("split | terminal cd " .. vim.fn.shellescape(root) .. " && " .. table.concat(cmd, " "))
end

function M.run_shell_wrapper(wrapper, args)
  local w = M.shell_wrappers[wrapper]
  if not w then
    vim.notify("Unknown shell wrapper: " .. wrapper, vim.log.levels.ERROR)
    return
  end
  local cmd = vim.deepcopy(w.cmd)
  if args then
    vim.list_extend(cmd, args)
  end
  local root = vim.fn.getcwd()
  vim.cmd("split | terminal cd " .. vim.fn.shellescape(root) .. " && " .. table.concat(cmd, " "))
end

function M.setup_shell_wrapper_keymaps()
  local wk = require("which-key")
  local specs = {}

  -- Arduino/ESP32 wrappers
  for key, wrap in pairs({
    ab = "Arduino Build (CLI)",
    au = "Arduino Upload (CLI)",
    am = "Arduino Monitor (CLI)",
    anew = "New Arduino Sketch",
    aI = "Generate compile_commands.json (LSP)",
    abp = "PlatformIO Build",
    aup = "PlatformIO Upload",
    amp = "PlatformIO Monitor",
    acp = "PlatformIO Clean",
  }) do
    specs[key] = {
      function()
        M.run_shell_wrapper(key)
      end,
      desc = wrap,
      icon = "󰜺",
    }
  end

  wk.add(specs, { mode = "n", prefix = "<leader>" })
end

function M.pick_task()
  local detected = require("config.workflows").detect_project()
  local all_tasks = {}

  for lang, _ in pairs(detected) do
    local tasks = M.get_language_tasks(lang)
    for _, task in ipairs(tasks) do
      table.insert(all_tasks, {
        text = "󱁤 " .. lang .. " › " .. task,
        lang = lang,
        task = task,
      })
    end
  end

  if #all_tasks == 0 then
    -- Fallback to shell wrappers
    for key, wrap in pairs(M.shell_wrappers) do
      table.insert(all_tasks, {
        text = "󱁤 wrapper › " .. key,
        wrapper = key,
      })
    end
  end

  vim.ui.select(all_tasks, {
    prompt = "Select task:",
    format_item = function(item)
      return item.text
    end,
  }, function(choice)
    if choice then
      if choice.lang then
        M.run_mise_task(choice.task)
      elseif choice.wrapper then
        M.run_shell_wrapper(choice.wrapper)
      end
    end
  end)
end

function M.setup_arduino_specific()
  -- ESP32 variant quick compiles (manual override)
  local esp32_fqbns = {
    dev = "esp32:esp32:esp32",
    cam = "esp32:esp32:esp32cam",
    s3 = "esp32:esp32:esp32s3",
    s2 = "esp32:esp32:esp32s2",
    c3 = "esp32:esp32:esp32c3",
    c6 = "esp32:esp32:esp32c6",
    h2 = "esp32:esp32:esp32h2",
    p4 = "esp32:esp32:esp32p4",
    m5stack = "esp32:esp32:m5stack-core-esp32",
    m5atom = "esp32:esp32:m5stack-atom",
    m5stamps3 = "esp32:esp32:m5stack-stamps3",
    xiao_c3 = "esp32:esp32:seeed-xiao-esp32c3",
    xiao_s3 = "esp32:esp32:seeed-xiao-esp32s3",
    wt32 = "esp32:esp32:wt32-eth01",
  }

  return esp32_fqbns
end

function M.compile_esp32_variant(variant)
  local fqbns = M.setup_arduino_specific()
  local fqbn = fqbns[variant] or fqbns.dev
  local cmd = { "arduino-cli", "compile", "--fqbn", fqbn }
  local root = vim.fn.getcwd()
  vim.cmd("split | terminal cd " .. vim.fn.shellescape(root) .. " && " .. table.concat(cmd, " "))
end

function M.upload_esp32_variant(variant)
  local fqbns = M.setup_arduino_specific()
  local fqbn = fqbns[variant] or fqbns.dev
  local board = require("config.workflows").detect_arduino_board()
  if not board then
    vim.notify("No board detected for upload", vim.log.levels.WARN)
    return
  end
  local cmd = { "arduino-cli", "upload", "-p", board.port, "--fqbn", fqbn }
  local root = vim.fn.getcwd()
  vim.cmd("split | terminal cd " .. vim.fn.shellescape(root) .. " && " .. table.concat(cmd, " "))
end

function M.setup()
  -- User commands
  vim.api.nvim_create_user_command("TaskRun", function(opts)
    if opts.args and opts.args ~= "" then
      M.run_mise_task(opts.args, vim.split(opts.fargs, " "))
    else
      M.pick_task()
    end
  end, {
    nargs = "*",
    complete = function()
      return vim.tbl_keys(M.mise_tasks)
    end,
    desc = "Run mise task",
  })

  vim.api.nvim_create_user_command("ArduinoVariant", function(opts)
    if opts.args and opts.args ~= "" then
      M.compile_esp32_variant(opts.args)
    else
      vim.notify("Usage: ArduinoVariant <variant>", vim.log.levels.ERROR)
    end
  end, {
    nargs = 1,
    complete = function()
      return vim.tbl_keys(M.setup_arduino_specific())
    end,
    desc = "Compile ESP32 variant",
  })

  vim.api.nvim_create_user_command("ArduinoUploadVariant", function(opts)
    if opts.args and opts.args ~= "" then
      M.upload_esp32_variant(opts.args)
    else
      vim.notify("Usage: ArduinoUploadVariant <variant>", vim.log.levels.ERROR)
    end
  end, {
    nargs = 1,
    complete = function()
      return vim.tbl_keys(M.setup_arduino_specific())
    end,
    desc = "Upload ESP32 variant",
  })

  -- Shell wrapper aliases
  for key, _ in pairs(M.shell_wrappers) do
    vim.api.nvim_create_user_command(key:upper(), function()
      M.run_shell_wrapper(key)
    end, { desc = "Run shell wrapper: " .. key })
  end

  M.setup_shell_wrapper_keymaps()
end

return M
