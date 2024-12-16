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
  { "folke/lazy.nvim", version = false },
  { "LazyVim/LazyVim", version = false },
  -- Use mini.icon for better performance
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    config = function(_, options)
      local icons = require "mini.icons"
      icons.setup(options)
      -- Mocking methods of 'nvim-tree/nvim-web-devicons' for better integrations with plugins outside 'mini.nvim'
      icons.mock_nvim_web_devicons()
    end,
  },
  { import = "lazyvim.plugins.extras.ai.copilot-chat" },
  { import = "plugins.langs" },
}

return M
