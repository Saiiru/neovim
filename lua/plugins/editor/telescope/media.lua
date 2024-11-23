return {
  "dharmx/telescope-media.nvim",
  config = function()
    LazyVim.on_load("telescope.nvim", function()
      require("plugins.coding.dap.telescope").setup({
        extensions = {
          media = {
            backend = "ueberzug", -- image/gif backend
          },
        },
      })
      require("plugins.coding.dap.telescope").load_extension("media")
    end)
  end,
  keys = {
    { "<leader>sM", "<cmd>Telescope media<CR>", desc = "Media" },
  },
}
