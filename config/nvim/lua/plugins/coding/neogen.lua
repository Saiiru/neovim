-- ================================================================================================
-- TITLE : neogen
-- ABOUT : Gera docstrings/comentários estruturados para funções, classes e tipos.
-- HOW   : `<leader>cg` cria documentação no nó atual.
-- ================================================================================================

return {
  "danymat/neogen",
  cmd = "Neogen",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    snippet_engine = "luasnip",
    languages = {
      lua = { template = { annotation_convention = "emmylua" } },
      python = { template = { annotation_convention = "google_docstrings" } },
      javascript = { template = { annotation_convention = "jsdoc" } },
      typescript = { template = { annotation_convention = "tsdoc" } },
      java = { template = { annotation_convention = "javadoc" } },
    },
  },
  keys = {
    {
      "<leader>cg",
      function()
        require("neogen").generate()
      end,
      desc = "Generate Documentation",
    },
  },
}
