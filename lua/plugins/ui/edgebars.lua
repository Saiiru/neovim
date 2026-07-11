return {
  {
    "s1n7ax/nvim-window-picker",
    name = 'window-picker',
    event = "VeryLazy",
    version = '2.*',
    config = true,
    enabled = false
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    enabled = true,
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    keys = {
      -- Go to last focused main window
      ["<leader>em"] = function()
        require("edgy").goto_main()
      end,
      -- Select window
      ["<leader>ew"] = function()
        require("edgy").select()
      end,
      -- Close all windows except current
      ["<leader>ex"] = function()
        require("edgy").close()
      end,
      -- Open all windows
      ["<leader>eo"] = function()
        require("edgy").open()
      end,
      -- Toggle pinned windows
      ["<leader>ep"] = function()
        require("edgy").toggle()
      end,
      -- increase width
      ["<c-s-Right>"] = function(win)
        win:resize("width", 2)
      end,
      -- decrease width
      ["<c-s-Left>"] = function(win)
        win:resize("width", -2)
      end,
      -- increase height
      ["<c-s-Up>"] = function(win)
        win:resize("height", 2)
      end,
      -- decrease height
      ["<c-s-Down>"] = function(win)
        win:resize("height", -2)
      end,
    },
    opts = {
      options = {
        left = {
          width = 50,
        },
      },
      bottom = {
        -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
        {
          title = "Issues",
          ft = "trouble",
          size = { height = 0.3 }
        },
        {
          ft = "qf",
          title = "QuickFix"
        },
        {
          ft = "help",
          title = "Help",
          size = { height = 20 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
      },
      left = {
                {
          ft = "snacks_explorer",
          title = "Explorer",
          pinned = true,
          open = function()
            return Snacks.explorer.open()
          end
        },
        {
          ft = "Outline",
          title = "Outline",
          pinned = true,
          size = { height = 0.30  , width = 40 },
          open = "SymbolsOutlineOpen",
        },
      },
      right = {
        {
          ft = "copilot-chat",
          title = "Copilot Chat",
          size = { width = 50 },
        },
        {
          title = "Grug Far",
          ft = "grug-far",
          size = { width = 0.4 }
        }
      }
    },
  }

}
