return {
  { "mfussenegger/nvim-dap-python", enabled = false },
  {
    "nvim-neotest/neotest",
    lazy = true,
    ft = "python",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {},
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    enabled = false,
  },
}
