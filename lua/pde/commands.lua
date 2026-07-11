local M = {}

local function echo(lines)
  local chunks = {}
  for _, line in ipairs(lines) do
    table.insert(chunks, { line .. "\n", "Normal" })
  end
  vim.api.nvim_echo(chunks, false, {})
end

local function lsp_names(bufnr)
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr or 0 })) do
    table.insert(names, client.name)
  end
  table.sort(names)
  return table.concat(names, ", ")
end

local function status()
  local info = require("pde.detect").detect(0)
  local tasks = require("pde.tasks").list(info.root)
  local lines = {
    "PDE Status",
    "root: " .. info.root,
    "type: " .. info.type,
    "framework: " .. info.framework,
    "marker: " .. tostring(info.marker),
    "has .mise.toml: " .. tostring(info.has_mise),
    "has pde.toml: " .. tostring(info.has_pde),
    "compile_commands.json: " .. tostring(info.has_compile_db),
    "lsp: " .. (lsp_names(0) ~= "" and lsp_names(0) or "none"),
    "mise tasks: " .. (#tasks > 0 and table.concat(tasks, ", ") or "none"),
  }
  if info.type == "embedded" then
    vim.list_extend(lines, require("pde.arduino").status_lines(0))
  end
  echo(lines)
end

local command_to_task = {
  PDEDoctor = "pde-doctor",
  PDEVersion = "pde-version",
  PDEDev = "dev",
  PDEBuild = "build",
  PDETest = "test",
  PDELint = "lint",
  PDEFormat = "format",
  PDETypecheck = "typecheck",
  PDERun = "run",
  PDEBoards = "arduino-boards",
  PDEArduinoCompileDB = "arduino-compile-db",
  PDEArduinoCompile = "arduino-compile",
  PDEArduinoUpload = "arduino-upload",
  PDEArduinoFlash = "arduino-flash",
  PDEArduinoMonitor = "arduino-monitor",
}

local quickfix_tasks = {
  build = true,
  test = true,
  lint = true,
  typecheck = true,
  ["arduino-compile"] = true,
}

function M.setup()
  vim.api.nvim_create_user_command("PDEStatus", status, { desc = "Show PDE project status" })
  vim.api.nvim_create_user_command("PDEFramework", function()
    local info = require("pde.detect").detect(0)
    echo({ info.type .. ": " .. info.framework })
  end, { desc = "Show detected framework" })
  vim.api.nvim_create_user_command("PDEToolchain", function()
    local root = require("pde.detect").root(0)
    vim.cmd("botright split")
    vim.cmd("terminal cd " .. vim.fn.fnameescape(root) .. " && mise ls --current")
  end, { desc = "Show active mise toolchain" })
  vim.api.nvim_create_user_command("PDEOpenMise", function()
    local path = require("pde.detect").root(0) .. "/.mise.toml"
    if vim.uv.fs_stat(path) then vim.cmd.edit(path) else vim.notify("project does not define .mise.toml", vim.log.levels.WARN) end
  end, { desc = "Open project .mise.toml" })
  vim.api.nvim_create_user_command("PDEOpenProjectConfig", function()
    local path = require("pde.detect").root(0) .. "/pde.toml"
    if vim.uv.fs_stat(path) then vim.cmd.edit(path) else vim.notify("project does not define pde.toml", vim.log.levels.WARN) end
  end, { desc = "Open project pde.toml" })
  vim.api.nvim_create_user_command("PDEQuickfix", "copen", { desc = "Open quickfix" })
  vim.api.nvim_create_user_command("PDESnippets", function()
    require("pde.snippets").list()
  end, { desc = "List snippets for current filetype" })
  vim.api.nvim_create_user_command("PDESnippet", function(args)
    if args.args == "" then
      require("pde.snippets").pick()
    else
      require("pde.snippets").insert(args.args)
    end
  end, { nargs = "?", desc = "Insert snippet by name" })
  vim.api.nvim_create_user_command("PDEArduinoProfile", function()
    echo(require("pde.arduino").status_lines(0))
  end, { desc = "Show Arduino PDE profile" })
  vim.api.nvim_create_user_command("PDEArduinoRestartLSP", function()
    vim.cmd("LspRestart arduino_language_server")
  end, { desc = "Restart Arduino language server" })

  for command, task in pairs(command_to_task) do
    vim.api.nvim_create_user_command(command, function()
      require("pde.tasks").run(task, { quickfix = quickfix_tasks[task] })
    end, { desc = "Run mise task " .. task })
  end
end

return M
