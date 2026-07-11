local M = {}

function M.make(task)
  task = task or "build"
  vim.opt_local.makeprg = "mise\\ run\\ " .. task
  vim.cmd("silent make")
  vim.cmd("copen")
end

function M.setqf_from_lines(title, lines)
  local items = {}
  for _, line in ipairs(lines or {}) do
    table.insert(items, { text = line })
  end
  vim.fn.setqflist({}, " ", { title = title, items = items })
  if #items > 0 then
    vim.cmd("copen")
  end
end

return M
