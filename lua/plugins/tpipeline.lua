-- ~/.config/nvim/lua/plugins/tpipeline.lua
--
-- vim-tpipeline: render lualine's evil-line into tmux's status-right.
--
-- How it works:
--   1. Plugin captures Neovim's rendered statusline (lualine output).
--   2. On focus, calls: tmux set-option -g status-right "<lualine content>"
--   3. On blur / BufLeave, restores tmux's original status-right.
--
-- tmux.conf requirements (already set in your tmux.conf):
--   set -g status-right-length 200
--   set -g status-interval 5
--
-- For the evil-line gradient blocks (  ) to survive the tmux round-trip,
-- kitty + a Nerd Font must be active in the tmux pane. They will be.

return {
  "vimpostor/vim-tpipeline",
  lazy  = false,          -- load immediately; must hook into VimEnter
  init  = function()
    -- Embed lualine output into tmux status-right automatically.
    vim.g.tpipeline_autoembed = 1

    -- "auto" picks up the active colorscheme (tokyonight in your case).
    -- If the colors look wrong, try: vim.g.tpipeline_theme = "tokyonight"
    vim.g.tpipeline_theme = "auto"

    -- 0 = preserve the right-hand portion of status-right (git/bat/time).
    -- 1 = tpipeline owns the full status-right while in Neovim.
    -- Start with 1 (cleaner), switch to 0 if you want both at once.
    vim.g.tpipeline_clearstatus = 1

    -- Optional: force a specific statusline string instead of lualine's.
    -- Leave commented to let lualine drive it.
    -- vim.g.tpipeline_statusline = "%f %m"
  end,
}
