-- ================================================================================================
-- TITLE : nvim-surround
-- ABOUT : Operadores para adicionar, trocar e remover pares como aspas, parênteses e tags.
-- HOW   :
--   > ysiw"  envolve palavra com aspas
--   > cs"'   troca aspas duplas por simples
--   > ds)    remove parênteses
--   > S"     envolve seleção visual com aspas
-- ================================================================================================

return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  -- v4 não aceita mais `keymaps` dentro de opts/setup.
  -- Os atalhos abaixo são os padrões oficiais do plugin:
  --   ys{motion}{char}  adiciona surround usando motion
  --   yss{char}         adiciona surround na linha atual
  --   ds{char}          remove surround
  --   cs{old}{new}      troca surround
  --   S{char}           envolve seleção visual
  opts = {},
}
