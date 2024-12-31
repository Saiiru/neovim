return {
  "pocco81/auto-save.nvim",
  enabled = true, -- Ativa o auto-save quando o plugin for carregado
  opts = {
    enabled = true, -- Habilita o auto-save
    execution_message = {
      message = function() -- Mensagem que será exibida após salvar
        return ("AutoSaved at " .. vim.fn.strftime("%H:%M:%S"))
      end,
      dim = 0.18, -- Diminui a cor da mensagem para não sobrecarregar
      cleaning_interval = 1250, -- Intervalo de tempo para limpar a mensagem (em milissegundos)
    },
    trigger_events = { "InsertLeave", "FocusLost", "TextChanged" }, -- Eventos que disparam o auto-save
    condition = function(buf)
      local fn = vim.fn
      local utils = require("auto-save.utils.data")

      -- Só salva se o buffer for modificável e o tipo de arquivo não for da lista proibida
      if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
        return true -- O arquivo pode ser salvo
      end
      return false -- O arquivo não pode ser salvo
    end,
    write_all_buffers = true, -- Salva todos os buffers modificados
    debounce_delay = 1000, -- Delay para evitar salvar muito rapidamente (1000ms)
    callbacks = {
      before_saving = function()
        -- Ação antes de salvar
        vim.cmd("echom 'Saving file...'") -- Exibe uma mensagem antes de salvar (opcional)
      end,
      after_saving = function()
        -- Ação após salvar
        vim.cmd("echom 'File saved successfully!'") -- Mensagem após o salvamento (opcional)
      end,
    },
  },
}
