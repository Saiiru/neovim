return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      -- Importa o Mason
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local mason_tool_installer = require("mason-tool-installer")

      -- Habilita o Mason e configura os ícones
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
        -- Lista de servidores que o Mason deve instalar
        ensure_installed = {
          "tsserver", -- TypeScript Server
          "html", -- HTML Server
          "cssls", -- CSS Language Server
          "tailwindcss", -- Tailwind CSS Server
          "svelte", -- Svelte Language Server
          "lua_ls", -- Lua Language Server
          "graphql", -- GraphQL Language Server
          "emmet_ls", -- Emmet Language Server
          "pyright", -- Python Language Server
          "jdtls", -- Java Development Tools
          "clangd", -- C/C++ Language Server
          "gopls", -- Go Language Server
          "phpactor", -- PHP Language Server
          "bashls", -- Bash Language Server
          "angularls", -- Angular Language Server
        },
      })

      mason_tool_installer.setup({
        ensure_installed = {
          -- Formatadores
          "black", -- Python Formatter
          "google-java-format", -- Google Java Formatter
          "rustfmt", -- Rust Formatter
          "shfmt", -- Shell Script Formatter
          "prettier", -- JavaScript/TypeScript Formatter
          "stylua", -- Lua Formatter
          "php-cs-fixer", -- PHP Formatter

          -- Linters
          "flake8", -- Python Linter
          "checkstyle", -- Java Linter
          "luacheck", -- Lua Linter
          "eslint_d", -- JavaScript/TypeScript Linter
          "shellcheck", -- Shell Script Linter
        },
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      -- Garante que os adaptadores de depuração estão instalados
      require("mason-nvim-dap").setup({
        automatic_installation = true,
        ensure_installed = {
          "java-debug-adapter", -- Adaptador de depuração para Java
          "java-test", -- Adaptador de teste para Java
          "js-debug-adapter", -- Adaptador de depuração para JavaScript/TypeScript
          "codelldb", -- Adaptador de depuração para C/C++
          "go-delve-debugger", -- Adaptador de depuração para Go
          "python-debugger", -- Adaptador de depuração para Python
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function() end,
  },
}
