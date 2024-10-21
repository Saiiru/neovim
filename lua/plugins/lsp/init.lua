return {
    -- tools
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            opts = opts or {}
            opts.ensure_installed = opts.ensure_installed or {}

            vim.list_extend(opts.ensure_installed, {
                "luacheck",
                "shellcheck",
                "shfmt",
                "tailwindcss-language-server",
                "typescript-language-server",
                "css-lsp",
            })

            return opts
        end,
    },

    -- lsp servers
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = true },
            servers = {
                cssls = {},
                tailwindcss = {
                    root_dir = function(...)
                        return require("lspconfig.util").root_pattern(".git")(...)
                    end,
                },
                tsserver = {
                    root_dir = function(...)
                        return require("lspconfig.util").root_pattern(".git")(...)
                    end,
                    single_file_support = false,
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "literal",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = false,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                        javascript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                    },
                },
                html = {},
                lua_ls = {
                    single_file_support = true,
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                workspaceWord = true,
                                callSnippet = "Both",
                            },
                            hint = {
                                enable = true,
                                setType = false,
                                paramType = true,
                                paramName = "Disable",
                                semicolon = "Disable",
                                arrayIndex = "Disable",
                            },
                            diagnostics = {
                                disable = { "incomplete-signature-doc", "trailing-space" },
                                groupSeverity = {
                                    strong = "Warning",
                                    strict = "Warning",
                                },
                                groupFileStatus = {
                                    ["ambiguity"] = "Opened",
                                    ["await"] = "Opened",
                                    ["codestyle"] = "None",
                                    ["duplicate"] = "Opened",
                                    ["global"] = "Opened",
                                    ["luadoc"] = "Opened",
                                    ["redefined"] = "Opened",
                                    ["strict"] = "Opened",
                                    ["strong"] = "Opened",
                                    ["type-check"] = "Opened",
                                    ["unbalanced"] = "Opened",
                                    ["unused"] = "Opened",
                                },
                                unusedLocalExclude = { "_*" },
                            },
                        },
                    },
                },
            },
            -- Adiciona a configuração de setup para cada servidor
            setup = function(server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = require("cmp_nvim_lsp").default_capabilities(),
                })
            end,
        },
    },

    -- Completion source for emoji
    {
        "nvim-cmp",
        dependencies = { "hrsh7th/cmp-emoji" },
        opts = function(_, opts)
            opts = opts or {}
            opts.sources = opts.sources or {}
            table.insert(opts.sources, { name = "emoji" })

            return opts
        end,
    },
}

