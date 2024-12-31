return {
  "axkirillov/hbac.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  name = "hbac",
  opts = {
    autoclose = true,
    threshold = 900,
  },
  event = "VimEnter", -- Lazy-load the plugin when entering Neovim
}
