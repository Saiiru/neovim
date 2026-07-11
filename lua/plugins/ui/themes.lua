return {
  {
  "dupeiran001/nord.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
},
  {
    -- macos system dark/mode
    "vimpostor/vim-lumen",
    enabled = false,
    lazy = true,
    config = true
  },
  { "lifepillar/vim-gruvbox8",   enabled = false },
  { "ellisonleao/gruvbox.nvim",  enabled = false },
  {
    "rebelot/kanagawa.nvim",
    enabled = false,
    lazy = true,
    config = function()
      require('kanagawa').setup()
    end
  },
  {
    "sainnhe/gruvbox-material",
    enabled = false,
    lazy = false

  },
  {
    -- colorscheme development
    "rktjmp/lush.nvim",
    enabled = false,
    lazy = true,
    cmd = "Lushify",

  },
  {
    "arcticicestudio/nord-vim",
    enabled = false
  },
  {
    "EdenEast/nightfox.nvim",
    enabled = false,
    opts = {
      options = {
        styles = {
          comments = "italic",
          keywords = "bold",
          functions = "italic,bold",
        },
      }

    }
  },
  {
  'uloco/bluloco.nvim',
  enabled = false,
  lazy = false,
  priority = 1000,
  dependencies = { 'rktjmp/lush.nvim' },
  config = function()
    -- your optional config goes here, see below.
  end,
},
  {
    "scottmckendry/cyberdream.nvim",
    enabled = false,
    lazy = false,
    opts = {
      -- recommended - see "configuring" below for more config options
      transparent = true,
      italic_comments = true,
      hide_fillchars = true,
      borderless_telescope = true,
    },
  },
  {
    "rose-pine/neovim",
    lazy = false,
    enabled = true,
    name = "rose-pine",
    opts = {
      disable_background = false,
      variant = 'auto',
      dark_variant = 'moon',
    },
  },
  {
    "shatur/neovim-ayu",
    enabled = false,
    lazy = true,
  },
  {
    "catppuccin/nvim",
    enabled = true,
    lazy = true,
    name = "catppuccin",
  },
  {
    'folke/tokyonight.nvim',
    enabled = false,
    lazy = false,
    opts = { style = "moon" }
  },


}
