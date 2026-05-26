-- tmux bridge only.
-- No theme logic here. The statusline owns its own look; tmux owns the outer frame.

return {
  {
    "vimpostor/vim-tpipeline",
    event = "VeryLazy",
    enabled = vim.env.TMUX ~= nil,
    init = function()
      vim.g.tpipeline_autoembed = 0
      vim.g.tpipeline_restore = 1
      vim.g.tpipeline_statusline = nil
      vim.opt.laststatus = 0
      vim.opt.showmode = false
    end,
  },
}
