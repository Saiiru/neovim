return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require "which-key"
    wk.setup {
      preset = "helix",
      icons = { separator = "➜", group = "", mappings = false, rules = false },
      show = { help = true, keys = true },
      layout = { height = { min = 4, max = 25 }, width = { min = 20, max = 50 }, spacing = 3, align = "center" },
      win = {
        border = "rounded",
        title = " KORA COMMAND MATRIX ",
        title_pos = "center",
        padding = { 1, 2 },
        no_overlap = true,
      },
    }

    wk.add {
      { "<leader>b", group = " 󰈔  Buffer" },
      { "<leader>c", group = "   Code" },
      { "<leader>d", group = "   Debug" },
      { "<leader>e", group = " 󰙅  Explorer" },
      { "<leader>f", group = " 󰍉  Find" },
      { "<leader>g", group = " 󰊢  Git" },
      { "<leader>h", group = "   Hunk" },
      { "<leader>j", group = "   Java" },
      { "<leader>l", group = " 󰛡  LSP" },
      { "<leader>n", group = " 󰍫  Noice" },
      { "<leader>o", group = " 󰒓  Options" },
      { "<leader>p", group = "   Pane" },
      { "<leader>s", group = "   Split" },
      { "<leader>t", group = "   Terminal/Tab" },
      { "<leader>u", group = " 󰚀  Utils" },
      { "<leader>r", group = " 󰜎  Run/Build" }, -- << novo prefixo
      -- nada em <leader>x: Trouble já ocupa
    }
  end,
}
