-- Mapeia a tecla <leader>e para abrir o Icon Picker em modo normal
vim.keymap.set("n", "<C-S-e>", ":IconPickerNormal<CR>", { desc = "Open Icon Picker" })

return {
  "ziontee113/icon-picker.nvim",
  dependencies = { "stevearc/dressing.nvim" },
  opts = {
    disable_legacy_commands = true, -- Desativa comandos legados para evitar conflitos
  },
}
