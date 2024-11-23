return {
  "nvim-telescope/telescope-live-grep-args.nvim",
  config = function()
    LazyVim.on_load("telescope.nvim", function()
      require("plugins.coding.dap.telescope").load_extension("lazy")
    end)
  end,
  -- stylua: ignore
  keys = {
    { "<leader>sg", function() require("plugins.coding.dap.telescope").extensions.live_grep_args.live_grep_args() end, desc = "Grep (root dir)" },
    { "<leader>/", function() require("plugins.coding.dap.telescope").extensions.live_grep_args.live_grep_args() end, desc = "Grep (root dir)" },
  },
}
