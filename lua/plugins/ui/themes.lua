return {
  -- Blackout Gotham baseline: Carbonfox gives graphite/black without neon wash.
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
          bg0 = "#0b0b0d",
          bg1 = "#111113",
          bg2 = "#161616",
          bg3 = "#1f1f1f",
          bg4 = "#262626",
          fg1 = "#d7d7d7",
          fg2 = "#b0b0b0",
          fg3 = "#787878",
          sel0 = "#262626",
          sel1 = "#303030",
          comment = "#5f5f5f",
          yellow = "#c8a43a",
        },
      },
      specs = {
        carbonfox = {
          syntax = {
            keyword = "#b0b0b0",
            func = "#d7d7d7",
            string = "#9b9b9b",
            type = "#b0b0b0",
            variable = "#d7d7d7",
          },
          diag = {
            ok = "#787878",
            warn = "#c8a43a",
          },
        },
      },
      groups = {
        carbonfox = {
          CursorLineNr = { fg = "#c8a43a", style = "bold" },
          FloatBorder = { fg = "#393939", bg = "#111113" },
          NormalFloat = { bg = "#111113" },
          WinSeparator = { fg = "#262626" },
          DiagnosticVirtualTextError = { fg = "#8a5a5a", bg = "#111113" },
          DiagnosticVirtualTextWarn = { fg = "#c8a43a", bg = "#111113" },
          DiagnosticVirtualTextInfo = { fg = "#787878", bg = "#111113" },
          DiagnosticVirtualTextHint = { fg = "#787878", bg = "#111113", style = "italic" },
          Search = { fg = "#161616", bg = "#c8a43a", style = "bold" },
          IncSearch = { fg = "#161616", bg = "#d6b85a", style = "bold" },
        },
      },
    },
    config = function(_, opts)
      require("nightfox").setup(opts)
      vim.cmd.colorscheme("carbonfox")
    end,
  },

  { "folke/tokyonight.nvim", enabled = false },

  -- Alternate themes are kept available in history but disabled for v0 calm baseline.
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
