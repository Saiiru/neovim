return {
  {
    "debugloop/telescope-undo.nvim",
    opts = {},
    config = function()
      LazyVim.on_load("telescope.nvim", function()
        require("plugins.coding.dap.telescope").setup({
          extensions = {
            undo = {
              side_by_side = true,
              layout_strategy = "vertical",
              layout_config = {
                preview_height = 0.6,
              },
            },
          },
        })
        require("plugins.coding.dap.telescope").load_extension("undo")
      end)
    end,
    keys = {
      { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undos" },
    },
  },
}
