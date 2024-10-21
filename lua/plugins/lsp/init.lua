return {
    -- Mason setup
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end   
    },

    -- Mason LSP Config
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { 
                    "lua_ls", 
                    "ts_ls", 
                    "jdtls",  
                    "pylsp", 
                    "bashls", 
                    "gopls", 
                    "dockerls", 
                    "html", 
                    "cssls", 
                    "jsonls", 
                    "eslint", 
                    "tailwindcss", 
                    "emmet_ls", 
                    "solargraph", 
                    "kotlin_language_server", 
                    "phpactor",
                },
            })
        end
    },

    -- Mason DAP Config
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "java-debug-adapter", "java-test", "python-debug-adapter", "js-debug-adapter", "codelldb" }
            })
        end
    },

    -- Java language server utility
    {
        "mfussenegger/nvim-jdtls",
        dependencies = {
            "mfussenegger/nvim-dap",
        }
    },

    -- LSP Config
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
                ts_ls = {
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
            -- Setup para cada servidor
            setup = function(server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = require("cmp_nvim_lsp").default_capabilities(),
                })
            end,
        },
        config = function()
            local lspconfig = require("lspconfig")

            -- Mapeamento de teclas para ações LSP
            vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
            vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode Goto [D]efinition" })
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
            vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references, { desc = "[C]ode Goto [R]eferences" })
            vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations, { desc = "[C]ode Goto [I]mplementations" })
            vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
            vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Goto [D]eclaration" })
        end
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

