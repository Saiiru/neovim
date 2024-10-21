return {
    -- Mason setup
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
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
        end,
    },

    -- Mason DAP Config
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "java-debug-adapter", "java-test", "python-debug-adapter", "js-debug-adapter", "codelldb" }
            })
        end,
    },

    -- Java language server utility
    {
        "mfussenegger/nvim-jdtls",
        dependencies = {
            "mfussenegger/nvim-dap",
        }
    },

    -- Barbecue for breadcrumbs
    {
        'utilyre/barbecue.nvim',
        name = 'barbecue',
        version = '*',
        dependencies = {
            'SmiteshP/nvim-navic',
        },
        event = "BufReadPost",
        config = function()
            require("barbecue").setup({
                attach_navic = true,
                create_autocmd = false,
                theme = 'auto',
                show_dirname = false,
                show_basename = true,
                symbols = {
                    modified = "●",
                    separator = ">",
                },
            })
            vim.api.nvim_create_autocmd({
                "BufWinEnter", "CursorMoved", "InsertLeave", "BufWritePost", "TabClosed"
            }, {
                group = vim.api.nvim_create_augroup("barbecue.updater", {}),
                callback = function()
                    require("barbecue.ui").update()
                end,
            })
        end
    },

    -- Fidget for LSP status
    {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        config = function()
            require('fidget').setup({
                text = {
                    spinner = "dots",
                },
                align = {
                    bottom = true,
                    right = true,
                },
                window = {
                    relative = "win",
                    blend = 0,
                },
                fmt = {
                    task = function(task_name, message, percentage)
                        return string.format("%s [%s%%]: %s", task_name, percentage or 0, message)
                    end,
                },
                timer = {
                    spinner_rate = 125,
                    fidget_decay = 2000,
                    task_decay = 1000,
                },
                sources = {
                    ["*"] = {
                        ignore = false,
                    }
                }
            })
        end
    },

    -- Incremental rename
    {
        'smjonas/inc-rename.nvim',
        cmd = 'IncRename',
        config = function()
            require('inc_rename').setup({
                input_buffer_type = "dressing",
            })
            vim.keymap.set("n", "<leader>rn", function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end, { expr = true, desc = '[R]ename Incremental LSP' })
        end
    },

    -- Lightbulb for code actions
    {
        'kosayoda/nvim-lightbulb',
        event = { "CursorHold", "CursorHoldI" },
        config = function()
            require('nvim-lightbulb').setup({
                sign = {
                    enabled = true,
                    priority = 10,
                },
                virtual_text = {
                    enabled = true,
                    text = "💡",
                },
                float = {
                    enabled = false,
                },
                status_text = {
                    enabled = false,
                },
            })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                pattern = "*",
                callback = function()
                    require('nvim-lightbulb').update_lightbulb()
                end,
            })
        end
    },

    -- LSP Signature
    {
        "ray-x/lsp_signature.nvim",
        config = function()
            local lsp_signature = require("lsp_signature")
            lsp_signature.setup({
                bind = true,
                handler_opts = {
                    border = "rounded",
                },
                toggle_key = "<M-x>",
                floating_window = false,
            })
        end
    },

    -- Null-ls for linting and formatting
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "jay-babu/mason-null-ls.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local null_ls = require("null-ls")
            local mason_null_ls = require("mason-null-ls")
            mason_null_ls.setup({
                ensure_installed = {
                    "stylua",
                    "prettier",
                    "black",
                    "gofumpt",
                    "shfmt",
                    "eslint_d",
                    "flake8",
                    "golangci_lint",
                    "shellcheck",
                    "phpcs",
                },
                automatic_installation = true,
            })
            mason_null_ls.setup_handlers({
                function(source_name, methods)
                    require("mason-null-ls.automatic_setup")(source_name, methods)
                end,
                stylua = function()
                    null_ls.register(null_ls.builtins.formatting.stylua)
                end,
                prettier = function()
                    null_ls.register(null_ls.builtins.formatting.prettier.with({
                        filetypes = { "javascript", "typescript", "css", "html", "json", "yaml", "markdown" },
                    }))
                end,
                black = function()
                    null_ls.register(null_ls.builtins.formatting.black)
                end,
                gofumpt = function()
                    null_ls.register(null_ls.builtins.formatting.gofumpt)
                end,
                shfmt = function()
                    null_ls.register(null_ls.builtins.formatting.shfmt)
                end,
                eslint_d = function()
                    null_ls.register(null_ls.builtins.diagnostics.eslint_d)
                    null_ls.register(null_ls.builtins.code_actions.eslint_d)
                end,
                flake8 = function()
                    null_ls.register(null_ls.builtins.diagnostics.flake8)
                end,
                golangci_lint = function()
                    null_ls.register(null_ls.builtins.diagnostics.golangci_lint)
                end,
                shellcheck = function()
                    null_ls.register(null_ls.builtins.diagnostics.shellcheck)
                    null_ls.register(null_ls.builtins.code_actions.shellcheck)
                end,
                phpcs = function()
                    null_ls.register(null_ls.builtins.diagnostics.phpcs)
                end,
            })
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            null_ls.setup({
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    end
                end,
            })
        end,
    },

    -- Trouble for diagnostics and quickfix
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
        opts = {
            focus = true,
        },
        cmd = "Trouble",
        keys = {
            { "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "[X] Workspace [W] Diagnostics" },
            { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "[X] Document [D] Diagnostics" },
            { "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "[X] Quickfix [Q] List" },
            { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "[X] Location [L] List" },
            { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "[X] Todo [T] List" },
        },
        config = function()
            require("trouble").setup({
                position = "bottom",
                height = 10,
                icons = true,
                mode = "workspace",
                action_keys = {
                    close = "<Esc>",
                    cancel = "<Esc>",
                    refresh = "r",
                    jump = { "<CR>", "<Tab>" },
                    jump_close = { "<CR>", "<Tab>" },
                    toggle_mode = "m",
                    previous = "k",
                    next = "j",
                    focus = "f",
                    edit = "e",
                    cancel = "<C-e>",
                    change_mode = {
                        "[x] = 'workspace'",
                        "[d] = 'document'",
                        "[l] = 'lsp'",
                    },
                },
                auto_open = false,
                auto_close = false,
                use_lsp_diagnostics = true,
            })
        end,
    },
}
