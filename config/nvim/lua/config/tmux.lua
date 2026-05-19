-- Workflow glue for tmux-backed popups.
-- This stays under config/ on purpose: it is editor workflow integration, not
-- a plugin setup file. Keymaps call these helpers to open existing tmux tools
-- in popups when available, with a local terminal split as fallback.
local M = {}

local function first_existing(paths)
  for _, p in ipairs(paths) do
    local expanded = vim.fn.expand(p)
    if vim.fn.filereadable(expanded) == 1 then
      return expanded
    end
  end
  return nil
end

local popup_actions = first_existing {
  "~/config/tmux/scripts/tmux-popup-actions.sh",
  "~/.config/tmux/scripts/tmux-popup-actions.sh",
}

local session_actions = first_existing {
  "~/config/tmux/scripts/tmux-session-actions.sh",
  "~/.config/tmux/scripts/tmux-session-actions.sh",
}

local function shell_command(cmd)
  local shell = vim.o.shell ~= "" and vim.o.shell or "/bin/sh"
  return string.format("%s -lc %s", vim.fn.shellescape(shell), vim.fn.shellescape(cmd))
end

local function with_cwd(cmd, cwd)
  if cwd and cwd ~= "" then
    return "cd " .. vim.fn.shellescape(cwd) .. " && " .. cmd
  end
  return cmd
end

local function open_terminal_buffer(cmd, opts)
  opts = opts or {}
  -- Fallback path outside tmux: open a short terminal split and send the tool.
  vim.cmd "botright split"
  vim.cmd("resize " .. (opts.size or 18))
  vim.fn.termopen(shell_command(with_cwd(cmd, opts.cwd)))
  vim.cmd "startinsert"
end

function M.popup(cmd, opts)
  opts = opts or {}
  cmd = with_cwd(cmd, opts.cwd)
  if vim.env.TMUX and vim.fn.executable "tmux" == 1 then
    -- Primary path inside tmux: keep the workflow in popups instead of leaving
    -- Neovim or spawning a second full terminal window.
    vim.system({
      "tmux",
      "display-popup",
      "-E",
      "-w",
      opts.width or "86%",
      "-h",
      opts.height or "82%",
      shell_command(cmd),
    }, { detach = true })
    return
  end

  open_terminal_buffer(cmd, opts)
end

function M.split(cmd, opts)
  opts = opts or {}
  open_terminal_buffer(cmd, opts)
end

function M.window(cmd, opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.fn.getcwd()
  local title = opts.title or "task"
  local shell = vim.o.shell ~= "" and vim.o.shell or "/bin/sh"

  if vim.env.TMUX and vim.fn.executable "tmux" == 1 then
    vim.system({
      "tmux",
      "new-window",
      "-c",
      cwd,
      "-n",
      title,
      shell,
      "-lc",
      cmd,
    }, { detach = true })
    return
  end

  vim.cmd "tabnew"
  vim.fn.termopen({ shell, "-lc", cmd }, { cwd = cwd })
  vim.cmd "startinsert"
end

function M.lazygit()
  if popup_actions then
    M.popup(string.format("%q lazygit", popup_actions), { width = "92%", height = "88%" })
  else
    M.popup "lazygit"
  end
end

function M.yazi()
  if popup_actions then
    M.popup(string.format("%q yazi", popup_actions), { width = "92%", height = "88%" })
  else
    M.popup "yazi"
  end
end

function M.btop()
  if popup_actions then
    M.popup(string.format("%q btop", popup_actions), { width = "86%", height = "82%" })
  else
    M.popup "btop"
  end
end

function M.sesh()
  if session_actions then
    M.popup(string.format("%q picker", session_actions), {
      width = "90%",
      height = "84%",
    })
  end
end

function M.nmtui()
  if popup_actions then
    M.popup(string.format("%q nmtui", popup_actions), {
      width = "82%",
      height = "80%",
    })
  else
    M.popup "nmtui"
  end
end

return M
