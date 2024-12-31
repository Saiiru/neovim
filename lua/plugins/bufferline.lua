return {
  "akinsho/bufferline.nvim",
  enabled = true,
  opts = function()
    local Offset = require("bufferline.offset")

    -- Integração com o Edgy para ajustar os offsets
    if not Offset.edgy then
      local original_get = Offset.get
      Offset.get = function()
        if package.loaded.edgy then
          local layout = require("edgy.config").layout
          local ret = { left = "", left_size = 0, right = "", right_size = 0 }
          for _, pos in ipairs({ "left", "right" }) do
            local sb = layout[pos]
            if sb and #sb.wins > 0 then
              local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
              ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
              ret[pos .. "_size"] = sb.bounds.width
            end
          end
          ret.total_size = ret.left_size + ret.right_size
          if ret.total_size > 0 then
            return ret
          end
        end
        return original_get()
      end
      Offset.edgy = true
    end

    return {
      ---@class bufferline.Options
      options = {
        separator_style = { "│", "│" }, -- Separadores com barra para dar um toque futurista
        offsets = { { text_align = "left", separator = false } }, -- Texto alinhado à esquerda
        indicator = { style = "none" }, -- Sem indicador ativo de buffer
        show_buffer_close_icons = false, -- Esconde o ícone de fechar nos buffers
        show_close_icon = false, -- Esconde o ícone de fechar global
        show_tab_indicators = false, -- Remove os indicadores de abas
        always_show_bufferline = false, -- Mostra a barra de buffers apenas quando necessário
        -- Definições de cores com toque cyberpunk
        highlight = {
          -- Fundo escuro e bordas de cores neon
          background = { bg = "#121212", fg = "#888888" }, -- Fundo escuro e texto sutil
          active = { bg = "#2d2d2d", fg = "#50fa7b" }, -- Verde neon ativo para buffers selecionados
          inactive = { bg = "#1c1c1c", fg = "#ff79c6" }, -- Rosa neon para buffers inativos
          fill = { bg = "#1c1c1c" }, -- Preenchimento escuro para a área da barra
          separator = { fg = "#ff5555" }, -- Separadores em vermelho neon
          buffer_visible = { bg = "#2d2d2d", fg = "#bd93f9" }, -- Roxo neon para buffers visíveis
        },
        -- Definindo os ícones para dar mais foco no estilo cyberpunk
        symbols = {
          -- Usar ícones cyberpunk mais futuristas
          modified = "", -- Ícone de arquivo modificado
          ellipsis = "…", -- Três pontos para indicar continuação
          close = "✖", -- Ícone de fechar futurista
        },
      },
    }
  end,
}
