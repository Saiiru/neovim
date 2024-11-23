return {
  "crispgm/telescope-heading.nvim",
  config = function()
    LazyVim.on_load("telescope.nvim", function()
      require("plugins.coding.dap.telescope").setup({
        extensions = {
          heading = {
            treesitter = true,
          },
        },
      })
      require("plugins.coding.dap.telescope").load_extension("heading")
    end)
  end,
  keys = {
    { "<leader>s#", "<cmd>Telescope heading<CR>", desc = "Headings" },
  },
}
