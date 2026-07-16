local M = {}

local function in_tmux()
  return vim.env.TMUX ~= nil and vim.fn.executable("tmux") == 1
end

function M.run(root, task, opts)
  opts = opts or {}
  local cmd = "cd " .. vim.fn.shellescape(root) .. " && mise run " .. vim.fn.shellescape(task)

  if not in_tmux() then
    vim.cmd("botright split")
    vim.cmd("terminal " .. cmd)
    return "terminal"
  end

  local window_name = opts.window or ("pde:" .. task:gsub("[^%w_-]", "-"))
  local current_window = vim.fn.systemlist({ "tmux", "display-message", "-p", "#{window_id}" })[1]
  local windows = vim.fn.systemlist({ "tmux", "list-windows", "-F", "#{window_name}" })
  local exists = false
  for _, name in ipairs(windows) do
    if name == window_name then exists = true; break end
  end

  if not exists then
    vim.fn.system({ "tmux", "new-window", "-d", "-n", window_name, "-c", root })
  end

  vim.fn.system({ "tmux", "send-keys", "-t", window_name, "C-c" })
  vim.fn.system({ "tmux", "send-keys", "-t", window_name, "clear", "C-m" })
  vim.fn.system({ "tmux", "send-keys", "-t", window_name, cmd, "C-m" })

  if opts.focus then
    vim.fn.system({ "tmux", "select-window", "-t", window_name })
  elseif current_window and current_window ~= "" then
    vim.fn.system({ "tmux", "select-window", "-t", current_window })
  end

  vim.notify("tmux " .. window_name .. ": mise run " .. task, vim.log.levels.INFO)
  return "tmux"
end

return M
