return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- Importa o plugin de comentários
    local comment = require("Comment")
    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    -- Configuração do Comment.nvim
    comment.setup({
      padding = true, -- Adiciona espaço entre o comentário e o conteúdo
      sticky = true,  -- Mantém o cursor no lugar após o comentário

      -- Integrar contextos de comentário para linguagens com estrutura aninhada
      pre_hook = function(ctx)
        local U = require("Comment.utils")

        -- Detecção de arquivos baseados em Treesitter (ex.: TSX, JSX, HTML)
        local location = nil
        if ctx.ctype == U.ctype.block then
          location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return ts_context_commentstring.create_pre_hook()(ctx, location)
      end,

      -- Configurações adicionais para maior controle em arquivos comuns
      mappings = {
        basic = true,     -- Habilita mapeamentos básicos (gc, gb, etc.)
        extra = true,     -- Habilita mapeamentos adicionais
        extended = false, -- Desabilita mapeamentos estendidos para evitar conflitos
      },

      -- Configuração por linguagem para evitar conflitos com linguagens aninhadas
      toggler = {
        line = "gcc",  -- Alterna comentário de linha única
        block = "gbc", -- Alterna comentário de bloco
      },
      opleader = {
        line = "gc",
        block = "gb",
      },
    })
  end,
}
