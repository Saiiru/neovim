return {
  { "akinsho/toggleterm.nvim", version = "*", config = true },
  { "christoomey/vim-tmux-navigator" },
  {
    "szw/vim-maximizer",
    keys = {
      { "<leader>mm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
    },
  },
  { "nvim-lua/plenary.nvim" }, -- lua functions that many plugins use
  { "eandrju/cellular-automaton.nvim" },
  "cdelledonne/vim-cmake",
}
