return {
  'ruifm/gitlinker.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    -- Configurando o gitlinker
    require("gitlinker").setup({
      opts = {
        print_url = false, -- Impede a impressão da URL no buffer
        action_callback = function(...)
          -- Copia a localização para a área de transferência
          require("gitlinker.actions").copy_to_clipboard(...)
          vim.notify("Copied location to clipboard") -- Notifica o usuário
        end,
      },
    })
  end,
}
