-- Mason + Tool Installer + DAP (sem servers inválidos no ensure_installed)
return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
        width = 0.8,
        height = 0.8,
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        -- DAP/Debug
        "js-debug-adapter", "java-debug-adapter", "java-test", "codelldb",
        -- Formatters/Linters
        "prettierd", "prettier", "biome", "stylua", "black", "isort",
        "clang-format", "golangci-lint", "gofumpt", "goimports",
        "shellcheck", "shfmt", "markdownlint", "yamllint", "sql-formatter",
        "google-java-format", "eslint_d",
      },
      auto_update = true,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 6,
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = { "codelldb", "js" }, -- java debug vem via nvim-jdtls bundles
      automatic_setup = true,
    },
  },
}

