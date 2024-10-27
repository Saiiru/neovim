return {
  'rlane/pounce.nvim',                      -- Nome do plugin
  config = function()
    vim.keymap.set("n", "m", ":Pounce<CR>") -- Mapeia a tecla 'm' para ativar o Pounce
  end
}
