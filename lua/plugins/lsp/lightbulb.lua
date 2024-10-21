-- Configuração do plugin nvim-lightbulb para mostrar ações de código disponíveis
return {
  'kosayoda/nvim-lightbulb',
  event = { "CursorHold", "CursorHoldI" },
  config = function()
    require('nvim-lightbulb').setup({
      -- Configurações de como o ícone será exibido
      sign = {
        enabled = true,  -- Exibe um sinal ao lado da linha
        priority = 10,   -- Prioridade do sinal em relação a outros sinais (como LSP diagnostics)
      },
      virtual_text = {
        enabled = true,  -- Exibe um texto virtual (inline) com o ícone da lâmpada
        text = "💡",     -- Ícone de lâmpada que será exibido
      },
      float = {
        enabled = false, -- Desabilita a exibição em uma janela flutuante
      },
      status_text = {
        enabled = false, -- Desabilita o texto de status
      },
    })

    -- Autocomando para acionar o lightbulb em eventos de LSP
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      pattern = "*",
      callback = function()
        require('nvim-lightbulb').update_lightbulb()
      end,
    })
  end
}

