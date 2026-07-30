local p = require("theme.palette")

return {
  {
    "EdenEast/nightfox.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = "italic",
          conditionals = "italic",
          constants = "NONE",
          functions = "bold",
          keywords = "NONE",
          operators = "NONE",
          strings = "NONE",
          types = "bold",
          variables = "NONE",
        },
      },
      palettes = {
        carbonfox = {
          bg0 = p.bg0,
          bg1 = p.bg1,
          bg2 = p.bg2,
          bg3 = p.bg3,
          bg4 = p.bg3,
          fg1 = p.fg0,
          fg2 = p.fg1,
          fg3 = p.muted,
          sel0 = p.bg3,
          sel1 = p.border,
          comment = p.muted,
          yellow = p.amber,
          orange = p.orange,
          red = p.red,
          green = p.green,
          cyan = p.cyan,
          blue = p.blue,
          magenta = p.violet,
        },
      },
      specs = {
        carbonfox = {
          syntax = {
            keyword = p.violet,
            func = p.blue,
            string = p.green,
            type = p.violet,
            variable = p.fg0,
            const = p.amber,
            operator = p.fg1,
            comment = p.muted,
          },
          diag = {
            error = p.red,
            warn = p.amber,
            info = p.blue,
            hint = p.cyan,
            ok = p.green,
          },
        },
      },
    },
    config = function(_, opts)
      require("nightfox").setup(opts)
      vim.cmd.colorscheme("carbonfox")
      require("theme.highlights").setup()
    end,
  },

  { "folke/tokyonight.nvim", enabled = false },
  { "dupeiran001/nord.nvim", enabled = false },
  { "rose-pine/neovim", name = "rose-pine", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  { "lifepillar/vim-gruvbox8", enabled = false },
  { "ellisonleao/gruvbox.nvim", enabled = false },
  { "rebelot/kanagawa.nvim", enabled = false },
  { "sainnhe/gruvbox-material", enabled = false },
  { "arcticicestudio/nord-vim", enabled = false },
  { "uloco/bluloco.nvim", enabled = false },
  { "scottmckendry/cyberdream.nvim", enabled = false },
  { "shatur/neovim-ayu", enabled = false },
  { "vimpostor/vim-lumen", enabled = false },
  { "rktjmp/lush.nvim", enabled = false },
}
