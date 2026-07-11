return {
  -- Visual baseline: one active primary theme.
  -- Configure TokyoNight before `vim.cmd.colorscheme("tokyonight-night")` runs in init.lua.
  {
    "folke/tokyonight.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      light_style = "day",
      terminal_colors = true,
      transparent = false,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help", "terminal", "lazy", "mason" },
      dim_inactive = false,
      lualine_bold = false,
    },
  },

  -- Alternate themes are kept available in history but disabled for v0 calm baseline.
  { "dupeiran001/nord.nvim", enabled = false },
  { "rose-pine/neovim", name = "rose-pine", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  { "lifepillar/vim-gruvbox8", enabled = false },
  { "ellisonleao/gruvbox.nvim", enabled = false },
  { "rebelot/kanagawa.nvim", enabled = false },
  { "sainnhe/gruvbox-material", enabled = false },
  { "arcticicestudio/nord-vim", enabled = false },
  { "EdenEast/nightfox.nvim", enabled = false },
  { "uloco/bluloco.nvim", enabled = false },
  { "scottmckendry/cyberdream.nvim", enabled = false },
  { "shatur/neovim-ayu", enabled = false },
  { "vimpostor/vim-lumen", enabled = false },
  { "rktjmp/lush.nvim", enabled = false },
}
