local M = {
  -- Plugin list
  {
    "preservim/vim-pencil",
  },
  {
    "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    config = function()
      require "nvim-web-devicons"
    end,
  },
  { "folke/lazy.nvim",                                version = false },
  { "LazyVim/LazyVim",                                version = false },
  { import = "lazyvim.plugins.extras.ai.copilot-chat" },
  { import = "plugins.langs" },
}

return M
