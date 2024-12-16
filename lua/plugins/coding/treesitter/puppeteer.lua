return {
  "nvim-treesitter/nvim-treesitter", -- Core Treesitter plugin
  dependencies = {
    "chrisgrieser/nvim-puppeteer", -- Puppeteer integration for Treesitter
  },

  opts = {
    -- Treesitter specific options
    treesitter = {
      ensure_installed = "maintained", -- Automatically install maintained parsers
      highlight = {
        enable = true, -- Enable syntax highlighting
        disable = {}, -- Optionally disable highlighting for specific languages
      },
      indent = {
        enable = true, -- Enable Treesitter-based indentation
        disable = {}, -- Optionally disable indentation for specific languages
      },
      -- Additional Treesitter options can be added here if necessary
    },

    -- Puppeteer specific options
    puppeteer = {
      enable = true, -- Enable Puppeteer features (visualization, tree manipulation)
      -- Example option for Puppeteer, add more as needed
      -- other_option = true,
    },
  },

  -- Key mappings for Treesitter and Puppeteer functionalities can be added here
  keys = {
    -- Example keybinding (for Treesitter or Puppeteer-related actions)
    -- {
    --   "<leader>th", "<cmd>TSHighlightCapturesUnderCursor<cr>",
    --   mode = "n",
    --   desc = "Highlight Captures Under Cursor"
    -- },
  },
}
