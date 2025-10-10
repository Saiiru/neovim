-- lua/plugins/coding/emmet.lua :: Suporte para Emmet.

return {
    -- O emmet-ls já está instalado via Mason, então este plugin é apenas para a função de wrap.
    "olrtg/nvim-emmet",
    config = function()
        vim.keymap.set({ "n", "v" }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
    end,
}
