-- Kanagawa colors
-- These are used by other plugins, duplicated from Kanagawa repository
local color = {
  sumiInk1         = "#1F1F28",
  sumiInk3         = "#363646",
  sumiInk4         = "#54546D",
  waveBlue1        = "#223249",
  waveBlue2        = "#2D4F67",
  winterGreen      = "#2B3328",
  winterYellow     = "#49443C",
  winterRed        = "#43242B",
  winterBlue       = "#252535",
  autumnGreen      = "#76946A",
  autumnRed        = "#C34043",
  autumnYellow     = "#DCA561",
  samuraiRed       = "#E82424",
  roninYellow      = "#FF9E3B",
  waveAqua1        = "#6A9589",
  dragonBlue       = "#658594",
  fujiGray         = "#727169",
  springViolet1    = "#938AA9",
  oniViolet        = "#957FB8",
  crystalBlue      = "#7E9CD8",
  springViolet2    = "#9CABCA",
  springBlue       = "#7FB4CA",
  lightBlue        = "#A3D4D5",
  waveAqua2        = "#7AA89F",
  springGreen      = "#98BB6C",
  boatYellow1      = "#938056",
  boatYellow2      = "#C0A36E",
  carpYellow       = "#E6C384",
  sakuraPink       = "#D27E99",
  waveRed          = "#E46876",
  peachRed         = "#FF5D62",
  surimiOrange     = "#FFA066",
  katanaGray       = "#717C7C",
  backgroundMedium = "#2a2a37",
  -- Used for the terminal
  backgroundDark   = "#15151c"
}

local function ColorMyPencils(color)
  color = color or "tokyodark"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
  -- Brightburn theme
  {
    "erikbackman/brightburn.vim",
    lazy = true, -- Carrega sob demanda
  },
  
  -- TokyoNight theme
  {
    "folke/tokyonight.nvim",
    lazy = false, -- Carregado imediatamente
    opts = {
      style = "night",
      transparent = vim.g.neovide and true or false,
      terminal_colors = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = true },
        functions = "NONE",
        variables = "NONE",
      },
      sidebars = { "qf", "help" },
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#FFA630", bg = "None" })
      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "None", fg = "None" })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "None", fg = "None" })
      vim.api.nvim_set_hl(0, "MsgArea", { fg = require("tokyonight.colors").setup().fg_dark })
    end
  },

  -- TokyoDark theme
  {
    "tiagovla/tokyodark.nvim",
    lazy = false, -- Carregado imediatamente
    opts = {
      transparent_background = true, -- Fundo transparente
      gamma = 1.0, -- Aumenta a saturação para cores mais vibrantes
      styles = {
        comments = { italic = true },
        keywords = { italic = true, bold = true },
        identifiers = { italic = true },
        functions = { bold = true },
        variables = {},
      },
      terminal_colors = true,
      custom_highlights = function(highlights, palette)
        highlights.Normal = { bg = "none", fg = palette.fg } -- Fundo transparente
        highlights.Comment = { fg = "#ff79c6", italic = true } -- Comentários em rosa neon
        highlights.Keyword = { fg = "#ff007f", bold = true, italic = true } -- Palavras-chave em hotpink
        highlights.Function = { fg = "#8be9fd", bold = true } -- Funções em azul neon
        highlights.String = { fg = "#50fa7b" } -- Strings em verde neon
        highlights.Error = { fg = "#ff5555", bold = true } -- Erros em vermelho forte
        highlights.Number = { fg = "#ffb86c", bold = true } -- Números em laranja vibrante
        highlights.Boolean = { fg = "#bd93f9", bold = true } -- Booleanos em roxo vibrante
        return highlights
      end,
    },
    config = function(_, opts)
      require("tokyodark").setup(opts)
      ColorMyPencils("tokyodark") -- Aplica o tema customizado
    end,
  },

  -- Gruvbox theme
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = true, -- Carrega sob demanda
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = false,
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
      transparent_mode = false,
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      -- ColorMyPencils("gruvbox") -- Troca para Gruvbox se preferido
    end,
  },
}

