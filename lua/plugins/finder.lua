return {
  {
    "echasnovski/mini.pick",
    version = false,
    keys = { "<leader>ff", "<leader>fg", "<leader>fb" },
    config = function()
      require("mini.pick").setup()
    end,
  },
}
