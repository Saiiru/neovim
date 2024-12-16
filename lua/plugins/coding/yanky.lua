return {
  -- LazyVim extra for Yanky plugin integration
  {
    import = "lazyvim.plugins.extras.coding.yanky",
  },

  -- Yanky plugin configuration
  {
    "gbprod/yanky.nvim",
    opts = function(_, opts)
      local utils = require "yanky.utils"
      local mapping = require "yanky.telescope.mapping"

      -- Yanky plugin options
      opts.highlight = { timer = 250 } -- Highlight timer
      opts.picker = {
        telescope = {
          use_default_mappings = false, -- Disable default mappings to avoid conflicts
          mappings = {
            -- Normal mode mappings
            n = {
              p = mapping.put "p", -- Put (paste) yanked content
              P = mapping.put "P", -- Put (paste) yanked content before cursor
              d = mapping.delete(), -- Delete the yanked content
              r = mapping.set_register(utils.get_default_register()), -- Set the register
            },
            -- Insert mode mappings
            i = {
              ["<c-g>"] = mapping.put "p", -- Paste in insert mode
              ["<c-h>"] = mapping.put "P", -- Paste before cursor in insert mode
              ["<c-x>"] = mapping.delete(), -- Delete in insert mode
              ["<c-r>"] = mapping.set_register(utils.get_default_register()), -- Set register in insert mode
            },
            -- Default mappings (fallback for other modes)
            default = mapping.put "p",
          },
        },
      }
    end,

    -- Key mappings for Yanky
    keys = {
      {
        "<leader>sy",
        function()
          -- Try loading Telescope extension for Yanky History
          local ok, telescope = pcall(require, "telescope")
          if ok then
            telescope.extensions.yank_history.yank_history {}
          else
            -- Fallback to default YankyRingHistory if Telescope is unavailable
            vim.cmd [[YankyRingHistory]]
          end
        end,
        mode = { "n", "v" }, -- Available in normal and visual modes
        desc = "Show Yank History", -- Descriptive name for the keybinding
      },
    },
  },
}
