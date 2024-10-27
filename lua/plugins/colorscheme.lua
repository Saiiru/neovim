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
      -- ColorMyPencils("tokyodark") -- Aplica o tema customizado
    end,
  },
   {
        'maxmx03/fluoromachine.nvim',
        lazy = false,
        priority = 1000,
        config = function ()
            local fm = require 'fluoromachine'

            fm.setup {
                theme = 'retrowave',        -- Tema retrowave para o visual neon
                glow = true,                -- Habilita o efeito glow
                transparent = true,         -- Transparência para fundo
                brightness = 0.1,           -- Brilho adicional
                styles = {
                    comments = { italic = true },
                    keywords = { bold = true },
                    functions = { bold = true },
                },
                colors = function(_, color)
                    local darken = color.darken
                    return {
                        bg = '#0D0221',                -- Fundo preto com toque roxo
                        bgdark = darken('#0D0221', 20),-- Fundo ainda mais escuro
                        cyan = '#00F9FF',              -- Ciano neon vivo
                        red = '#FF073A',               -- Vermelho neon brilhante
                        yellow = '#FFFA65',            -- Amarelo neon que salta aos olhos
                        orange = '#FF8F1F',            -- Laranja intenso
                        pink = '#FF61FF',              -- Rosa choque mais intenso
                        purple = '#D800FF',            -- Roxo neon ainda mais forte
                    }
                end,
                overrides = function(c, color)
                    local darken = color.darken
                    return {
                        -- Estilo personalizado do Telescope para maximizar o brilho neon
                        TelescopeResultsBorder = { fg = c.bg, bg = c.bg },
                        TelescopeResultsNormal = { bg = darken(c.bg, 20) },
                        TelescopePromptBorder = { fg = darken(c.pink, 5), bg = c.bg },
                        TelescopeTitle = { fg = c.yellow, bg = darken(c.yellow, 10) },
                        TelescopePromptPrefix = { fg = c.cyan },
                    }
                end,
                plugins = {                    -- Ativação dos plugins para integrar ao tema neon
                    telescope = true,
                    treesitter = true,
                    lspconfig = true,
                    bufferline = true,
                    cmp = true,
                    lazy = true,
                    navic = true,
                    gitsign = true,
                    notify = true,
                    neogit = true,
                    noice = true,
                },
            }
           vim.cmd.colorscheme 'fluoromachine'

      ColorMyPencils("fluoromachine") -- Aplica o tema customizado
        end
    },

  -- Gruvbox theme
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = true, -- Carrega sob demanda
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
      transparent_mode = false,
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      -- ColorMyPencils("gruvbox") -- Troca para Gruvbox se preferido
    end,
  },
}

