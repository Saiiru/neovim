return {
  "johmsalas/text-case.nvim",
  config = function()
    require("textcase").setup()
    LazyVim.on_load("telescope.nvim", function()
      require("telescope").load_extension("lazy")
    end)
  end,
  keys = {
    { "gC", "<cmd>Text Case Open Telescope<CR>", mode = { "n", "v" }, desc = "Text Case" },
  },
}
