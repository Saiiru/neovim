return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.setup({
      icons = {
        rules = false,
        separator = "➜",
        group = "",
      },
      show_keys = false,
      show_help = false, -- show a help message in the command line for using WhichKey
      layout = {
        align = "center",
      },
      win = {
        border = "double",
        title = false,
        padding = { 1, 1 }, -- extra window padding [top/bottom, right/left]
        no_overlap = true,
      },
    })
  end,
}
