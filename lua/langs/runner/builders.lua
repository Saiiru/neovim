local M = {}

local function has(cmd)
  return vim.fn.executable(cmd) == 1
end
local function shesc(s)
  return vim.fn.shellescape(s)
end

M.tmux_new_window = {
  name = "tmux_new_window",
  desc = "Run command in a new detached tmux window",
  params = {
    cmd = { type = "string", desc = "Command to execute" },
    name = { type = "string", desc = "tmux window name", default = "Overseer Task" },
    cwd = { type = "string", desc = "Working directory", default = vim.fn.getcwd() },
  },
  builder = function(params)
    local cmd = params.cmd
    local name = params.name or "Overseer Task"
    local cwd = params.cwd or vim.fn.getcwd()

    if has "tmux" then
      local tmux_cmd = string.format("tmux new-window -d -n %s -c %s -- %s", shesc(name), shesc(cwd), cmd)
      return {
        cmd = { "bash", "-lc", tmux_cmd },
        name = name,
        components = { "on_complete_notify", "on_output_summarize", "default" },
      }
    end

    return {
      cmd = { "bash", "-lc", string.format("cd %s && nohup %s >/dev/null 2>&1 &", shesc(cwd), cmd) },
      name = name,
      components = { "on_complete_notify", "on_output_summarize", "default" },
    }
  end,
}

M.tmux_split = {
  name = "tmux_split",
  desc = "Run command in a tmux split pane",
  params = {
    cmd = { type = "string", desc = "Command to execute" },
    cwd = { type = "string", desc = "Working directory", default = vim.fn.getcwd() },
    vertical = { type = "boolean", desc = "Vertical split?", default = true },
    size = { type = "number", desc = "Size (pct 10-90)", default = 30 },
  },
  builder = function(p)
    if not has "tmux" then
      return { cmd = { "bash", "-lc", string.format("cd %s && %s", shesc(p.cwd), p.cmd) }, components = { "default" } }
    end
    local flag = p.vertical and "-v" or "-h"
    local sz = math.max(10, math.min(90, p.size or 30))
    local tmux_cmd = string.format("tmux split-window %s -p %d -c %s -- %s", flag, sz, shesc(p.cwd), p.cmd)
    return { cmd = { "bash", "-lc", tmux_cmd }, components = { "default" } }
  end,
}

function M.register_all()
  local ok, overseer = pcall(require, "overseer")
  if not ok then
    return
  end
  overseer.register_template(M.tmux_new_window)
  overseer.register_template(M.tmux_split)
end

return M
