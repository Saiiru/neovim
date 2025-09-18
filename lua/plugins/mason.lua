-- lua/plugins/mason.lua
return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    build = ":MasonUpdate", -- atualiza índices; não força upgrade de bins
    opts = {
      ui = { border = "rounded", check_outdated_packages_on_open = false, icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        -- Core
        "lua_ls","jsonls","yamlls","bashls","marksman","taplo","lemminx",
        -- Web/FE
        "html","cssls","tailwindcss","emmet_ls","vtsls","eslint","svelte","angularls","astro","graphql",
        -- Backend/Infra
        "dockerls","docker_compose_language_service",
        -- Langs
        "jdtls","gopls","pyright","clangd","rust_analyzer","intelephense","arduino_language_server",
      },
      automatic_installation = true,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        -- LSPs fora do mason-lspconfig
        "vue-language-server", "ruff-lsp",
        -- Formatters
        "stylua","biome","prettierd","black","isort","ruff","gofumpt","goimports-reviser","rustfmt","clang-format","shfmt","php-cs-fixer","jq","taplo","google-java-format",
        -- Linters
        "eslint_d","shellcheck","hadolint","yamllint","markdownlint","golangci-lint","phpstan","sqlfluff",
        -- DAP
        "js-debug-adapter","debugpy","delve","codelldb","java-test","java-debug-adapter",
      },
      run_on_start = true,
      start_delay = 100,
      integrations = { ["mason-lspconfig"] = true },
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
      -- Garantir um chute inicial mesmo sem VeryLazy
      vim.defer_fn(function() pcall(require, "mason-tool-installer").check_install, true end, 200)
    end,
  },
}