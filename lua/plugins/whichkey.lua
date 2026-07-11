return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 300,
      preset = "helix",
      spec = {
        { "<leader>p", group = "PDE" },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>q", group = "Quickfix" },
      },
    },
  },
}
