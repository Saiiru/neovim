-- ================================================================================================
-- TITLE : lspsaga.nvim
-- ABOUT : UI avançada para ações de LSP (hover, code action, finder, diagnóstico).
-- LINKS :
--   > github : https://github.com/nvimdev/lspsaga.nvim
-- ================================================================================================

return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    symbol_in_winbar = { enable = false },
    finder = {
      keys = {
        jump_to = "o",
        vsplit = "v",
        split = "s",
        tabe = "t",
        quit = "q",
      },
    },
    lightbulb = { enable = false },
    ui = {
      border = "rounded",
      code_action = "",
    },
  },
}
