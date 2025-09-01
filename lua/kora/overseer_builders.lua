-- lua/kora/overseer_builders.lua
-- Custom Overseer.nvim builders for KORA environment.

local M = {}

-- Builder to run a command in a new detached tmux window.
M.tmux_new_window = {
  name = "tmux_new_window",
  builder = function(params)
    local cmd = params.cmd
    local name = params.name or "Overseer Task"
    local cwd = params.cwd or vim.fn.getcwd()

    -- Construct the tmux command
    local tmux_cmd = string.format("tmux new-window -d -n '%s' -c '%s' -- %s", name, cwd, cmd)

    return {
      cmd = { "bash", "-c", tmux_cmd },
      name = name,
      -- You can add more properties here like components, etc.
    }
  end,
  -- Define parameters this builder expects
  params = {
    cmd = { type = "string", description = "The command to execute." },
    name = { type = "string", description = "Name of the tmux window." },
    cwd = { type = "string", description = "Working directory for the command." },
  },
}

return M
