-- Project Tasks
--
-- Camada única para build/run/test/check/dev em projetos reais.
-- A ideia é agir como um workbench: detectar o projeto, escolher o comando
-- correto, mostrar resultado em quickfix e abrir servidores em janela do tmux.

local M = {}

local root_markers = {
  ".git",
  "package.json",
  "pnpm-lock.yaml",
  "yarn.lock",
  "bun.lock",
  "bun.lockb",
  "pyproject.toml",
  "requirements.txt",
  "manage.py",
  "go.mod",
  "go.work",
  "Cargo.toml",
  "pom.xml",
  "mvnw",
  "build.gradle",
  "build.gradle.kts",
  "gradlew",
  "Makefile",
  "CMakeLists.txt",
  "meson.build",
  "platformio.ini",
  "arduino-cli.yaml",
  "sketch.yaml",
  "composer.json",
  "mix.exs",
  "deno.json",
  "deno.jsonc",
  "gleam.toml",
  "build.zig",
  "docker-compose.yml",
  "compose.yml",
}

local shell = vim.o.shell ~= "" and vim.o.shell or "/bin/sh"

local function root()
  return vim.fs.root(0, root_markers) or vim.fn.getcwd()
end

local function current_file()
  local name = vim.api.nvim_buf_get_name(0)
  return name ~= "" and name or nil
end

local function exists(path)
  return path and vim.uv.fs_stat(path) ~= nil
end

local function has(name)
  return exists(root() .. "/" .. name)
end

local function executable(name)
  return vim.fn.executable(name) == 1
end

local function esc(path)
  return vim.fn.shellescape(path)
end

local function project_name()
  return vim.fn.fnamemodify(root(), ":t")
end

local function read_json(path)
  if not exists(path) then
    return nil
  end

  local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
  return ok and decoded or nil
end

local function package_json()
  return read_json(root() .. "/package.json")
end

local function package_manager()
  if has "bun.lock" or has "bun.lockb" then
    return "bun"
  end
  if has "pnpm-lock.yaml" then
    return "pnpm"
  end
  if has "yarn.lock" then
    return "yarn"
  end
  return "npm"
end

local function package_run(script)
  local pm = package_manager()
  if pm == "npm" then
    return "npm run " .. script
  end
  if pm == "yarn" then
    return "yarn " .. script
  end
  if pm == "pnpm" then
    return "pnpm " .. script
  end
  if pm == "bun" then
    return "bun run " .. script
  end
  return pm .. " run " .. script
end

local function script_command(names)
  local pkg = package_json()
  local scripts = pkg and pkg.scripts or {}
  for _, name in ipairs(names) do
    if scripts[name] then
      return package_run(name), name
    end
  end
  return nil, nil
end

local function python_bin()
  local candidates = {
    root() .. "/.venv/bin/python",
    root() .. "/venv/bin/python",
  }

  for _, candidate in ipairs(candidates) do
    if exists(candidate) then
      return esc(candidate)
    end
  end

  return executable "python3" and "python3" or "python"
end

local function node_single_file(action, file)
  local ext = vim.fn.fnamemodify(file, ":e")
  if action == "run" then
    if ext == "ts" or ext == "tsx" then
      if executable "tsx" then
        return "tsx " .. esc(file)
      end
      return "npx tsx " .. esc(file)
    end
    if ext == "jsx" then
      return "node " .. esc(file)
    end
    return "node " .. esc(file)
  end

  if action == "check" and (ext == "ts" or ext == "tsx") then
    return "npx tsc --noEmit"
  end

  return nil
end

local function c_output(file)
  local stem = vim.fn.fnamemodify(file, ":t:r")
  return "build/" .. stem
end

local resolvers = {}

resolvers.node = function(action)
  if not has "package.json" then
    return nil
  end

  local script_map = {
    build = { "build", "compile" },
    run = { "start", "preview" },
    dev = { "dev", "serve", "start" },
    test = { "test", "test:unit", "vitest" },
    check = { "check", "typecheck", "lint", "test" },
    lint = { "lint", "eslint" },
    format = { "format", "fmt" },
    clean = { "clean" },
  }

  local command, script = script_command(script_map[action] or {})
  if command then
    return {
      command = command,
      label = "node:" .. script,
      kind = action == "dev" and "server" or "job",
    }
  end

  local file = current_file()
  if file then
    local single = node_single_file(action, file)
    if single then
      return { command = single, label = "node:file", kind = "job" }
    end
  end

  return nil
end

resolvers.deno = function(action)
  if not (has "deno.json" or has "deno.jsonc") then
    return nil
  end

  local commands = {
    build = "deno task build",
    run = "deno task start",
    dev = "deno task dev",
    test = "deno test",
    check = "deno check .",
    lint = "deno lint",
    format = "deno fmt",
  }

  if commands[action] then
    return { command = commands[action], label = "deno", kind = action == "dev" and "server" or "job" }
  end
