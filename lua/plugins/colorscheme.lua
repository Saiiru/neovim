-- Função para aplicar o esquema de cores com transparência
local function ColorMyPencils(colorScheme)
  colorScheme = colorScheme or "carbonfox"
  vim.cmd.colorscheme(colorScheme)

  -- Definindo a transparência para o fundo
  local set_hl = vim.api.nvim_set_hl
  set_hl(0, "Normal", { bg = "none" })
  set_hl(0, "NormalFloat", { bg = "none" })
end

local function adjust_color(color, fallback)
  return type(color) == "string" and color or fallback
end

return {
  -- Configuração do tema Brightburn
  {
    "erikbackman/brightburn.vim",
    lazy = true,
  },

  -- Configuração do tema TokyoNight
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = "dark",
          floats = "dark",
        },
      })
    end,
  },

  -- Configuração do tema TokyoDark
  {
    "tiagovla/tokyodark.nvim",
    lazy = false,
    opts = {
      transparent_background = true,
      gamma = 2.0,
      styles = {
        comments = { italic = true },
        keywords = { italic = true, bold = true },
        identifiers = { italic = true },
        functions = { bold = true },
        variables = {},
      },
      terminal_colors = true,
      custom_highlights = function(highlights, palette)
        highlights.Normal = { bg = "none", fg = adjust_color(palette.fg, "#D801FF") }
        highlights.Comment = { fg = adjust_color(palette.magenta, "#FF62FF"), italic = true }
        highlights.Keyword = { fg = adjust_color(palette.red, "#FF008F"), bold = true, italic = true }
        highlights.Function = { fg = adjust_color(palette.cyan, "#01F9FF"), bold = true }
        highlights.String = { fg = adjust_color(palette.green, "#51fa7b") }
        highlights.Error = { fg = adjust_color(palette.red, "#FF074A"), bold = true }
        highlights.Number = { fg = adjust_color(palette.yellow, "#FFFA66"), bold = true }
        highlights.Boolean = { fg = adjust_color(palette.orange, "#FF9F1F"), bold = true }
        return highlights
      end,
    },
    config = function(_, opts)
      require("tokyodark").setup(opts)
      -- ColorMyPencils("tokyodark") -- Descomente para usar TokyoDark
    end,
  },

  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup({
        options = {
          transparent = false, -- sem transparência
          terminal_colors = true, -- cores de terminal habilitadas
          styles = {
            comments = "italic", -- comentários em itálico
            keywords = "bold", -- palavras-chave em negrito para destaque
            functions = "italic,bold", -- funções em itálico e negrito
          },
          inverse = {
            match_paren = true, -- realce de parênteses correspondentes
            visual = true, -- realce de seleção visual
          },
        },
        palettes = {
          carbonfox = { -- Ajustes específicos de cores do Carbonfox
            bg1 = "#0d0d0d", -- fundo principal, quase preto
            fg1 = "#e5e5e5", -- texto primário, quase branco
            blue = "#0abdc6", -- azul vibrante
            green = "#51fa7b", -- verde vibrante
            red = "#ff5555", -- vermelho intenso para erros
            yellow = "#f57800", -- amarelo suave para alertas
            magenta = "#ff79c6", -- rosa para detalhes
            cyan = "#8be9fd", -- ciano para acentos
          },
        },
        groups = {
          carbonfox = {
            CursorLine = { bg = "#282a36" }, -- Linha do cursor mais escura para foco
            Normal = { bg = "#0d0d0d", fg = "#e5e5e5" }, -- fundo e texto principais
            Comment = { fg = "#b8b8b8", style = "italic" }, -- Comentários mais claros para contraste
            Function = { fg = "#0abdc6", style = "italic,bold" }, -- Funções em destaque
          },
        },
      })

      -- Aplicando o esquema Carbonfox
      ColorMyPencils("carbonfox")
    end,
  },
  -- Configuração do tema Gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = true,
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      },
      strikethrough = true,
      inverse = true,
      transparent_mode = true, -- Gruvbox com transparência
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      -- ColorMyPencils("gruvbox") -- Descomente para usar Gruvbox
    end,
  },
}
