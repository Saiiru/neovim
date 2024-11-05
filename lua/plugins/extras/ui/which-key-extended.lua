return {
  "folke/which-key.nvim",
  opts = {
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    spec = {
      { "<leader>ci", group = "info", icon = " " },
      { "<leader>l", group = "lazy", icon = "󰒲 " },
    },
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = false,
        g = false,
      },
    },
    win = {
      border = "rounded",
      padding = { 2, 2, 2, 2 },
    },
    layout = {
      height = { min = 4, max = 10 },
      width = { min = 20, max = 50 },
      spacing = 2,
      align = "left",
    },
    show_help = true,
  },
}