end

resolvers.python = function(action)
  if not (has "pyproject.toml" or has "requirements.txt" or has "manage.py" or vim.bo.filetype == "python") then
    return nil
  end

  local py = python_bin()
  local file = current_file()

  if action == "build" and has "pyproject.toml" then
    return { command = py .. " -m build", label = "python:build", kind = "job" }
  end
  if action == "run" and file then
    return { command = py .. " " .. esc(file), label = "python:file", kind = "job" }
  end
  if action == "dev" and has "manage.py" then
    return { command = py .. " manage.py runserver", label = "django", kind = "server" }
  end
  if action == "dev" and has "main.py" then
    return { command = "uvicorn main:app --reload", label = "uvicorn", kind = "server" }
  end
  if action == "dev" and has "app/main.py" then
    return { command = "uvicorn app.main:app --reload", label = "uvicorn", kind = "server" }
  end
  if action == "test" then
    return { command = "pytest -q", label = "pytest", kind = "job" }
  end
  if action == "check" or action == "lint" then
    return { command = "ruff check .", label = "ruff", kind = "job" }
  end
  if action == "format" then
    return { command = "ruff format . && ruff check --fix .", label = "ruff format", kind = "job" }
  end
end

resolvers.rust = function(action)
  if not has "Cargo.toml" then
    return nil
  end

  local commands = {
    build = "cargo build",
    run = "cargo run",
    dev = "cargo run",
    test = "cargo test",
    check = "cargo clippy --all-targets --all-features -- -D warnings",
    lint = "cargo clippy --all-targets --all-features",
    format = "cargo fmt --all",
    clean = "cargo clean",
  }

  if commands[action] then
    return { command = commands[action], label = "cargo", kind = action == "dev" and "server" or "job" }
  end
end

resolvers.go = function(action)
  if not (has "go.mod" or has "go.work" or vim.bo.filetype == "go") then
    return nil
  end

  local commands = {
    build = "go build ./...",
    run = "go run .",
    dev = "go run .",
    test = "go test ./...",
    check = "go vet ./...",
    lint = "golangci-lint run",
    format = "gofmt -w . && goimports -w .",
    clean = "go clean -cache -testcache",
  }

  if commands[action] then
    return { command = commands[action], label = "go", kind = action == "dev" and "server" or "job" }
  end
end

resolvers.java = function(action)
  if has "gradlew" then
    local commands = {
      build = "./gradlew build",
      run = "./gradlew run",
      dev = "./gradlew bootRun",
      test = "./gradlew test",
      check = "./gradlew check",
      clean = "./gradlew clean",
    }
    if commands[action] then
      return { command = commands[action], label = "gradle", kind = action == "dev" and "server" or "job" }
    end
  end

  if has "pom.xml" or has "mvnw" then
    local mvn = has "mvnw" and "./mvnw" or "mvn"
    local commands = {
      build = mvn .. " compile",
      run = mvn .. " exec:java",
      dev = mvn .. " spring-boot:run",
      test = mvn .. " test",
      check = mvn .. " verify",
      clean = mvn .. " clean",
    }
    if commands[action] then
      return { command = commands[action], label = "maven", kind = action == "dev" and "server" or "job" }
    end
  end

  local file = current_file()
  if vim.bo.filetype == "java" and file then
    local class = vim.fn.fnamemodify(file, ":t:r")
    local dir = vim.fn.fnamemodify(file, ":h")
    if action == "build" or action == "check" then
      return { command = "javac " .. esc(file), label = "javac", kind = "job" }
    end
    if action == "run" then
      return { command = "javac " .. esc(file) .. " && java -cp " .. esc(dir) .. " " .. class, label = "java:file", kind = "job" }
    end
  end
end

resolvers.cmake = function(action)
  if not has "CMakeLists.txt" then
    return nil
  end

  local commands = {
    build = "cmake -S . -B build && cmake --build build",
    test = "ctest --test-dir build --output-on-failure",
    check = "cmake --build build",
    clean = "cmake --build build --target clean",
  }

  if commands[action] then
    return { command = commands[action], label = "cmake", kind = "job" }
  end
end

resolvers.make = function(action)
  if not has "Makefile" then
    return nil
  end

  local commands = {
    build = "make",
    run = "make run",
    dev = "make dev",
    test = "make test",
    check = "make check",
    lint = "make lint",
    format = "make format",
    clean = "make clean",
  }

  if commands[action] then
    return { command = commands[action], label = "make", kind = action == "dev" and "server" or "job" }
  end
end

