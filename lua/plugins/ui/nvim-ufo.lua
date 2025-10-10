-- lua/plugins/ui/nvim-ufo.lua :: Gerenciador de folds (dobras de código).

return {
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        config = function()
            require("ufo").setup({
                -- O UFO usa os mesmos arquivos de query do Treesitter para folding.
                provider_selector = function(_, _, _)
                    return { "treesitter", "indent" }
                end,
                open_fold_hl_timeout = 0, -- Desativa o timeout do highlight ao abrir um fold.
            })

            vim.o.foldenable = true
            vim.o.foldcolumn = '0'
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99

            -- Keymaps para controle dos folds.
            vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
        end,
    }
}
