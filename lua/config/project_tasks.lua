local M = {}

local runners = {
  mise = "mise",
  project_task = "project-task",
}

local default_actions = {
  "build",
  "run",
  "dev",
  "test",
  "check",
  "lint",
  "format",
  "clean",
  "setup",
  "qa",
  "typecheck",
}

local function executable(name)
  return vim.fn.executable(name) == 1
end

local function project_root()
  local file = vim.api.nvim_buf_get_name(0)
  local start = file ~= "" and file or vim.fn.getcwd()
  return vim.fs.root(start, { ".git", "mise.toml", ".mise.toml" }) or vim.fn.getcwd()
end

local function project_name()
  return vim.fs.basename(project_root())
end

local function runner_name()
  if executable(runners.mise) then
    return runners.mise
  end
  if executable(runners.project_task) then
    return runners.project_task
  end
  return nil
end

local function runner_command(task_name)
  local runner = runner_name()
  if not runner then
    return nil
  end

  if runner == runners.mise then
    return { runner, "run", task_name }
  end

  return { runner, task_name }
end

local function capture_command(command, cwd)
  local result = vim.system(command, {
    cwd = cwd,
    text = true,
  }):wait()

  return result.code or 1, result.stdout or "", result.stderr or ""
end

local function fetch_tasks()
  local runner = runner_name()
  if not runner then
    return {}
  end

  local command
  if runner == runners.mise then
    command = { runner, "tasks", "ls", "--json" }
  else
    command = { runner, "list", "--json" }
  end

  local code, output = capture_command(command, project_root())
  if code ~= 0 or output == "" then
    return {}
  end

  local ok, decoded = pcall(vim.json.decode, output)
  if not ok or type(decoded) ~= "table" then
    return {}
  end

  local tasks = {}
  for _, item in ipairs(decoded) do
    if type(item) == "table" and item.name then
      table.insert(tasks, {
        name = item.name,
        description = item.description or "",
        interactive = item.interactive == true,
        source = item.source or item.file or "",
      })
    end
  end

  table.sort(tasks, function(a, b)
    return a.name < b.name
  end)

  return tasks
end

local function describe_task(task)
  if not task then
    return "-"
  end

  local detail = task.description
  if detail == "" then
    detail = task.source
  end

  if detail ~= "" then
    return task.name .. " — " .. detail
  end

  return task.name
end

local function clean_lines(output)
  local lines = vim.split(output or "", "\n", { plain = true })
  while #lines > 0 and lines[#lines] == "" do
    table.remove(lines)
  end
  return lines
end

local function open_results(title, output, code)
  local lines = clean_lines(output)
  if #lines == 0 then
    lines = { code == 0 and "Task finished without output." or "Task failed without output." }
  end

  vim.fn.setqflist({}, "r", {
    title = title .. " [exit " .. tostring(code) .. "]",
    lines = lines,
  })

  if code == 0 then
    vim.cmd "cwindow"
  else
    vim.cmd "botright copen"
  end
end

local function run_job(task_name, title)
  local command = runner_command(task_name)
  if not command then
    vim.notify("No task runner available.", vim.log.levels.ERROR, { title = "Project Tasks" })
    return
  end

  vim.notify("Project task: " .. table.concat(command, " "), vim.log.levels.INFO, { title = "Project Tasks" })

  vim.system(command, {
    cwd = project_root(),
    text = true,
  }, function(result)
    vim.schedule(function()
      local output = table.concat({
        "$ " .. table.concat(command, " "),
        "",
        result.stdout or "",
        result.stderr or "",
      }, "\n")

      open_results(title or task_name, output, result.code or 0)
      local level = (result.code or 1) == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
      vim.notify((title or task_name) .. " exited with " .. tostring(result.code or 0), level, { title = "Project Tasks" })
    end)
  end)
end

local function run_terminal(task_name, title)
  local command = runner_command(task_name)
  if not command then
    vim.notify("No task runner available.", vim.log.levels.ERROR, { title = "Project Tasks" })
    return
  end

  require("config.tmux").split(table.concat(command, " "), {
    cwd = project_root(),
    size = 18,
    title = title or task_name,
  })
end

