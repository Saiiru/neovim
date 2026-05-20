return {
  {
    "vimpostor/vim-tpipeline",
    lazy = false,
    enabled = vim.env.TMUX ~= nil,
    init = function()
      vim.g.tpipeline_autoembed = 0
      vim.g.tpipeline_restore = 1
      vim.g.tpipeline_statusline = nil
    end,
  },
}
