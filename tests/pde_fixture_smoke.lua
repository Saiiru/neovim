local uv = vim.uv or vim.loop

local detect = require("pde.detect")
local tasks = require("pde.tasks")
local arduino = require("pde.arduino")

local root = vim.fn.stdpath("run") .. "/pde-fixtures-smoke"
vim.fn.delete(root, "rf")
vim.fn.mkdir(root, "p")

local function write(rel, body)
  local path = root .. "/" .. rel
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  local fd = assert(uv.fs_open(path, "w", 420))
  assert(uv.fs_write(fd, body, 0))
  assert(uv.fs_close(fd))
  return path
end

local fixtures = {
  lua = {
    file = "lua/init.lua",
    body = "print('ok')\n",
    markers = { ["lua/.mise.toml"] = "[tasks.build]\nrun = 'lua init.lua'\n[tasks.lint]\nrun = 'luacheck .'\n" },
    expected = { type = "unknown", framework = "unknown", tasks = { "build", "lint" } },
  },
  python = {
    file = "python/main.py",
    body = "print('ok')\n",
    markers = { ["python/pyproject.toml"] = "[project]\nname='fixture'\nversion='0.0.0'\n", ["python/mise/tasks/test"] = "#!/usr/bin/env bash\npython -m pytest\n" },
    expected = { type = "backend", framework = "python", tasks = { "test" } },
  },
  javascript = {
    file = "javascript/src/main.js",
    body = "console.log('ok')\n",
    markers = { ["javascript/package.json"] = '{"scripts":{"test":"node src/main.js"}}\n', ["javascript/.mise.toml"] = "[tasks.dev]\nrun = 'node src/main.js'\n" },
    expected = { type = "node", framework = "node", tasks = { "dev" } },
  },
  vite = {
    file = "vite/src/main.ts",
    body = "console.log('ok')\n",
    markers = { ["vite/package.json"] = '{"scripts":{"dev":"vite"}}\n', ["vite/vite.config.ts"] = "export default {}\n", ["vite/.mise.toml"] = "[tasks.build]\nrun = 'vite build'\n" },
    expected = { type = "frontend", framework = "vite", tasks = { "build" } },
  },
  typescript = {
    file = "typescript/src/main.ts",
    body = "const ok: boolean = true\n",
    markers = { ["typescript/package.json"] = '{"devDependencies":{"typescript":"local"}}\n', ["typescript/mise/tasks/typecheck"] = "#!/usr/bin/env bash\ntsc --noEmit\n" },
    expected = { type = "node", framework = "node", tasks = { "typecheck" } },
  },
  c = {
    file = "c/main.c",
    body = "int main(void){return 0;}\n",
    markers = { ["c/compile_commands.json"] = "[]\n", ["c/.mise.toml"] = "[tasks.build]\nrun = 'cc main.c'\n" },
    expected = { type = "native", framework = "compile-db", tasks = { "build" } },
  },
  arduino = {
    file = "arduino/fixture.ino",
    body = "void setup(){}\nvoid loop(){}\n",
    markers = {
      ["arduino/sketch.yaml"] = "default_profile: esp32\nprofiles:\n  esp32:\n    fqbn: esp32:esp32:esp32\n    port: /dev/ttyUSB0\n    baud: 115200\n",
      ["arduino/pde.toml"] = "profile = 'esp32'\n[profiles.esp32]\nfqbn = 'esp32:esp32:esp32'\nport = '/dev/ttyUSB0'\nbaud = 115200\ncompile_db = 'compile_commands.json'\n",
      ["arduino/compile_commands.json"] = "[]\n",
      ["arduino/.mise.toml"] = "[tasks.arduino-compile]\nrun = 'arduino-cli compile'\n[tasks.\"arduino-compile-db\"]\nrun = 'arduino-cli compile --build-path build'\n",
    },
    expected = { type = "embedded", framework = "arduino-cli", tasks = { "arduino-compile", "arduino-compile-db" } },
  },
  go = {
    file = "go/main.go",
    body = "package main\nfunc main(){}\n",
    markers = { ["go/go.mod"] = "module fixture\n", ["go/mise/tasks/test"] = "#!/usr/bin/env bash\ngo test ./...\n" },
    expected = { type = "backend", framework = "go", tasks = { "test" } },
  },
  rust = {
    file = "rust/src/main.rs",
    body = "fn main() {}\n",
    markers = { ["rust/Cargo.toml"] = "[package]\nname='fixture'\nversion='0.0.0'\nedition='2021'\n", ["rust/.mise.toml"] = "[tasks.build]\nrun = 'cargo build'\n" },
    expected = { type = "backend", framework = "rust", tasks = { "build" } },
  },
  quoted_tasks = {
    file = "quoted/main.txt",
    body = "ok\n",
    markers = { ["quoted/.mise.toml"] = "[tasks.\"dash-task\"]\nrun = 'true'\n[tasks.'colon:task']\nrun = 'true'\n" },
    expected = { type = "unknown", framework = "unknown", tasks = { "dash-task", "colon:task" } },
  },
}

local function contains(list, value)
  for _, item in ipairs(list) do
    if item == value then return true end
  end
  return false
end

local failures = {}
for name, fixture in pairs(fixtures) do
  for rel, body in pairs(fixture.markers) do write(rel, body) end
  local file = write(fixture.file, fixture.body)
  vim.cmd.edit(vim.fn.fnameescape(file))
  local info = detect.detect(0)
  if info.type ~= fixture.expected.type or info.framework ~= fixture.expected.framework then
    table.insert(failures, string.format("%s detect got %s/%s at %s", name, info.type, info.framework, info.root))
  end
  local found = tasks.list(info.root)
  for _, task in ipairs(fixture.expected.tasks) do
    if not contains(found, task) then
      table.insert(failures, string.format("%s missing task %s; got %s", name, task, table.concat(found, ",")))
    end
  end
  if name == "arduino" then
    if arduino.profile(0) ~= "esp32" then table.insert(failures, "arduino profile mismatch") end
    if arduino.fqbn(0) ~= "esp32:esp32:esp32" then table.insert(failures, "arduino fqbn mismatch") end
    if arduino.port(0) ~= "/dev/ttyUSB0" then table.insert(failures, "arduino port mismatch") end
    if tostring(arduino.baud(0)) ~= "115200" then table.insert(failures, "arduino baud mismatch") end
    if not arduino.compile_db(0):match("compile_commands%.json$") then table.insert(failures, "arduino compile db mismatch") end
  end
end

if tasks.missing_message("lint") ~= "project does not define local mise task: lint" then
  table.insert(failures, "missing task message changed")
end

if #failures > 0 then
  error(table.concat(failures, "\n"))
end

print("PDE fixture smoke OK: lua python javascript vite typescript c arduino go rust quoted_tasks")
