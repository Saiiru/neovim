local function write(path, content)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  local f = assert(io.open(path, "w"))
  f:write(content)
  f:close()
end
local function chmod(path) pcall((vim.uv or vim.loop).fs_chmod, path, 493) end

local root = "/tmp/pde-quickfix-polish-smoke"
vim.fn.delete(root, "rf")
write(root .. "/src/main.ts", "console.log('vega')\n")
write(root .. "/package.json", [[{"dependencies":{"next":"latest"}}]])
write(root .. "/mise/tasks/build", "#!/usr/bin/env bash\nprintf 'src/main.ts:1:1: build fail\\n'\nexit 1\n")
write(root .. "/mise/tasks/test", "#!/usr/bin/env bash\nprintf 'test ok\\n'\n")
chmod(root .. "/mise/tasks/build")
chmod(root .. "/mise/tasks/test")

vim.cmd.edit(root .. "/src/main.ts")
local tasks = require("pde.tasks")
tasks.run("build", { quickfix = true })
local ok = vim.wait(3000, function()
  local info = vim.fn.getqflist({ title = 1, items = 1 })
  return info.title == "mise run build" and #(info.items or {}) == 1
end, 50)
if not ok then error("build quickfix did not populate") end

tasks.run("test", { quickfix = true })
local running = vim.fn.getqflist({ title = 1, items = 1 })
if running.title ~= "mise run test (running)" or #(running.items or {}) ~= 0 then error("quickfix not cleared on task start") end
ok = vim.wait(3000, function()
  local info = vim.fn.getqflist({ title = 1, items = 1 })
  return info.title == "mise run test" and #(info.items or {}) == 0
end, 50)
if not ok then error("test quickfix did not clear on success") end

print("PDE quickfix polish smoke OK")
