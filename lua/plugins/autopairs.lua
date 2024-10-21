return {{
    "windwp/nvim-autopairs",
    event = { "InsertEnter", "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
        -- Importar nvim-autopairs e configurar
        local autopairs = require("nvim-autopairs")
        autopairs.setup({
            check_ts = true, -- Habilitar verificação de Treesitter
            ts_config = {
                lua = { "string" }, -- Não adicionar pares em nós de string do Lua
                javascript = { "template_string" }, -- Não adicionar pares em nós de string de template do JavaScript
                java = false, -- Não verificar Treesitter para Java
            },
            disable_filetype = { "TelescopePrompt", "spectre_panel" }, -- Desabilitar para tipos de arquivo específicos
            fast_wrap = {
                map = "<M-e>",
                chars = { "{", "[", "(", '"', "'" },
                pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
                offset = 0, -- Distância do padrão correspondente
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                highlight = "PmenuSel",
                highlight_grey = "LineNr",
            },
        })

        -- Importar nvim-cmp
        local cmp = require("cmp")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")

        -- Integrar autopairs com o nvim-cmp
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
},
{
    "m4xshen/autoclose.nvim",
    opts = {},
    event = "BufRead",
}
}
