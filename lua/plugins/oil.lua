local utils = require("config.functions.utils")

local M = {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  }, -- For icons in the file explorer
  opts = {},
  config = function()
    require("oil").setup({
      default_file_explorer = true,         -- Set Oil as the default file explorer
      delete_to_trash = true,               -- Move files to trash instead of permanent deletion
      skip_confirm_for_simple_edits = true, -- Skip confirmation on simple edits

      view_options = {
        show_hidden = true,     -- Show hidden files like dotfiles
        natural_order = true,   -- Sort files in a natural order
        is_always_hidden = function(name, _)
          return name == ".git" -- Hide the ".." and .git folders
        end,
      },

      -- Floating window configuration
      float = {
        padding = 2,        -- Padding around content
        max_width = 90,     -- Maximum window width in columns
        max_height = 30,    -- Set max height as an integer (e.g., 30 rows)
        border = "rounded", -- Modern rounded border style
        win_options = {
          winblend = 20,    -- Window transparency level
        },
      },

      win_options = {
        wrap = true,   -- Enable line wrapping
        winblend = 20, -- Transparency for all Oil windows
      },

      -- Custom key mappings
      keymaps = {
        ["<C-c>"] = false,                   -- Disable default Ctrl+c for closing
        ["q"] = "actions.close",             -- Use 'q' to close
        ["<C-s>"] = "actions.select_vsplit", -- Open file in vertical split
        ["<C-h>"] = "actions.select_split",  -- Open file in horizontal split
        ["<C-t>"] = "actions.select_tab",    -- Open file in new tab
        ["<C-p>"] = "actions.preview",       -- Preview file
        ["<C-r>"] = "actions.refresh",       -- Refresh directory view
        ["-"] = "actions.parent",            -- Go to parent directory
        ["_"] = "actions.open_cwd",          -- Open current working directory
        ["`"] = "actions.cd",                -- Change directory
        ["gs"] = "actions.change_sort",      -- Toggle sorting methods
        ["gx"] = "actions.open_external",    -- Open file with external app
        ["g."] = "actions.toggle_hidden",    -- Toggle hidden files visibility
      },
    })

    -- Keymap to open Oil in a floating window with parent directory
    vim.keymap.set("n", "<C-h>", function()
      local path = vim.fn.expand("%:p") -- Get full path of the current file
      local dir = utils.dirname(path)   -- Get the parent directory
      require("oil").open_float(dir)    -- Open Oil in a floating window for parent directory
    end, { desc = "Open parent directory in float" })
  end,
}

-- Autocommand to maintain focus correctly when opening Oil
vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",
  callback = vim.schedule_wrap(function(args)
    local oil = require("oil")
    if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
      utils.jump_to_line(vim.g.oil_last_file) -- Restore cursor to last opened file
    end
  end),
})

return M
