-- ================================================================================================
-- TITLE : nvim-bqf
-- ABOUT : Quickfix melhorado com preview, filtro e navegação mais confortável.
-- HOW   : use `:copen`, `<leader>cq`, `<leader>cn`, `<leader>cp`.
-- ================================================================================================

return {
  "kevinhwang91/nvim-bqf",
  ft = "qf",
  opts = {
    auto_enable = true,
    auto_resize_height = true,
    preview = {
      auto_preview = true,
      border = "single",
      win_height = 14,
      winblend = 0,
    },
    filter = {
      fzf = {
        action_for = { ["ctrl-s"] = "split", ["ctrl-v"] = "vsplit", ["ctrl-t"] = "tab drop" },
        extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
      },
    },
  },
}
