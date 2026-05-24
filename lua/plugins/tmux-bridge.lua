-- Editor-to-tmux bridge.
-- Uses the active statusline. No theme logic here.

return {
  {
    "vimpostor/vim-tpipeline",
    lazy = false,
    init = function()
      vim.g.tpipeline_autoembed = 0
      vim.g.tpipeline_restore = 1
      vim.g.tpipeline_statusline = nil
    end,
  },
}
