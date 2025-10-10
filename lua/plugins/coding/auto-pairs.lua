-- lua/plugins/coding/auto-pairs.lua :: Fechamento automático de pares ([], (), {}, etc.)

return {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
        "hrsh7th/nvim-cmp",
    },
    config = function()
        local autopairs = require("nvim-autopairs")

        autopairs.setup({
            check_ts = true, -- Usa o Treesitter para ser mais inteligente.
            ts_config = {
                lua = { "string" }, -- Não adiciona pares dentro de strings em Lua.
                java = false, -- Desativa o check do Treesitter para Java.
            },
        })

        -- Integração com o nvim-cmp para que o autopairs funcione bem com o autocompletar.
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
}
