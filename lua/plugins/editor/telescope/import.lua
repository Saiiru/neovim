return {
  "piersolenski/telescope-import.nvim",
  opts = {},
  config = function()
    LazyVim.on_load("telescope.nvim", function()
      require("plugins.coding.dap.telescope").setup({
        extensions = {
          import = {
            insert_at_top = true,
          },
        },
      })
      require("plugins.coding.dap.telescope").load_extension("import")
    end)
  end,
  keys = {
    { "<leader>sI", "<cmd>Telescope import<CR>", desc = "Imports" },
  },
}
