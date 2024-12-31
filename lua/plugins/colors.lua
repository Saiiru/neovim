-- Função para aplicar o esquema de cores com total personalização
local function ColorMyPencils(colorScheme)
  colorScheme = colorScheme or "carbonfox" -- Define o esquema de cores padrão
  -- Aplica o esquema de cores
  pcall(vim.cmd.colorscheme, colorScheme)

  -- Configurações personalizadas de destaque
  local set_hl = vim.api.nvim_set_hl
  local custom_groups = {
    Normal = { bg = "#0d0d0d", fg = "#f8f8f2" }, -- Fundo preto profundo e texto branco
    NormalNC = { bg = "#0d0d0d" },
    NormalFloat = { bg = "#0d0d0d" },
    EndOfBuffer = { bg = "#0d0d0d", fg = "#0d0d0d" },
    SignColumn = { bg = "#0d0d0d" },
    StatusLine = { bg = "#0d0d0d", fg = "#00FFFF" }, -- Ciano neon para a barra de status
    StatusLineNC = { bg = "#0d0d0d", fg = "#666666" }, -- Status para janelas inativas
    CursorLine = { bg = "#1a1a1a" }, -- Linha de cursor em cinza sutil
    CursorLineNr = { fg = "#FF79C6", bg = "#1a1a1a", bold = true }, -- Números de linha em rosa neon
    LineNr = { fg = "#666666" }, -- Números de linha apagados
    VertSplit = { fg = "#44475a" }, -- Cor de borda de divisão sutil
    FloatBorder = { bg = "#0d0d0d", fg = "#8be9fd" }, -- Borda vibrante para janelas flutuantes
    Pmenu = { bg = "#0d0d0d", fg = "#f8f8f2" }, -- Menu de popup
    PmenuSel = { bg = "#44475a", fg = "#50fa7b" }, -- Seleção em menu de popup
    Comment = { fg = "#6272a4", italic = true }, -- Comentários em azul neon e itálico
    Keyword = { fg = "#FF79C6", bold = true }, -- Palavras-chave em rosa neon e negrito
    Function = { fg = "#8be9fd", italic = true, bold = true }, -- Funções em ciano neon
    String = { fg = "#50fa7b" }, -- Strings em verde vibrante
    Terminal = { bg = "#0d0d0d", fg = "#f8f8f2" }, -- Cor do terminal
    Error = { fg = "#FF5555", bold = true }, -- Erros em vermelho
    WarningMsg = { fg = "#f1fa8c", bold = true }, -- Avisos em amarelo
  }
  -- Aplica os grupos personalizados
  for group, settings in pairs(custom_groups) do
    set_hl(0, group, settings)
  end
end

-- Configuração do tema
return {
  {
    "EdenEast/nightfox.nvim", -- Plugin para gerenciamento de esquemas de cores
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        transparent = false, -- Desativa a transparência
        terminal_colors = true, -- Permite que as cores do terminal sejam usadas
        styles = {
          comments = "italic", -- Comentários em itálico
          keywords = "bold", -- Palavras-chave em negrito
          types = "italic,bold", -- Tipos em itálico e negrito
        },
      },
      palettes = {
        carbonfox = {
          bg1 = "#0d0d0d", -- Cor de fundo profunda
          fg1 = "#f8f8f2", -- Cor de texto clara
          blue = "#8be9fd", -- Ciano neon
          green = "#50fa7b", -- Verde vibrante
          red = "#ff5555", -- Vermelho intenso
          yellow = "#f1fa8c", -- Amarelo brilhante
          magenta = "#ff79c6", -- Magenta brilhante
          cyan = "#8be9fd", -- Ciano neon
        },
      },
      groups = {
        carbonfox = {
          CursorLine = { bg = "#1a1a1a" }, -- Linha de cursor em cinza sutil
          Normal = { bg = "#0d0d0d", fg = "#f8f8f2" }, -- Normal com fundo preto
          Comment = { fg = "#6272a4", style = "italic" }, -- Comentários em azul neon e itálico
          Function = { fg = "#8be9fd", style = "italic,bold" }, -- Funções em ciano neon
        },
      },
    },
    config = function()
      ColorMyPencils("carbonfox") -- Aplica o esquema de cores customizado
    end,
  },
}
