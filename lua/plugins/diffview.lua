return {
  "sindrets/diffview.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  opts = {
    -- Configure file panel appearance
    file_panel = {
      position = "bottom", -- Keeps the file panel at the bottom
      height = 20, -- Adjusts the height of the panel
      win_config = {
        winhighlight = "Normal:DiffviewNormal,SignColumn:DiffviewSignColumn,StatusLine:DiffviewStatusLine",
      },
    },

    -- Customizing colors to fit a Cyberpunk theme
    use_icons = true,
    colors = {
      -- Changing colors to neon-like styles
      normal = { fg = "#D0D0D0", bg = "#181818" }, -- Light text on dark background
      diff_add = { fg = "#00FF00", bg = "#002200" }, -- Neon green for additions
      diff_remove = { fg = "#FF007F", bg = "#330000" }, -- Neon red for removals
      diff_change = { fg = "#00FFFF", bg = "#003333" }, -- Cyan for changes
      diff_file = { fg = "#FF1493", bg = "#1A1A1A" }, -- Purple for file names
    },

    -- Custom hooks to add Cyberpunk-like effects when opening/closing the diff
    hooks = {
      view_opened = function()
        -- Sending a tmux command to set a user variable for Cyberpunk mode
        local stdout = vim.loop.new_tty(1, false)
        if stdout ~= nil then
          stdout:write(
            ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format("DIFF_VIEW", vim.fn.system({ "base64" }, "+4"))
          )
          vim.cmd([[redraw]])
        end
        -- Displaying a notification when entering Diff mode
        vim.notify("Entering Cyberpunk Diff Mode...", vim.log.levels.INFO)
      end,
      view_closed = function()
        -- Sending a tmux command to reset the user variable when closing the view
        local stdout = vim.loop.new_tty(1, false)
        if stdout ~= nil then
          stdout:write(
            ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format("DIFF_VIEW", vim.fn.system({ "base64" }, "-1"))
          )
          vim.cmd([[redraw]])
        end
        -- Displaying a notification when exiting Diff mode
        vim.notify("Exiting Cyberpunk Diff Mode...", vim.log.levels.INFO)
      end,
    },
  },

  -- Custom keybindings with neon-like icons
  keys = function()
    require("which-key").add({
      -- Define the leader key and the group name
      {
        "<leader>gd",
        group = "Diffview", -- Group name for diffview commands
        icon = "", -- Custom icon for diffview
      },
    })
    -- Mapping keys for various Diffview commands
    local function map(key, cmd, desc)
      vim.keymap.set("n", "<leader>gd" .. key, cmd, { desc = desc, noremap = true, silent = true })
    end
    map("o", ":DiffviewOpen<CR>", "Open Diffview")
    map("c", ":DiffviewClose<CR>", "Close Diffview")
    map("f", ":DiffviewFocusFiles<CR>", "Focus Files Panel")
    map("t", ":DiffviewToggleFiles<CR>", "Toggle Files Panel")
    map("r", ":DiffviewRefresh<CR>", "Refresh Diffview")
    map("h", ":DiffviewFileHistory<CR>", "File History")
  end,
}
