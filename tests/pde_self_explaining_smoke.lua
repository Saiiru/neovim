local function assert_contains(text, needle)
  if not text:find(needle, 1, true) then error("missing: " .. needle) end
end

local function write(path, content)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  local f = assert(io.open(path, "w"))
  f:write(content)
  f:close()
end

local function chmod(path)
  pcall((vim.uv or vim.loop).fs_chmod, path, 493)
end

local fixture = "/tmp/pde-self-explaining-smoke"
vim.fn.delete(fixture, "rf")
write(fixture .. "/src/main.ts", "console.log('vega')\n")
write(fixture .. "/package.json", [[{"dependencies":{"next":"latest","typescript":"latest"}}]])
for _, task in ipairs({ "build", "test", "lint", "dev" }) do
  local path = fixture .. "/mise/tasks/" .. task
  write(path, "#!/usr/bin/env bash\nprintf '" .. task .. " ok\\n'\n")
  chmod(path)
end

vim.cmd.edit(fixture .. "/src/main.ts")
local overview = table.concat(require("pde.overview").lines(0), "\n")
assert_contains(overview, "## Suggested next actions")
assert_contains(overview, ":PDEHelp")
assert_contains(overview, ":PDEBuild")
assert_contains(overview, ":PDETmuxTask dev")

local help = table.concat(require("pde.help").lines(0), "\n")
assert_contains(help, "PDE Help")
assert_contains(help, ":PDENewProject node")
assert_contains(help, "<leader>ph")
assert_contains(help, "compilador/interpreter")

local templates = require("pde.templates")
for _, name in ipairs({ "node", "vite", "next", "go", "rust", "c", "arduino", "java" }) do
  local spec = templates.get(name)
  if not spec then error("missing template " .. name) end
  if not spec.files or not next(spec.files) then error("template has no files " .. name) end
end

local project = require("pde.new_project")
local root = "/tmp/pde-new-project-smoke-node"
vim.fn.delete(root, "rf")
local ok, result = project.create("node", root, { force = true, open = false })
if not ok then error("new project failed: " .. tostring(result)) end
for _, rel in ipairs({ "package.json", "mise/tasks/build", "README.md" }) do
  if vim.fn.filereadable(root .. "/" .. rel) ~= 1 then error("missing generated file " .. rel) end
end

local hidden_root = "/tmp/pde-new-project-hidden-dir"
vim.fn.delete(hidden_root, "rf")
write(hidden_root .. "/.gitignore", "node_modules\n")
ok, result = project.create("node", hidden_root, { open = false })
if ok then error("expected hidden-only target dir to be refused") end
if not tostring(result):find("target is not empty", 1, true) then error("wrong hidden-dir refusal: " .. tostring(result)) end

vim.cmd("PDEHelp")
vim.cmd("PDETemplates")
vim.cmd("PDENewProject node /tmp/pde-new-project-smoke-node-cmd --force")
vim.cmd("PDEQuickfix")
vim.cmd("PDEErrors")

print("PDE self explaining smoke OK")
