return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- Lazy load on "VeryLazy" event
  config = function()
    local wk = require "which-key"

    wk.setup {
      icons = {
        rules = false,
        separator = "➜", -- Custom separator
        group = "", -- Empty group icon
      },
      show_keys = false, -- Do not show keys by default
      show_help = false, -- Disable help message in the command line
      layout = {
        align = "center", -- Center the layout
      },
      win = {
        border = "double", -- Double border for the window
        title = false, -- Disable window title
        padding = { 1, 1, 1, 1 }, -- Extra padding for window
        no_overlap = true, -- Prevent overlap
      },
    }

    -- Register key mappings using wk.add
    wk.add {
      { "<leader>ci", group = "info", icon = " " },
      { "<leader>l", group = "lazy", icon = "󰒲 " },
    }
  end,
}
