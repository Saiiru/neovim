-- lua/plugins/which-key.lua
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    icons = { rules = false, separator = "➜", group = "" },
    show_help = false, show_keys = false,
    layout = { align = "center" },
    win = { border = "rounded", title = false, padding = {1,1}, no_overlap = true },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>f", group = "Telescope" },
      { "<leader>s", group = "Sessions" },
      { "<leader>e", group = "File Tree" },
      { "<leader>u", group = "Undotree" },
      { "<leader>l", group = "LSP" },
      { "<leader>o", group = "Options" },
      { "<leader>b", group = "Buffer" },
      { "<leader>p", group = "Pane" },
      { "<leader>t", group = "Terminal" },
      { "<leader>g", group = "Git" },
      { "<leader>c", group = "Snacks" },
      { "<leader>n", group = "Noice" },
      -- Java
      { "<leader>j", group = "Java" },
      { "<leader>jo", hidden = true, desc = "Organize Imports" },
      { "<leader>jt", hidden = true, desc = "Test Nearest" },
      { "<leader>jT", hidden = true, desc = "Test Class" },
      { "<leader>jr", hidden = true, desc = "Rename" },
      { "<leader>je", hidden = true, desc = "Extract Var" },
      { "<leader>jE", hidden = true, desc = "Extract Const" },
      { "<leader>jM", hidden = true, desc = "Extract Method" },
      -- DAP
      { "<leader>d", group = "Debug" },
    })
  end,
}

