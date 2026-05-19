return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp",
  },
  config = function()
    require("config.jdtls").start()
  end,
}
