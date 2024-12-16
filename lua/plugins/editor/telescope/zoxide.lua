return {
  {
    "jvgrootveld/telescope-zoxide",
    config = function()
      -- Wait for telescope.nvim to be loaded before setting up the extension
      LazyVim.on_load("telescope.nvim", function()
        local telescope = require "telescope"

        -- Set up the extension with zoxide integration
        telescope.setup {
          extensions = {
            zoxide = {
              mappings = {
                -- Custom mapping for after-action behavior
                default = {
                  after_action = function(selection)
                    -- Open selected directory using 'find_files' in telescope
                    require("telescope.builtin").find_files { cwd = selection.path }
                  end,
                },
              },
            },
          },
        }

        -- Load the zoxide extension
        telescope.load_extension "zoxide"
      end)
    end,
    keys = {
      { "<leader>fz", "<cmd>Telescope zoxide list<CR>", desc = "Zoxide - Navigate Folders" },
    },
  },

  {
    "goolord/alpha-nvim",
    optional = true,
    opts = function(_, dashboard)
      -- Button for Zoxide integration in the alpha dashboard
      local button = dashboard.button("z", " Zoxide", "<cmd>Telescope zoxide list<CR>")
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"

      -- Add the button to the dashboard
      table.insert(dashboard.section.buttons.val, 5, button)
    end,
  },

  {
    "nvimdev/dashboard-nvim",
    optional = true,
    opts = function(_, opts)
      -- Zoxide button for dashboard center section
      local zoxide = {
        action = "Telescope zoxide list",
        desc = " Zoxide",
        icon = " ",
        key = "z",
      }

      -- Adjust description padding for alignment
      zoxide.desc = zoxide.desc .. string.rep(" ", 43 - #zoxide.desc)
      zoxide.key_format = "  %s"

      -- Insert Zoxide button in the dashboard center section
      table.insert(opts.config.center, 4, zoxide)
    end,
  },
}
