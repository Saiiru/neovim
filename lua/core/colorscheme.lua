-- Função para aplicar o esquema de cores com transparência total
local function ColorMyPencils(colorScheme)
  colorScheme = colorScheme or "carbonfox"
  vim.cmd.colorscheme(colorScheme)

  -- Definindo a transparência para o fundo
  local set_hl = vim.api.nvim_set_hl
  local transparent_groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "EndOfBuffer",
    "SignColumn",
    "StatusLine",
    "StatusLineNC",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeCursorLine",
    "NeoTreeEndOfBuffer",
  }
  for _, group in ipairs(transparent_groups) do
    set_hl(0, group, { bg = "none" })
  end

  -- Definições de destaque adicionais
  vim.cmd([[
  highlight CmpTransparent guibg=NONE ctermbg=NONE
  highlight CmpBorderVibrant guifg=#00FFFF gui=bold
  ]])
end

-- Função auxiliar para ajuste de cor
local function adjust_color(color, fallback)
  return type(color) == "string" and color or fallback
end

-- Configuração dos temas com transparência e estilo "Dark Knight"
return {
  -- Kanagawa Theme Config
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      dimInactive = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none", -- sem fundo na margem
            },
          },
        },
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        }
      end,
    },
  },

  -- Carbonfox Theme Config
  {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        transparent = true, -- sempre transparente
        terminal_colors = true,
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
      },
      palettes = {
        carbonfox = {
          bg1 = "#0d0d0d", -- fundo principal, preto
          fg1 = "#e5e5e5", -- texto quase branco
          blue = "#0abdc6", -- azul neon
          green = "#51fa7b", -- verde neon
          red = "#ff5555", -- vermelho intenso
          yellow = "#f57800", -- amarelo suave
          magenta = "#ff79c6", -- rosa neon
          cyan = "#8be9fd", -- ciano
        },
      },
      groups = {
        carbonfox = {
          CursorLine = { bg = "#282a36" },
          Normal = { bg = "none", fg = "#e5e5e5" },
          Comment = { fg = "#b8b8b8", style = "italic" },
          Function = { fg = "#0abdc6", style = "italic,bold" },
          NeoTreeNormal = { bg = "none" },
        },
      },
    },
    config = function()
      ColorMyPencils("carbonfox")
    end,
  },

  -- Outros Temas com Transparência Ativada
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "moon",
      disable_background = true,
      disable_float_background = true,
      styles = {
        bold = true,
        italic = true,
      },
    },
    lazy = true,
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      transparent_background = true,
      integrations = {
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        neotest = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
        fzf = true,
      },
    },
  },
  {
    "Mofiqul/dracula.nvim",
    lazy = true,
    opts = {
      transparent_bg = true,
      show_end_of_buffer = true,
      italic_comment = true,
    },
    config = function(_, opts)
      local dracula = require("dracula")
      dracula.setup(opts)
      vim.o.spell = false
    end,
  },
  {
    "lalitmee/cobalt2.nvim",
    lazy = true,
    dependencies = { "tjdevries/colorbuddy.nvim", tag = "v1.0.0" },
    init = function()
      require("colorbuddy").colorscheme("cobalt2")
      vim.o.spell = false
    end,
  },
  {
    "oxfist/night-owl.nvim",
    lazy = true,
    opts = {
      bold = true,
      italics = true,
      underline = true,
      undercurl = true,
      transparent_background = true,
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "moon",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