resolvers.c_cpp = function(action)
  local ft = vim.bo.filetype
  local file = current_file()
  if not file or (ft ~= "c" and ft ~= "cpp" and ft ~= "objc" and ft ~= "objcpp") then
    return nil
  end

  local compiler = (ft == "cpp" or ft == "objcpp") and "g++" or "gcc"
  local std = (ft == "cpp" or ft == "objcpp") and "-std=c++20" or "-std=c17"
  local output = c_output(file)
  local compile = "mkdir -p build && " .. compiler .. " " .. std .. " -Wall -Wextra -Wpedantic -g " .. esc(file) .. " -o " .. esc(output)

  if action == "build" or action == "check" then
    return { command = compile, label = compiler, kind = "job" }
  end
  if action == "run" then
    return { command = compile .. " && " .. esc(root() .. "/" .. output), label = compiler .. ":run", kind = "job" }
  end
  if action == "lint" then
    return { command = "clang-tidy " .. esc(file), label = "clang-tidy", kind = "job" }
  end
  if action == "format" then
    return { command = "clang-format -i " .. esc(file), label = "clang-format", kind = "job" }
  end
end

resolvers.arduino = function(action)
  if not (vim.bo.filetype == "arduino" or has "arduino-cli.yaml" or has "sketch.yaml") then
    return nil
  end

  local fqbn = vim.g.arduino_fqbn or "arduino:avr:uno"
  local baud = tostring(vim.g.arduino_baud or "9600")
  local port = vim.g.arduino_port or ""
  local env = "ARDUINO_FQBN=" .. vim.fn.shellescape(fqbn) .. " ARDUINO_BAUD=" .. vim.fn.shellescape(baud)
  if port ~= "" then
    env = env .. " ARDUINO_PORT=" .. vim.fn.shellescape(port)
  end

  local commands = {
    build = env .. " mise run arduino-build",
    run = env .. " mise run arduino-upload",
    dev = env .. " mise run arduino-monitor",
    clean = env .. " mise run arduino-clean",
    check = env .. " mise run arduino-status",
  }

  if commands[action] then
    return { command = commands[action], label = "arduino:mise", kind = action == "dev" and "server" or "job" }
  end
end

resolvers.lua = function(action)
  if vim.bo.filetype ~= "lua" and not has ".luarc.json" and not has "stylua.toml" then
    return nil
  end

  local file = current_file()
  local commands = {
    run = file and ("lua " .. esc(file)) or nil,
    test = "busted",
    check = "luacheck .",
    lint = "selene .",
    format = "stylua .",
  }

  if commands[action] then
    return { command = commands[action], label = "lua", kind = "job" }
  end
end

resolvers.shell = function(action)
  local ft = vim.bo.filetype
  local file = current_file()
  if not file or (ft ~= "sh" and ft ~= "bash" and ft ~= "zsh" and ft ~= "fish") then
    return nil
  end

  if action == "run" then
    local runner = ft == "zsh" and "zsh" or ft == "fish" and "fish" or "bash"
    return { command = runner .. " " .. esc(file), label = "shell:file", kind = "job" }
  end
  if action == "check" or action == "lint" then
    return { command = "shellcheck " .. esc(file), label = "shellcheck", kind = "job" }
  end
  if action == "format" and ft ~= "fish" then
    return { command = "shfmt -w " .. esc(file), label = "shfmt", kind = "job" }
  end
end

resolvers.docker = function(action)
  if not (has "docker-compose.yml" or has "docker-compose.yaml" or has "compose.yml" or has "compose.yaml") then
    return nil
  end

  local compose = "docker compose"
  local commands = {
    build = compose .. " build",
    dev = compose .. " up",
    run = compose .. " up",
    check = compose .. " config",
    clean = compose .. " down",
  }

  if commands[action] then
    return { command = commands[action], label = "docker compose", kind = action == "dev" and "server" or "job" }
  end
end

resolvers.php = function(action)
  if not has "composer.json" then
    return nil
  end

  local commands = {
    build = "composer install",
    run = "php -S localhost:8000 -t public",
    dev = "php -S localhost:8000 -t public",
    test = "composer test",
    check = "composer validate",
    lint = "composer lint",
    format = "composer format",
  }

  if commands[action] then
    return { command = commands[action], label = "composer", kind = action == "dev" and "server" or "job" }
  end
end

resolvers.zig = function(action)
  if not has "build.zig" then
    return nil
  end

  local commands = {
    build = "zig build",
    run = "zig build run",
    test = "zig build test",
    check = "zig build",
    format = "zig fmt .",
  }

  if commands[action] then
    return { command = commands[action], label = "zig", kind = "job" }
  end
end

local resolver_order = {
  "arduino",
  "node",
  "deno",
  "python",
  "rust",
  "go",
  "java",
  "cmake",
  "make",
  "c_cpp",
  "lua",
  "shell",
  "docker",
  "php",
  "zig",
}

