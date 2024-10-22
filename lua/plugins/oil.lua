return {
  "stevearc/oil.nvim",
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require("oil")

    -- Constantes para configurações de janela
    local FLOAT_PADDING = 2
    local MAX_WIDTH = 90

    -- Configuração principal do plugin
    oil.setup({
      default_file_explorer = true,    -- Define como explorador de arquivos padrão
      delete_to_trash = true,          -- Enviar arquivos deletados para a lixeira
      skip_confirm_for_simple_edits = true, -- Ignorar confirmação para edições simples
      view_options = {
        show_hidden = true,            -- Mostrar arquivos ocultos
        natural_order = true,          -- Ordenação natural dos arquivos
        is_always_hidden = function(name, _)
          return name == ".." or name == ".git"  -- Esconder o diretório pai e a pasta .git
        end,
      },
      float = {
        padding = FLOAT_PADDING,       -- Padding ao redor da janela
        max_width = MAX_WIDTH,         -- Largura máxima da janela flutuante
        max_height = 0,                -- Altura máxima (automático se 0)
      },
      win_options = {
        wrap = true,                   -- Habilitar quebra de linha
        winblend = 0,                  -- Transparência da janela
      },
      -- Keymaps personalizados
      keymaps = {
        ["<C-c>"] = false,             -- Desabilitar o mapeamento padrão do <C-c>
        ["q"] = "actions.close",       -- Fechar a janela com "q"
      },
    })
  end,
}

