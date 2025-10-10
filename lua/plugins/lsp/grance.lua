-- lua/plugins/lsp/grance.lua :: UI para definições, referências e implementações.

return {
  "dnlhc/glance.nvim",
  cmd = "Glance",
  opts = {
    height = 20,
    preview_win_opts = { number = true, relativenumber = true, wrap = false },
    theme = { enable = true, mode = "auto" },
    border = { enable = true, top_char = "─", bottom_char = "─" },
    list = { position = "right", width = 0.35 },
    folds = { folded = false },
  },
  config = function(_, opts)
    local glance = require("glance")
    glance.setup(opts)

    vim.keymap.set("n", "gd", "<cmd>Glance definitions<CR>",      { desc = "Glance: Definitions" })
    vim.keymap.set("n", "gr", "<cmd>Glance references<CR>",       { desc = "Glance: References" })
    vim.keymap.set("n", "gI", "<cmd>Glance implementations<CR>",  { desc = "Glance: Implementations" })
    vim.keymap.set("n", "gy", "<cmd>Glance type_definitions<CR>", { desc = "Glance: Type Defs" })
  end,
}

