return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim",
            {
                "tzachar/cmp-tabnine",
                build = "./install.sh",
                dependencies = "hrsh7th/nvim-cmp",
            },
            "github/copilot.vim",
        },
        config = function()
            local ls = require("luasnip")
            local cmp = require("cmp")
            local lspkind = require("lspkind")

            -- Mapeamento de teclas para navegar pelos snippets
            vim.keymap.set({ "i", "s" }, "<C-L>", function()
                ls.jump(1)
            end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-J>", function()
                ls.jump(-1)
            end, { silent = true })

            -- Configuração do nvim-cmp
            cmp.setup({
                snippet = {
                    expand = function(args)
                        ls.lsp_expand(args.body) -- Para usuários de `luasnip`.
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "nvim_lua" },
                    { name = "buffer" },
                    { name = "tabnine" }, -- Adicionado Tabnine como fonte
                    { name = "copilot" }, -- Adicionado Copilot como fonte
                }),
                enabled = function()
                    -- Desabilitar conclusão em comentários
                    local context = require("cmp.config.context")

                    -- Manter conclusão no modo de comando ativada
                    if vim.api.nvim_get_mode().mode == "c" then
                        return true
                    else
                        return not context.in_treesitter_capture("comment")
                            and not context.in_syntax_group("Comment")
                    end
                end,
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                        menu = {
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            nvim_lua = "[Lua]",
                            luasnip = "[LuaSnip]",
                            tabnine = "[TabNine]", -- Adicionado ao menu
                            copilot = "[Copilot]", -- Adicionado ao menu
                            latex_symbols = "[Latex]",
                        },
                        before = function(entry, vim_item)
                            vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)

                            -- Adicionando ícones personalizados para TabNine e Copilot
                            if entry.source.name == "tabnine" then
                                vim_item.kind = lspkind.symbolic("") -- Ícone do TabNine
                            elseif entry.source.name == "copilot" then
                                vim_item.kind = lspkind.symbolic("") -- Ícone do Copilot
                            end

                            return vim_item
                        end,
                    }),
                },
            })

            -- Configuração para a linha de comando (cmdline)
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources(
                    { { name = "path" } },
                    { { name = "cmdline" } }
                ),
            })
        end,
    },
}

