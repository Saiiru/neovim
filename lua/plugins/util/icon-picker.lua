local prefix = "<leader>si"

return {
  -- Icon picker configuration with futuristic feel
  {
    "ziontee113/icon-picker.nvim",
    dependencies = {
      "stevearc/dressing.nvim", -- For better UI styling
    },
    opts = {
      disable_legacy_commands = true, -- Disable legacy commands for better performance
    },
    -- Keybindings for opening different icon categories
    -- Stylized with cyberpunk-inspired groupings
    keys = {
      { prefix .. "a", "<cmd>IconPickerNormal<cr>", desc = "Select All Icons" },
      { prefix .. "s", "<cmd>IconPickerNormal symbols<cr>", desc = "Pick a Symbol" },
      { prefix .. "e", "<cmd>IconPickerNormal emoji<cr>", desc = "Pick an Emoji" },
      { prefix .. "n", "<cmd>IconPickerNormal nerd_font_v3<cr>", desc = "Select Nerd Font" },
    },
  },

  -- Which-key integration for showcasing commands
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          prefix,
          group = "icons",
          icon = " ", -- Icon representing the icon picker group
          desc = "Icon Picker Group", -- Tooltip description for the group
        },
      },
    },
  },
}
