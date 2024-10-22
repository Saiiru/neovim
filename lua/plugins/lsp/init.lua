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
      
    -- Diagnostic and handlers configuration
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        virtual_text = true,
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
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
