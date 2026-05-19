-- ================================================================================================
-- TITLE : ccc.nvim
-- ABOUT : Color picker/highlighter para CSS, Lua, configs e temas.
-- LINKS :
--   > github : https://github.com/uga-rosa/ccc.nvim
-- ================================================================================================

return {
  "uga-rosa/ccc.nvim",
  cmd = { "CccPick", "CccConvert", "CccHighlighterToggle" },
  keys = {
    { "<leader>uc", "<cmd>CccPick<cr>", desc = "Color Picker (ccc)" },
    { "<leader>uC", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle Color Highlighter (ccc)" },
  },
  opts = {
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
    highlight_mode = "virtual",
  },
}
