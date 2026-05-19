-- ================================================================================================
-- TITLE : inline_edit.vim
-- ABOUT : Edita blocos embutidos (ex.: <script> dentro de HTML) em buffer temporário
--         com filetype correto, melhorando LSP/completion nesse trecho.
-- LINKS :
--   > github : https://github.com/AndrewRadev/inline_edit.vim
-- ================================================================================================

return {
  "AndrewRadev/inline_edit.vim",
  cmd = { "InlineEdit" },
  keys = {
    { "<leader>cI", "<cmd>InlineEdit<cr>", desc = "Inline Edit (bloco embutido)" },
  },
}
