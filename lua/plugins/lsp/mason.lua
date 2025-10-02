return {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "neovim/nvim-lspconfig",
        -- "saghen/blink.cmp",
    },
    config = function()
        -- import mason and mason_lspconfig
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        -- NOTE: Moved these local imports below back to lspconfig.lua due to mason depracated handlers

        -- local lspconfig = require("lspconfig")
        -- local cmp_nvim_lsp = require("cmp_nvim_lsp")             -- import cmp-nvim-lsp plugin
        -- local capabilities = cmp_nvim_lsp.default_capabilities() -- used to enable autocompletion (assign to every lsp server config)

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            ensure_installed = {
                -- Core/Editor
                "lua_ls", "jsonls", "yamlls", "bashls", "marksman", "lemminx", "taplo",

                -- Web/Front
                "vtsls", -- TS/JS (recomendado p/ IntelliSense rápido)  -- vtsls docs: github.com/yioneko/vtsls
                "html", "cssls", "tailwindcss", "emmet_language_server", "eslint", "graphql",

                -- Back/Cloud/DevOps
                "dockerls", "docker_compose_language_service",

                -- Java
                "jdtls", -- Language Server
                "java-debug-adapter", -- Debugger (DAP)
                "java-test", -- Test runner
                "google-java-format", -- Formatter (Google)
                -- Go / C / C++ / PHP / Python / SQL
                "gopls", "clangd", "intelephense", "basedpyright", "sqls",
            },
        })

        mason_tool_installer.setup({
            ensure_installed = {
                -- Java tooling (instala via Mason)
                "java-debug-adapter", "java-test",
                "google-java-format", -- Java formatter
                "java-debug-adapter",
                "java-test",
                -- JS/TS/WEB
                "prettierd", "eslint_d", "stylelint",

                -- Lua
                "stylua",

                -- Shell
                "shfmt", "shellcheck",

                -- Python
                "black", "isort", "ruff", "debugpy",

                -- Go
                "gofumpt", "goimports", "golangci-lint", "delve",

                -- C/C++
                "clang-format", "codelldb",

                -- PHP
                "phpcs", "phpcbf",

                -- Docker
                "hadolint",

                -- Markdown/Docs
                "markdownlint",

                -- YAML (CI/CD)
                "yamllint",

                -- SQL
                "sql-formatter",
            },
        })
    end,
}