local function resolve(action)
  for _, name in ipairs(resolver_order) do
    local task = resolvers[name](action)
    if task then
      task.action = action
      task.resolver = name
      task.cwd = root()
      task.title = ("%s:%s"):format(action, project_name())
      return task
    end
  end
  return nil
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
    title = title .. " [exit " .. code .. "]",
    lines = lines,
  })

  if code == 0 then
    vim.cmd "cwindow"
  else
    vim.cmd "botright copen"
  end
end

local function run_job(task)
  vim.notify("Project task: " .. task.command, vim.log.levels.INFO, { title = task.label })

  vim.system({ shell, "-lc", task.command }, {
    cwd = task.cwd,
    text = true,
  }, function(result)
    vim.schedule(function()
      local output = table.concat({
        "$ " .. task.command,
        "",
        result.stdout or "",
        result.stderr or "",
      }, "\n")

      open_results(task.title, output, result.code or 0)
      local level = result.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
      vim.notify(task.title .. " exited with " .. tostring(result.code), level, { title = "Project Tasks" })
    end)
  end)
end

local function run_server(task)
  local tmux = require "config.tmux"
  local banner = table.concat({
    "printf '\\033[1;36m%s\\033[0m\\n' " .. esc("Project server: " .. task.label),
    "printf '%s\\n\\n' " .. esc("$ " .. task.command),
    task.command,
    "code=$?",
    "printf '\\n\\033[1;33m[server exited: %s]\\033[0m\\n' \"$code\"",
    "exec " .. esc(shell),
  }, "; ")

  tmux.window(banner, {
    cwd = task.cwd,
    title = "dev:" .. project_name(),
  })
end

local function run_terminal(task)
  require("config.tmux").split(task.command, {
    cwd = task.cwd,
    size = 18,
  })
end

local function run_task(action, mode)
  local task = resolve(action)
  if not task then
    vim.notify("No project task found for: " .. action, vim.log.levels.WARN, { title = "Project Tasks" })
    return
  end

  if task.kind == "nvim_command" then
    vim.cmd(task.command)
    return
  end

  if mode == "terminal" then
    run_terminal(task)
  elseif mode == "server" or task.kind == "server" then
    run_server(task)
  else
    run_job(task)
  end
end

function M.info()
  local lines = {
    "Project: " .. project_name(),
    "Root: " .. root(),
    "Filetype: " .. vim.bo.filetype,
    "",
  }

  for _, action in ipairs({ "build", "run", "dev", "test", "check", "lint", "format", "clean" }) do
    local task = resolve(action)
    table.insert(lines, ("%8s  %s"):format(action, task and (task.label .. " -> " .. task.command) or "-"))
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Project Tasks" })
end

function M.menu()
  local actions = {
    { label = "Build", action = "build" },
    { label = "Run", action = "run" },
    { label = "Dev Server", action = "dev", mode = "server" },
    { label = "Test", action = "test" },
    { label = "Check", action = "check" },
    { label = "Lint", action = "lint" },
    { label = "Format", action = "format" },
    { label = "Clean", action = "clean" },
    { label = "Info", action = "info" },
  }

  vim.ui.select(actions, {
    prompt = "Project task",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    if choice.action == "info" then
      M.info()
    else
      run_task(choice.action, choice.mode)
    end
  end)
end

function M.setup()
  local commands = {
    ProjectBuild = { action = "build" },
    ProjectRun = { action = "run" },
    ProjectDev = { action = "dev", mode = "server" },
    ProjectTest = { action = "test" },
    ProjectCheck = { action = "check" },
    ProjectLint = { action = "lint" },
    ProjectFormat = { action = "format" },
    ProjectClean = { action = "clean" },
    ProjectTerminal = { action = "run", mode = "terminal" },
  }

  for name, spec in pairs(commands) do
    vim.api.nvim_create_user_command(name, function()
      run_task(spec.action, spec.mode)
    end, {})
  end

  vim.api.nvim_create_user_command("ProjectMenu", M.menu, {})
  vim.api.nvim_create_user_command("ProjectInfo", M.info, {})

  -- Aliases curtos para fluxo rápido no command-line.
  vim.api.nvim_create_user_command("Build", function()
    run_task "build"
  end, {})
  vim.api.nvim_create_user_command("Run", function()
    run_task "run"
  end, {})
  vim.api.nvim_create_user_command("Test", function()
    run_task "test"
  end, {})
  vim.api.nvim_create_user_command("Check", function()
    run_task "check"
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
  map("n", "<leader>mT", "<cmd>ProjectTerminal<cr>", { desc = "Project Run Terminal" })
end

M.setup()

return M
