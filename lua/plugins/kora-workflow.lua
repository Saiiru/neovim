return {
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },
  {
    "andymass/vim-matchup",
    event = "VeryLazy",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "vimpostor/vim-tpipeline",
    lazy = false,
    init = function()
      vim.g.tpipeline_autoembed = 0
      vim.g.tpipeline_restore = 1
      vim.g.tpipeline_statusline = "%!tpipeline#stl#line()"
    end,
  },
}
