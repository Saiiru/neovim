-- lua/plugins/coding/mini.lua :: Coleção de plugins "mini" para funcionalidades diversas.

return {
    -- O próprio mini.nvim, base para os outros.
    {"echasnovski/mini.nvim", version = false },

    -- Comentários inteligentes.
    {
        'echasnovski/mini.comment',
        version = false,
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            -- Desativa o autocomando do ts-context-commentstring, pois o mini.comment já cuida disso.
            require('ts_context_commentstring').setup {
                enable_autocmd = false,
            }

            require("mini.comment").setup {
                -- Suporte para comentários em tsx, jsx, html, svelte.
                options = {
                    custom_commentstring = function()
                        return require('ts_context_commentstring.internal').calculate_commentstring({ key =
                            'commentstring' })
                            or vim.bo.commentstring
                    end,
                },
            }
        end
    },

    -- Surround: adicionar/remover/trocar pares de caracteres.
    {
        "echasnovski/mini.surround",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            custom_surroundings = nil,
            highlight_duration = 300,
            mappings = {
                add = 'sa',            -- Adiciona surround em modo Normal e Visual.
                delete = 'ds',         -- Deleta surround.
                find = 'sf',           -- Encontra surround (à direita).
                find_left = 'sF',      -- Encontra surround (à esquerda).
                highlight = 'sh',      -- Destaca surround.
                replace = 'sr',        -- Troca surround.
                update_n_lines = 'sn', -- Atualiza `n_lines`.

                suffix_last = 'l',
                suffix_next = 'n',
            },
            n_lines = 20,
            respect_selection_type = false,
            search_method = 'cover',
            silent = false,
        },
    },

    -- Remove espaços em branco no final da linha.
    {
        "echasnovski/mini.trailspace",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local miniTrailspace = require("mini.trailspace")

            miniTrailspace.setup({
                only_in_normal_buffers = true,
            })
            vim.keymap.set("n", "<leader>cw", function() miniTrailspace.trim() end, { desc = "Erase Whitespace" })

            -- Garante que o highlight não reapareça ao mover o cursor.
            vim.api.nvim_create_autocmd("CursorMoved", {
                pattern = "*",
                callback = function()
                    require("mini.trailspace").unhighlight()
                end,
            })
        end,
    },

    -- Split/join de argumentos e blocos de código.
    {
        "echasnovski/mini.splitjoin",
        config = function()
            local miniSplitJoin = require("mini.splitjoin")
            miniSplitJoin.setup({
                mappings = { toggle = "" }, -- Desativa o mapeamento padrão.
            })
            vim.keymap.set({ "n", "x" }, "sj", function() miniSplitJoin.join() end, { desc = "Join arguments" })
            vim.keymap.set({ "n", "x" }, "sk", function() miniSplitJoin.split() end, { desc = "Split arguments" })
        end,
    },
}
