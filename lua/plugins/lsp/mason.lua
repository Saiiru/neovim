-- lua/plugins/lsp/mason.lua
return {
  "williamboman/mason.nvim",
  lazy = false,
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tools = require("mason-tool-installer")

    mason.setup({
      ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        -- Core
        "lua_ls", "jsonls", "yamlls", "bashls", "marksman", "lemminx", "taplo",
        -- Web
        "vtsls", "html", "cssls", "tailwindcss", "emmet_language_server", "eslint", "graphql",
        -- DevOps
        "dockerls", "docker_compose_language_service",
        -- BE
        "gopls", "clangd", "basedpyright", "rust_analyzer", "intelephense", "sqls",
        -- Java (apenas LSP aqui)
        "jdtls",
      },
    })

    mason_tools.setup({
      ensure_installed = {
        -- Java (tools)
        "java-debug-adapter", "java-test", "google-java-format",
        -- DAPs
        "js-debug-adapter", "debugpy", "codelldb", "delve",
        -- Formatters/Linters
        "stylua", "prettierd", "eslint_d", "stylelint",
        "shfmt", "shellcheck",
        "black", "isort", "ruff",
        "gofumpt", "goimports", "golangci-lint",
        "clang-format",
        "phpcs", "phpcbf",
        "hadolint",
        "markdownlint",
        "yamllint",
        "sql-formatter",
      },
      auto_update = false,
      run_on_start = true,
    })
  end,
}

