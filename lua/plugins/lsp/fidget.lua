-- Configuração do plugin Fidget para mostrar status do LSP
return {
  'j-hui/fidget.nvim',
  tag = 'legacy', -- Use a versão estável com tag "legacy"
  config = function()
    require('fidget').setup({
      text = {
        spinner = "dots", -- Escolha do estilo de carregamento (pode ser "dots", "line", "arc", etc.)
      },
      align = {
        bottom = true, -- Mostra o status na parte inferior
        right = true, -- Alinhado à direita
      },
      window = {
        relative = "win", -- Janela relativa à janela atual
        blend = 0, -- Transparência da janela (0 é opaco, 100 é totalmente transparente)
      },
      fmt = {
        task = function(task_name, message, percentage)
          return string.format(
            "%s [%s%%]: %s", task_name, percentage or 0, message
          )
        end,
      },
      timer = {
        spinner_rate = 125, -- Velocidade do spinner (em ms)
        fidget_decay = 2000, -- Tempo antes de desaparecer após a conclusão
        task_decay = 1000, -- Tempo de vida do status após conclusão da tarefa
      },
      sources = {
        ["*"] = {
          ignore = false, -- Mostra todas as tarefas
        }
      }
    })
  end
}

