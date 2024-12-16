-- File: lua/config/mason.lua
-- Mason configuration for managing tools and language servers

local M = {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- LSP servers
    "jay-babu/mason-nvim-dap.nvim", -- Debuggers
    "WhoIsSethDaniel/mason-tool-installer.nvim", -- Additional tools
  },
}

function M.config()
  require("mason").setup {
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✔",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  }

  require("mason-lspconfig").setup {
    ensure_installed = {
      -- Frontend
      "ts_ls",
      "eslint",
      "html",
      "cssls",
      "tailwindcss",
      "volar",
      "angularls",
      "lua_ls",
      "quick_lint_js",
      "gradle_ls",
      "groovyls",
      "bashls",

      -- Backend
      "pyright",
      "jdtls",
      "intelephense",
      "clangd",
      "dockerls",
      "jsonls",
      "yamlls",
    },
    automatic_installation = true,
  }

  require("mason-tool-installer").setup {
    ensure_installed = {
      "prettier",
      "eslint_d",
      "black",
      "isort",
      "shellcheck",
      "shfmt",
      "stylua",
      "java-debug-adapter",
      "java-test",
      "google-java-format",
      "clang-format",
      "gopls",
      "luacheck",
    },
    auto_update = true,
  }
  -- There is an issue with mason-tools-installer running with VeryLazy, since it triggers on VimEnter which has already occurred prior to this plugin loading so we need to call install explicitly
  -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
  vim.api.nvim_command "MasonToolsInstall"
end

return M
