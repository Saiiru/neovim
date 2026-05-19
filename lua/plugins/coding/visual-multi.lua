-- ================================================================================================
-- TITLE : vim-visual-multi
-- ABOUT : Multi-cursor estilo VSCode para editar várias ocorrências ao mesmo tempo.
-- LINKS :
--   > github : https://github.com/mg979/vim-visual-multi
-- HOW TO USE (rápido):
--   > Ctrl-n : seleciona próxima ocorrência
--   > Ctrl-p : volta seleção anterior
--   > n / N  : navega entre matches
--   > Esc    : sair
-- ================================================================================================

return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.VM_theme = "purplegray"
      vim.g.VM_mouse_mappings = 1
    end,
  },
}
