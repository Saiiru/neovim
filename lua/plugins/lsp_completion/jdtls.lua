return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  cond = function()
    return require("config.jdtls").has_java_21()
  end,
  dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp",
  },
  config = function()
    require("config.jdtls").start()
  end,
}
