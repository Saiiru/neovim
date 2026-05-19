return {
  "mason-org/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = function()
    local ensure_installed = {
      "astro",
      "arduino_language_server",
      "bashls",
      "basedpyright",
      "biome",
      "clangd",
      "cssls",
      "docker_compose_language_service",
      "dockerls",
      "emmet_ls",
      "eslint",
      "gopls",
      "html",
      "jsonls",
      "kotlin_language_server",
      "lemminx",
      "ltex_plus",
      "lua_ls",
      "marksman",
      "rust_analyzer",
      "svelte",
      "tailwindcss",
      "taplo",
      "texlab",
      "ts_ls",
      "vue_ls",
      "vimls",
      "yamlls",
    }

    if vim.fn.exepath("nix") ~= "" then
      table.insert(ensure_installed, "nil_ls")
    end

    return {
      ensure_installed = ensure_installed,
      automatic_enable = false,
    }
  end,
  config = function(_, opts)
    require("mason-lspconfig").setup(opts)
  end,
}
