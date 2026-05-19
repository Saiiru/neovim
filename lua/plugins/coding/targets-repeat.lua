-- ================================================================================================
-- TITLE : targets.vim + vim-repeat
-- ABOUT : Melhora textobjects e permite repetir operações de plugins com `.`
-- HOW   : `ci,`, `da)`, `ysiw"` ficam mais naturais e repetíveis.
-- ================================================================================================

return {
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },
  {
    "wellle/targets.vim",
    event = { "BufReadPost", "BufNewFile" },
  },
}
