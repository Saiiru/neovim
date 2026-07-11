local M = {}

function M.has(task)
  if vim.fn.executable("mise") ~= 1 then
    return false, "mise not found"
  end
  local result = vim.system({ "mise", "tasks", "--all" }, { text = true }):wait()
  if result.code ~= 0 then
    return false, result.stderr or "mise tasks failed"
  end
  for line in (result.stdout or ""):gmatch("[^\n]+") do
    local name = line:match("^(%S+)")
    if name == task then
      return true
    end
  end
  return false, "project does not define mise task: " .. task
end

function M.run(task, opts)
  opts = opts or {}
  local ok, msg = M.has(task)
  if not ok then
    vim.notify(msg, vim.log.levels.WARN)
    return
  end
  if opts.quickfix then
    vim.opt.makeprg = "mise\\ run\\ " .. task
    vim.cmd("make")
    vim.cmd("copen")
    return
  end
  vim.cmd("botright split | terminal mise run " .. task)
end

return M
