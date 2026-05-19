-- lua/plugins/utils/which-key.lua

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function()
    local p = vim.g.noctis_palette or require("config.theme.palette").colors
    return {
      preset = "classic",
      defaults = {},
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>F", group = "FzfLua" },
        { "<leader>s", group = "Sessions" },
        { "<leader>e", group = "Explorer" },
        { "<leader>u", group = "Undo" },
        { "<leader>l", group = "LSP" },
        { "<leader>o", group = "Options" },
        { "<leader>b", group = "Buffer" },
        { "<leader>p", group = "Pane" },
        { "<leader>t", group = "Terminal" },
        { "<leader>g", group = "Git" },
        { "<leader>m", group = "Project Tasks" },
        { "<leader>d", group = "Debug" },
        { "<leader>n", group = "Notes/Noice" },
        { "<leader>c", group = "Coding" },
        { "<leader>cq", desc = "Diagnostics To Quickfix" },
        { "<leader>cQ", desc = "Buffer Diagnostics To Quickfix" },
        { "<leader>cg", desc = "Generate Documentation" },
        { "<leader>T", group = "ToggleTerm" },
        { "<leader>A", group = "Arduino" },
        { "<leader>a", group = "Avante" },
        { "<leader>gh", group = "Git Hunks" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>?", group = "Cheatsheets" },
        { "<leader>?m", desc = "Vim Motions" },
        { "<leader>?s", desc = "Surround" },
        { "<leader>?v", desc = "Visual Multi" },
        { "<leader>?t", desc = "Project Tasks" },
        { "ys", desc = "Surround add: ys{motion}{char}" },
        { "cs", desc = "Surround change: cs{old}{new}" },
        { "ds", desc = "Surround delete: ds{char}" },
        { "S", mode = "x", desc = "Surround visual selection" },
        { "<C-n>", desc = "Visual Multi: add next cursor" },
      },
      icons = {
        rules = false,
        separator = ">",
        group = "",
      },
      win = {
        border = "bold",
        padding = { 1, 1 },
      },
      layout = {
        align = "center",
      },
      noctis_palette = {
        bg = p.bg_dark,
        fg = p.fg,
        label = p.blue,
        desc = p.fg_dark,
        border = p.border,
      },
    }
  end,
  config = function(_, opts)
    local p = opts.noctis_palette
    if p then
      vim.api.nvim_set_hl(0, "WhichKeyNormal", { fg = p.fg, bg = p.bg })
      vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = p.border, bg = p.bg })
      vim.api.nvim_set_hl(0, "WhichKey", { fg = p.label, bg = p.bg, bold = true })
      vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = p.label, bg = p.bg, bold = true })
      vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = p.fg, bg = p.bg })
      vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = p.border, bg = p.bg })
      vim.api.nvim_set_hl(0, "WhichKeyValue", { fg = p.desc, bg = p.bg })
      opts.noctis_palette = nil
    end
    local wk = require("which-key")
    wk.setup(opts)
  end,
}
