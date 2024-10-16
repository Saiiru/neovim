return {
    {
        "williamboman/mason.nvim",
        config = function()
            -- Setup mason with default properties
            require("mason").setup({
                ui = {
                    border = "rounded"
                }
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            -- Ensure the necessary language servers are installed
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",  -- TypeScript/JavaScript
                    "jdtls",  -- Java
                    "cssls",
                    "html",
                    "tailwindcss",
                    "svelte",
                    "pyright",  -- Python
                    "rust_analyzer",  -- Rust
                    "gopls",  -- Go
                    "bashls",
                    "jsonls",
                    "yamlls",
                    "dockerls",
                    "clangd",  -- C/C++
                    "cmake",
                    "vimls"
                },
            })
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            -- Ensure the necessary debug adapters are installed
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "java-debug-adapter",
                    "java-test",
                    "python",
                    "cppdbg",
                    "bash",
                    "chrome",
                    "node2"
                },
            })
        end,
    },
    {
        "mfussenegger/nvim-jdtls",
        dependencies = {
            "mfussenegger/nvim-dap",
            "ray-x/lsp_signature.nvim"
        },
    },
    {
        "ray-x/lsp_signature.nvim",
        config = function()
            require "lsp_signature".setup()
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local icons = require("config.icons.icons")
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Helper function for common LSP setup
            local function on_attach(client, bufnr)
                local opts = { noremap=true, silent=true }
                -- Set keymaps for LSP
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>li', '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>', opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
            end

            -- Setup each language server
            local servers = {
                "lua_ls",
                "ts_ls",
                "jdtls",
                "cssls",
                "html",
                "tailwindcss",
                "svelte",
                "pyright",
                "rust_analyzer",
                "gopls",
                "bashls",
                "jsonls",
                "yamlls",
                "dockerls",
                "clangd",
                "cmake",
                "vimls"
            }

            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end

            -- Configuração de diagnóstico
            local default_diagnostic_config = {
                signs = {
                    active = true,
                    values = {
                        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
                        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
                        { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
                        { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
                    },
                },
                virtual_text = false,
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            }

            vim.diagnostic.config(default_diagnostic_config)

            for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
            end
        end,
    },
}
