return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, desc = "Format" },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        javascript = { "biome" },
        typescript = { "biome" },
        json = { "biome" },
        markdown = { "dprint" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "ruff" },
        javascript = { "biomejs" },
        typescript = { "biomejs" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function() pcall(lint.try_lint) end,
      })
    end,
  },
}
