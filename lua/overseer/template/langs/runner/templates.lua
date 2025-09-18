-- lua/overseer/template/langs/runner/templates.lua

local overseer = require("overseer")
local uv = vim.uv or vim.loop

-- ===== utils =====
local function exists(p) return p and uv.fs_stat(p) ~= nil end
local function cwd() return vim.fn.getcwd() end
local function proj() return vim.fn.fnamemodify(cwd(), ":t") end
local function in_tmux() return (os.getenv("TMUX") or "") ~= "" and vim.fn.executable("tmux") == 1 end
local function shesc(x) return vim.fn.shellescape(x) end
local function shell_join(cmd, args)
  local out = { shesc(cmd) }
  for _, a in ipairs(args or {}) do out[#out + 1] = shesc(a) end
  return table.concat(out, " ")
end
local function run_spec(cmd, args, use_tmux, title)
  if use_tmux then
    return {
      cmd = "tmux",
      args = { "new-window", "-n", title or proj(), "bash", "-lc", shell_join(cmd, args) },
      cwd = cwd(),
      components = { "default" },
      name = "tmux://" .. (title or proj()),
    }
  end
  return { cmd = cmd, args = args, cwd = cwd(), components = { "default" } }
end
local function has_exec(x) return vim.fn.executable(x) == 1 end

-- ===== Java: Auto (Gradle/Maven/Javac) =====
local function java_detect()
  if exists("gradlew") or exists("build.gradle") or exists("build.gradle.kts") then return "gradle" end
  if exists("mvnw") or exists("pom.xml") then return "maven" end
  return "javac"
end

overseer.register_template({
  name = "Java: Auto (Gradle/Maven/Javac) [tmux/local]",
  priority = 95,
  condition = { filetype = { "java" } },
  params = {
    task = { desc = "Tarefa", type = "enum", choices = { "run", "build", "test", "clean", "jar" }, default = "run" },
    skip_tests = { desc = "Pular testes (build/package)", type = "boolean", default = true },
    where = { desc = "Rodar em", type = "enum", choices = { "auto", "tmux", "local" }, default = "auto" },
    args = { desc = "Args do programa (run)", type = "string", default = "" },
  },
  builder = function(p)
    local tool = java_detect()
    local use_tmux = (p.where == "tmux") or (p.where == "auto" and in_tmux())

    if tool == "maven" then
      local cmd = exists("./mvnw") and "./mvnw" or "mvn"
      local args
      if p.task == "run" then
        -- tenta Spring Boot se presente; senão exec:java
        local spring = exists("pom.xml") and (vim.fn.readfile("pom.xml") or {}) or {}
        local is_spring = table.concat(spring, "\n"):
match("spring%-boot")
        args = is_spring and { "-q", "spring-boot:run" } or { "-q", "exec:java" }
        if not is_spring and p.args ~= "" then table.insert(args, "-Dexec.args=" .. p.args) end
      elseif p.task == "test" then
        args = { "-q", "test" }
      elseif p.task == "clean" then
        args = { "-q", "clean" }
      elseif p.task == "jar" then
        args = { "-q", "package" }
      else
        args = { "-q", "package" }
        if p.skip_tests then table.insert(args, "-DskipTests") end
      end
      return run_spec(cmd, args, use_tmux, ("mvn:%s:%s"):format(p.task, proj()))

    elseif tool == "gradle" then
      local cmd = exists("./gradlew") and "./gradlew" or "gradle"
      local is_spring = (exists("build.gradle") and table.concat(vim.fn.readfile("build.gradle"), "\n"):
match("org%.springframework%.boot"))
        or (exists("build.gradle.kts") and table.concat(vim.fn.readfile("build.gradle.kts"), "\n"):
match("org%.springframework%.boot"))
      local args
      if p.task == "run" then
        args = { is_spring and "bootRun" or "run" }
        if p.args ~= "" and is_spring then vim.list_extend(args, { "--args", p.args }) end
      elseif p.task == "test" then
        args = { "test" }
      elseif p.task == "clean" then
        args = { "clean" }
      elseif p.task == "jar" then
        args = { "jar" }
      else
        args = { "build" }
        if p.skip_tests then vim.list_extend(args, { "-x", "test" }) end
      end
      return run_spec(cmd, args, use_tmux, ("gradle:%s:%s"):format(p.task, proj()))

    else
      -- javac fallback (src/main/java → out ; executa Main se existir)
      local out = "out"
      local script = ([[mkdir -p %q && find src -name '*.java' | xargs -r javac -d %q && \
        (test -f %q/Main.class && java -cp %q Main %s || echo 'Build ok (defina a main)')]]):format(out, out, out, out, p.args or "")
      return run_spec("bash", { "-lc", script }, use_tmux, "javac:auto")
    end
  end,
})

-- ===== Node scripts =====
local function read_package_json()
  if not exists("package.json") then return nil end
  local okf, lines = pcall(vim.fn.readfile, "package.json"); if not okf then return nil end
  local okj, obj = pcall(vim.fn.json_decode, table.concat(lines, "\n")); if not okj then return nil end
  return obj
end
local function node_detect_pm(pkg)
  if pkg and pkg.packageManager then
    if pkg.packageManager:match("^pnpm@") then return "pnpm" end
    if pkg.packageManager:match("^yarn@") then return "yarn" end
    if pkg.packageManager:match("^bun@") then return "bun" end
  end
  if exists("pnpm-lock.yaml") then return "pnpm" end
  if exists("yarn.lock") then return "yarn" end
  if exists("bun.lockb") then return "bun" end
  return "npm"
end
local function pm_cmd(pm, script)
  if pm == "pnpm" then return "pnpm", { script } end
  if pm == "yarn" then return "yarn", { script } end
  if pm == "bun" then return "bun", { "run", script } end
  return "npm", { "run", script }
end

overseer.register_template({
  name = "Node: scripts (build/dev/test/lint/format/start/custom) [tmux/local]",
  priority = 80,
  condition = { callback = function() return exists("package.json") end },
  params = {
    pm = { desc = "Package manager", type = "enum", choices = { "auto", "npm", "pnpm", "yarn", "bun" }, default = "auto" },
    subtask = { desc = "Script", type = "enum", choices = { "build", "dev", "test", "lint", "format", "start", "custom" },
      default = function() local s=(read_package_json() or {}).scripts or {}; return s.dev and "dev" or (s.build and "build" or (s.start and "start" or "test")) end },
    script_name = { desc = "Nome do script (custom)", type = "string",
      default = function() local s=(read_package_json() or {}).scripts or {}; for k,_ in pairs(s) do return k end; return "build" end,
      optional = false, condition = function(p) return p.subtask == "custom" end },
    where = { desc = "Rodar em", type = "enum", choices = { "auto", "tmux", "local" }, default = "auto" },
  },
  builder = function(p)
    local pkg = read_package_json() or {}
    local pm = (p.pm == "auto") and node_detect_pm(pkg) or p.pm
    local script = (p.subtask == "custom") and p.script_name or p.subtask
    local cmd, args = pm_cmd(pm, script)
    local use_tmux = (p.where == "tmux") or (p.where == "auto" and in_tmux())
    return run_spec(cmd, args, use_tmux, ("node:%s:%s"):format(script, proj()))
  end,
})

-- ===== Python (uv/pytest/ruff/black/isort) =====
overseer.register_template({
  name = "Python: run/test/format (uv/pytest/ruff/black/isort) [tmux/local]",
  priority = 70,
  condition = {
    callback = function()
      if exists("pyproject.toml") then return true end
      local found = vim.fs.find({ "*.py" }, { upward = false, stop = cwd(), limit = 1 })
      return #found > 0
    end,
  },
  params = {
    action = { desc = "Ação", type = "enum", choices = { "run", "test", "ruff", "black", "isort" }, default = "run" },
    run_target = { desc = "Módulo/arquivo (run)", type = "string", default = ".", condition = function(p) return p.action == "run" end },
    where = { desc = "Rodar em", type = "enum", choices = { "auto", "tmux", "local" }, default = "auto" },
  },
  builder = function(p)
    local use_tmux = (p.where == "tmux") or (p.where == "auto" and in_tmux())
    local use_uv = has_exec("uv")
    local map = {
      run   = use_uv and { "uv", { "run", "python", "-m", p.run_target } } or { "python", { "-m", p.run_target } },
      test  = use_uv and { "uv", { "run", "pytest", "-q" } } or (has_exec("pytest") and { "pytest", { "-q" } } or { "python", { "-m", "pytest", "-q" } }),
      ruff  = use_uv and { "uv", { "run", "ruff", "check", "." } } or { "ruff", { "check", "." } },
      black = use_uv and { "uv", { "run", "black", "." } } or { "black", { "." } },
      isort = use_uv and { "uv", { "run", "isort", "." } } or { "isort", { "." } },
    }
    local cmd, args = map[p.action][1], map[p.action][2]
    return run_spec(cmd, args, use_tmux, ("py:%s:%s"):format(p.action, proj()))
  end,
})

-- ===== Go =====
overseer.register_template({
  name = "Go: build/test/run (dist/) [tmux/local]",
  priority = 70,
  condition = { filetype = { "go" } },
  params = {
    action = { desc = "Ação", type = "enum", choices = { "build", "test", "run" }, default = "build" },
    where  = { desc = "Rodar em", type = "enum", choices = { "auto", "tmux", "local" }, default = "auto" },
  },
  builder = function(p)
    local use_tmux = (p.where == "tmux") or (p.where == "auto" and in_tmux())
    local title = ("go:%s:%s"):format(p.action, proj())
    if p.action == "run" then
      return run_spec("bash", { "-lc", "go run ." }, use_tmux, title)
    elseif p.action == "test" then
      return run_spec("bash", { "-lc", "go test ./..." }, use_tmux, title)
    else
      local out = "dist/" .. proj()
      return run_spec("bash", { "-lc", "mkdir -p dist && go build -o " .. shesc(out) .. " ./..." }, use_tmux, title)
    end
  end,
})

-- ===== Rust =====
overseer.register_template({
  name = "Rust: cargo build/test/run [tmux/local]",
  priority = 70,
  condition = { callback = function() return exists("Cargo.toml") end },
  params = {
    action  = { desc = "Ação", type = "enum", choices = { "build", "test", "run" }, default = "build" },
    release = { desc = "--release", type = "boolean", default = false },
    where   = { desc = "Rodar em", type = "enum", choices = { "auto", "tmux", "local" }, default = "auto" },
  },
  builder = function(p)
    local use_tmux = (p.where == "tmux") or (p.where == "auto" and in_tmux())
    local args = { p.action }; if p.release then table.insert(args, "--release") end
    return run_spec("cargo", args, use_tmux, ("rs:%s:%s"):format(p.action, proj()))
  end,
})

-- ===== C/C++ (CMake/Make/Single) =====
overseer.register_template({
  name = "C/C++: CMake/Make/Single-file → dist/ [tmux/local]",
  priority = 65,
  condition = { filetype = { "c", "cpp" } },
  params = {
    mode  = { desc = "Modo", type = "enum", choices = { "auto", "cmake", "make", "single" }, default = "auto" },
    where = { desc = "Rodar em", type = "enum", choices = { "auto", "tmux", "local" }, default = "auto" },
  },
  builder = function(p)
    local use_tmux = (p.where == "tmux") or (p.where == "auto" and in_tmux())
    local ft  = vim.bo.filetype
    local src = vim.api.nvim_buf_get_name(0)
    local bin = "dist/" .. vim.fn.fnamemodify(src, ":t:r")
    local mode = p.mode
    if mode == "auto" then mode = exists("CMakeLists.txt") and "cmake" or (exists("Makefile") and "make" or "single") end
    if mode == "cmake" then
      return run_spec("bash", { "-lc", "cmake -S . -B build && cmake --build build" }, use_tmux, "cmake:" .. proj())
    elseif mode == "make" then
      return run_spec("make", {}, use_tmux, "make:" .. proj())
    else
      local cc = (ft == "cpp") and (has_exec("g++") and "g++" or "clang++") or (has_exec("gcc") and "gcc" or "clang")
      local cmd = "bash"
      local args = { "-lc", "mkdir -p dist && " .. cc .. " " .. shesc(src) .. " -O2 -o " .. shesc(bin) .. " && " .. shesc(bin) }
      return run_spec(cmd, args, use_tmux, "build:" .. bin)
    end
  end,
})

-- ===== C# =====
overseer.register_template({
  name = "C#: dotnet build/test/run [tmux/local]",
  priority = 60,
  condition = { callback = function() return not vim.tbl_isempty(vim.fs.find({ "*.csproj", "*.sln" }, { limit = 1 })) end },
  params = {
    action = { desc = "Ação", type = "enum", choices = { "build", "test", "run" }, default = "build" },
    where  = { desc = "Rodar em", type = "enum", choices = { "auto", "tmux", "local" }, default = "auto" },
  },
  builder = function(p)
    local use_tmux = (p.where == "tmux") or (p.where == "auto" and in_tmux())
    return run_spec("dotnet", { p.action }, use_tmux, ("dotnet:%s:%s"):format(p.action, proj()))
  end,
})

-- ===== Docker Compose =====
overseer.register_template({
  name = "Docker Compose: up/down/build/logs [tmux/local]",
  priority = 50,
  condition = {
    callback = function()
      return exists("docker-compose.yml") or exists("docker-compose.yaml") or exists("compose.yml") or exists("compose.yaml")
    end,
  },
  params = {
    action = { desc = "Ação", type = "enum", choices = { "up", "down", "build", "logs" }, default = "up" },
    where  = { desc = "Rodar em", type = "enum", choices = { "auto", "tmux", "local" }, default = "auto" },
  },
  builder = function(p)
    local use_tmux = (p.where == "tmux") or (p.where == "auto" and in_tmux())
    local args = ({ up = { "up", "-d" }, down = { "down" }, build = { "build" }, logs = { "logs", "-f" } })[p.action]
    return run_spec("docker-compose", args, use_tmux, ("compose:%s:%s"):format(p.action, proj()))
  end,
})

-- ===== Run current file (lua/py/sh/js/ts/tsx/md) =====
overseer.register_template({
  name = "Run Current File (lua/py/sh/js/ts/deno) [tmux/local]",
  priority = 40,
  condition = {
    callback = function()
      local ft = vim.bo.filetype
      return vim.tbl_contains({
        "lua","python","sh","bash","zsh","javascript","typescript","typescriptreact","javascriptreact","markdown",
      }, ft)
    end,
  },
  params = { where = { desc = "Rodar em", type = "enum", choices = { "auto", "tmux", "local" }, default = "auto" } },
  builder = function(p)
    local use_tmux = (p.where == "tmux") or (p.where == "auto" and in_tmux())
    local ft = vim.bo.filetype
    local file = vim.api.nvim_buf_get_name(0)
    local cmd, args
    if ft == "lua" then
      cmd, args = "lua", { file }
    elseif ft == "python" then
      cmd, args = "python", { file }
    elseif ft == "sh" or ft == "bash" or ft == "zsh" then
      cmd, args = "bash", { "-lc", shesc(file) }
    elseif ft == "javascript" or ft == "javascriptreact" then
      cmd, args = (has_exec("node") and "node" or "bun"), { file }
    elseif ft == "typescript" or ft == "typescriptreact" then
      if has_exec("tsx") then
        cmd, args = "tsx", { file }
      elseif has_exec("ts-node") then
        cmd, args = "ts-node", { file }
      else
        cmd, args = "node", { file }
      end
    elseif ft == "markdown" then
      if has_exec("glow") then cmd, args = "glow", { file } else cmd, args = "bat", { file } end
    else
      cmd, args = "bash", { "-lc", shesc(file) }
    end
    return run_spec(cmd, args, use_tmux, ("run:%s"):format(vim.fn.fnamemodify(file, ":t")))
  end,
})

-- (sem return no fim deste arquivo)