local function menu_items()
  local tasks = fetch_tasks()
  if #tasks == 0 then
    local fallback = {}
    for _, name in ipairs(default_actions) do
      table.insert(fallback, { label = name, action = name, empty = true })
    end
    return fallback
  end

  local items = {}
  for _, task in ipairs(tasks) do
    table.insert(items, {
      label = describe_task(task),
      action = task.name,
      interactive = task.interactive,
    })
  end

  return items
end

function M.info()
  local tasks = fetch_tasks()
  local lines = {
    "Project: " .. project_name(),
    "Root: " .. project_root(),
    "Runner: " .. (runner_name() or "-"),
    "Tasks: " .. tostring(#tasks),
    "",
  }

  if #tasks == 0 then
    table.insert(lines, "No mise/project-task tasks detected.")
    table.insert(lines, "Create tasks in the project root, then reload.")
  else
    for _, task in ipairs(tasks) do
      table.insert(lines, ("%-18s %s"):format(task.name, task.description ~= "" and task.description or task.source))
    end
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Project Tasks" })
end

function M.menu()
  local items = menu_items()
  vim.ui.select(items, {
    prompt = "Project task",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end

    if choice.empty then
      vim.notify("No mise tasks found for this project.", vim.log.levels.WARN, { title = "Project Tasks" })
      return
    end

    M.run(choice.action, { mode = choice.interactive and "terminal" or nil, title = choice.action })
  end)
end

function M.run(task_name, opts)
  opts = opts or {}
  if opts.mode == "terminal" then
    run_terminal(task_name, opts.title or task_name)
  else
    run_job(task_name, opts.title or task_name)
  end
end

function M.setup()
  local commands = {
    ProjectBuild = { task = "build" },
    ProjectRun = { task = "run" },
    ProjectDev = { task = "dev", mode = "terminal", title = "dev" },
    ProjectTest = { task = "test" },
    ProjectCheck = { task = "check" },
    ProjectLint = { task = "lint" },
    ProjectFormat = { task = "format" },
    ProjectClean = { task = "clean" },
    ProjectSetup = { task = "setup" },
    ProjectQA = { task = "qa" },
    ProjectTypecheck = { task = "typecheck" },
    ProjectTerminal = { task = "run", mode = "terminal", title = "terminal" },
  }

  for name, spec in pairs(commands) do
    vim.api.nvim_create_user_command(name, function()
      M.run(spec.task, spec)
    end, {})
  end

  vim.api.nvim_create_user_command("ProjectMenu", M.menu, {})
  vim.api.nvim_create_user_command("ProjectInfo", M.info, {})
  vim.api.nvim_create_user_command("ProjectTasks", M.info, {})

  vim.api.nvim_create_user_command("Build", function()
    M.run("build")
  end, {})
  vim.api.nvim_create_user_command("Run", function()
    M.run("run")
  end, {})
  vim.api.nvim_create_user_command("Test", function()
    M.run("test")
  end, {})
  vim.api.nvim_create_user_command("Check", function()
    M.run("check")
  end, {})

  local map = vim.keymap.set
  map("n", "<leader>mm", M.menu, { desc = "Project Menu" })
  map("n", "<leader>mi", M.info, { desc = "Project Info" })
  map("n", "<leader>mb", "<cmd>ProjectBuild<cr>", { desc = "Project Build" })
  map("n", "<leader>mr", "<cmd>ProjectRun<cr>", { desc = "Project Run" })
  map("n", "<leader>md", "<cmd>ProjectDev<cr>", { desc = "Project Dev Server" })
  map("n", "<leader>mt", "<cmd>ProjectTest<cr>", { desc = "Project Test" })
  map("n", "<leader>mc", "<cmd>ProjectCheck<cr>", { desc = "Project Check" })
  map("n", "<leader>ml", "<cmd>ProjectLint<cr>", { desc = "Project Lint" })
  map("n", "<leader>mf", "<cmd>ProjectFormat<cr>", { desc = "Project Format" })
  map("n", "<leader>mx", "<cmd>ProjectClean<cr>", { desc = "Project Clean" })
  map("n", "<leader>mS", "<cmd>ProjectSetup<cr>", { desc = "Project Setup" })
  map("n", "<leader>mQ", "<cmd>ProjectQA<cr>", { desc = "Project QA" })
  map("n", "<leader>mT", "<cmd>ProjectTerminal<cr>", { desc = "Project Run Terminal" })
end

M.setup()

return M
