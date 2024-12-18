-- Function to apply the color scheme with full transparency
local function ColorMyPencils(colorScheme)
  colorScheme = colorScheme or "carbonfox"
  -- Apply the color scheme
  pcall(vim.cmd.colorscheme, colorScheme)

  -- Setting transparency for the background
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

  -- Additional highlight definitions
  vim.cmd [[
  highlight CmpTransparent guibg=NONE ctermbg=NONE
  highlight CmpBorderVibrant guifg=#00FFFF gui=bold
  ]]
end

-- Helper function to adjust colors
local function adjust_color(color, fallback)
  return type(color) == "string" and color or fallback
end

-- Configuration for themes with transparency and "Dark Knight" style
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
              bg_gutter = "none", -- no background in the gutter
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
        transparent = true, -- always transparent
        terminal_colors = true,
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
      },
      palettes = {
        carbonfox = {
          bg1 = "#1a1a1a", -- Darker background
          fg1 = "#f8f8f2", -- Brighter text
          blue = "#8be9fd", -- Vibrant cyan
          green = "#50fa7b", -- Vibrant green
          red = "#ff5555", -- Intense red
          yellow = "#f1fa8c", -- Bright yellow
          magenta = "#ff79c6", -- Bright magenta
          cyan = "#8be9fd", -- Bright cyan
        },
      },
      groups = {
        carbonfox = {
          CursorLine = { bg = "#282a36" },
          Normal = { bg = "none", fg = "#f8f8f2" },
          Comment = { fg = "#b8b8b8", style = "italic" },
          Function = { fg = "#8be9fd", style = "italic,bold" },
          NeoTreeNormal = { bg = "none" },
        },
      },
    },
    config = function()
      ColorMyPencils "carbonfox"
    end,
  },

  -- Other Themes with Transparency Enabled
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
      local dracula = require "dracula"
      dracula.setup(opts)
      vim.o.spell = false
    end,
  },
  {
    "lalitmee/cobalt2.nvim",
    lazy = true,
    dependencies = { "tjdevries/colorbuddy.nvim", tag = "v1.0.0" },
    init = function()
      require("colorbuddy").colorscheme "cobalt2"
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
