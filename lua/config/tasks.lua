-- Hardware/mise task launcher for KORA workflow
local M = {}

function M.run_mise_task(task_name)
  local cmd = "mise run " .. task_name
  vim.cmd("split | terminal " .. cmd)
end

return M
