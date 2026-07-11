return {
{ -- HIghlight TODO comments
    "folke/todo-comments.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true
  }
}
