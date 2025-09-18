-- lua/plugins/conform.lua
return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      notify_on_error = true,
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "biome", "prettierd", "prettier" },
        typescript = { "biome", "prettierd", "prettier" },
        javascriptreact = { "biome", "prettierd", "prettier" },
        typescriptreact = { "biome", "prettierd", "prettier" },
        json = { "biome", "prettierd", "prettier", "jq" },
        jsonc = { "biome", "prettierd", "prettier" },
        css = { "prettierd", "prettier" }, scss = { "prettierd", "prettier" }, html = { "prettierd", "prettier" },
        vue = { "prettierd", "prettier" }, svelte = { "prettierd", "prettier" }, astro = { "prettierd", "prettier" },
        graphql = { "prettierd", "prettier" }, markdown = { "prettierd", "prettier" }, ["markdown.mdx"] = { "prettierd", "prettier" }, yaml = { "prettierd", "prettier" },
        go = { "gofumpt", "goimports-reviser" }, python = { "ruff_format", "ruff_organize_imports", "black" },
        rust = { "rustfmt" }, php = { "php_cs_fixer" }, java = { "google-java-format" }, c = { "clang_format" }, cpp = { "clang_format" }, cs = { "csharpier" },
        sh = { "shfmt" }, bash = { "shfmt" }, toml = { "taplo" }, sql = { "sqlfluff" }, xml = {}, dockerfile = {},
      },
      format_on_save = false,
      formatters = {
        biome = { prefer_local = "node_modules/.bin" },
        prettierd = { prefer_local = "node_modules/.bin" },
        prettier = { prefer_local = "node_modules/.bin" },
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
        jq = { prepend_args = { "-S" } },
        ["google-java-format"] = {},
        sqlfluff = { extra_args = { "--dialect", "postgres" } },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Conform: format buffer/selection" })
    end,
  },
}