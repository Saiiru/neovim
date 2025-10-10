-- Mason + Tool Installer + DAP (com cobertura forte de linguagens)
return {
  -- Mason core
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = function()
      return {
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
          width = 0.8,
          height = 0.8,
        },
      }
    end,
  },

  -- LSP via Mason (somente instala; setup é no lspconfig)
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "neovim/nvim-lspconfig" },
    opts = function()
      return {
        ensure_installed = {
          -- Core / Texto
          "lua_ls", "jsonls", "yamlls", "marksman", "lemminx", "taplo", "bashls", "ltex",
          -- Web
          "vtsls", "html", "cssls", "tailwindcss", "emmet_language_server", "eslint", "graphql",
          -- DevOps
          "dockerls", "docker_compose_language_service",
          -- Backends
          "basedpyright", "gopls", "clangd", "intelephense", "sqls", "rust_analyzer",
          -- Java (mantém jdtls no ftplugin, mas garante presença)
          "jdtls",
        },
        automatic_installation = true,
      }
    end,
  },

  -- Ferramentas (formatters/linters/DAP/etc.)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        -- Java
        "java-debug-adapter", "java-test", "google-java-format",
        -- JS/TS
        "prettierd", "eslint_d", "stylelint", "js-debug-adapter",
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
        -- Markdown / YAML
        "markdownlint", "yamllint",
        -- SQL
        "sql-formatter",
        -- Rust
        "rustfmt",
        -- Ortografia
        "cspell",
      },
      auto_update = true,
      run_on_start = true,
      start_delay = 2000,
      debounce_hours = 6,
    },
  },

  -- DAP via Mason (adapters principais; jdtls bundles cuidam do Java)
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = { "codelldb", "js" },
      automatic_setup = true,
    },
  },
}

