-- lua/overseer/template/langs/runner/templates.lua
local overseer = require("overseer")
local uv = vim.uv or vim.loop

local function exists(p) return p and uv.fs_stat(p) ~= nil end
local function cwd() return vim.fn.getcwd() end
local function proj() return vim.fn.fnamemodify(cwd(), ":t") end
local function in_tmux() return (os.getenv("TMUX") or "") ~= "" and vim.fn.executable("tmux") == 1 end
local function shesc(x) return vim.fn.shellescape(x) end
local function shell_join(cmd, args) local out = { shesc(cmd) }; for _, a in ipairs(args or {}) do out[#out+1] = shesc(a) end; return table.concat(out, " ") end
local function run_spec(cmd, args, use_tmux, title)
  if use_tmux then
    return { cmd = "tmux", args = { "new-window", "-n", title or proj(), "bash", "-lc", shell_join(cmd, args) }, cwd = cwd(), components = { "default" }, name = "tmux://" .. (title or proj()) }
  end
  return { cmd = cmd, args = args, cwd = cwd(), components = { "default" } }
end

-- Java Auto (Gradle/Maven/Javac)
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
    args = { desc = "Args p/ run", type = "string", default = "" },
  },
  builder = function(p)
    local tool = java_detect()
    local use_tmux = (p.where == "tmux") or (p.where == "auto" and in_tmux())
    if tool == "maven" then
      local cmd = exists("./mvnw") and "./mvnw" or "mvn"
      local args = (p.task == "test") and { "-q", "test" } or { "-q", "package" }
      if p.skip_tests and p.task ~= "test" then table.insert(args, 2, "-DskipTests") end
      if p.task == "run" then args = { "-q", "spring-boot:run" } end
      return run_spec(cmd, args, use_tmux, ("mvn:%s:%s"):format(p.task, proj()))
    elseif tool == "gradle" then
      local cmd = exists("./gradlew") and "./gradlew" or "gradle"
      local args = (p.task == "test") and { "test" } or (p.task == "run" and { "run" } or { "build" })
      if p.skip_tests and p.task == "build" then vim.list_extend(args, { "-x", "test" }) end
      return run_spec(cmd, args, use_tmux, ("gradle:%s:%s"):format(p.task, proj()))
    else
      local out = "out"; local file = vim.api.nvim_buf_get_name(0)
      local script = ([[mkdir -p %q && find src -name '*.java' | xargs -r javac -d %q && java -cp %q Main %s]]):format(out, out, out, p.args or "")
      return run_spec("bash", { "-lc", script }, use_tmux, "javac:auto")
    end
  end,
})

-- Node scripts
local function read_package_json()
  if not exists("package.json") then return nil end
  local okf, lines = pcall(vim.fn.readfile, "package.json"); if not okf then return nil end
  local okj, obj = pcall(vim.fn.json_decode, table.concat(lines, "
")); if not okj then return nil end
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
    subtask = { desc = "Script", type = "enum", choices = { "build", "dev", "test", "lint", "format", "start", "custom" }, default = function() local s=(read_package_json() or {}).scripts or {}; return s.dev and "dev" or (s.build and "build" or (s.start and "start" or "test")) end },
    script_name = { desc = "Nome do script (quando 'custom')", type = "string", default = function() local s=(read_package_json() or {}).scripts or {}; for k,_ in pairs(s) do return k end; return "build" end, optional = false, condition = function(p) return p.subtask == "custom" end },
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

-- C/C++ auto (CMake/Make/Single)

overseer.register_template({
  name = "C/C++: CMake/Make/Single-file → dist/ [tmux/local]",
  priority = 65,
  condition = { filetype = { "c", "cpp" } },
  params = { mode = { desc = "Modo", type = "enum", choices = { "auto", "cmake", "make", "single" }, default = "auto" }, where = { desc = "Rodar em", type = "enum", choices = { "auto", "tmux", "local" }, default = "auto" } },
  builder = function(p)
    local use_tmux = (p.where == "tmux") or (p.where == "auto" and in_tmux())
    local ft = vim.bo.filetype
    local src = (vim.api.nvim_buf_get_name(0))
    local bin = "dist/" .. vim.fn.fnamemodify(src, ":t:r")
    local mode = p.mode
    if mode == "auto" then mode = exists("CMakeLists.txt") and "cmake" or (exists("Makefile") and "make" or "single") end
    if mode == "cmake" then
      return run_spec("bash", { "-lc", "cmake -S . -B build && cmake --build build" }, use_tmux, "cmake:" .. proj())
    elseif mode == "make" then
      return run_spec("make", {}, use_tmux, "make:" .. proj())
    else
      local cc = (ft == "cpp") and (vim.fn.executable("g++") == 1 and "g++" or "clang++") or (vim.fn.executable("gcc") == 1 and "gcc" or "clang")
      local cmd = "bash"
      local args = { "-lc", "mkdir -p dist && " .. cc .. " " .. shesc(src) .. " -O2 -o " .. shesc(bin) .. " && " .. shesc(bin) }
      return run_spec(cmd, args, use_tmux, "build:" .. bin)
    end
  end,
})