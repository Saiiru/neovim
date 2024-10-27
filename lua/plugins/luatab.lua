return {
  "alvarosevilla95/luatab.nvim",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    local colorMap = require("util.colormap") -- Importa o mapa de cores
    local luatab = require("luatab")

    luatab.setup({
      devicon = function() return "  " end,
      separator = function(index) return index % 2 == 0 and "▎" or "▏" end,
    })

    vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { desc = "[T]ab [N]ext" })
    vim.keymap.set("n", "<leader>tp", ":tabprev<CR>", { desc = "[T]ab [P]rev" })
    vim.keymap.set("n", "<leader>tc", ":bd<CR>", { desc = "[T]ab [C]lose" })

    vim.api.nvim_set_hl(0, "TabLineSel", { bg = colorMap.neonBlue, fg = colorMap.neonPink, bold = true })
    vim.api.nvim_set_hl(0, "TabLine", { bg = colorMap.backgroundDark, fg = colorMap.grayLight, italic = true })
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = colorMap.backgroundDark })
    vim.api.nvim_set_hl(0, "TabLineSeparator", { fg = colorMap.neonBlue, bg = colorMap.backgroundDark })
  end
}
