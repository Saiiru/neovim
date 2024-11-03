local function applyColorScheme(colorScheme)
  colorScheme = colorScheme or "carbonfox"
  vim.cmd.colorscheme(colorScheme)

  -- Transparency for background
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

  -- Custom colors for NeoTree
  vim.cmd("highlight NeoTreeFolderIcon guifg=#FF8F1F") -- Bright orange
  vim.cmd("highlight NeoTreeFolderName guifg=#50fa7b") -- Neon green
  vim.cmd("highlight NeoTreeFileIcon guifg=#8be9fd") -- Neon blue
  vim.cmd("highlight NeoTreeFileName guifg=#FF61FF") -- Shocking pink
end

local function adjust_color(color, fallback)
  return type(color) == "string" and color or fallback
end

local function overrides(c, color)
  local darken = color.darken
  return {
    TelescopeResultsBorder = { fg = c.bg, bg = c.bg },
    TelescopeResultsNormal = { bg = darken(c.bg, 20) },
    TelescopePromptBorder = { fg = darken(c.pink, 5), bg = c.bg },
    TelescopeTitle = { fg = c.yellow, bg = darken(c.yellow, 10) },
    TelescopePromptPrefix = { fg = c.cyan },
  }
end

return {
  -- Brightburn theme configuration
  {
    "erikbackman/brightburn.vim",
    lazy = true, -- Loads on demand
  },

  -- TokyoNight theme configuration
  {
    "folke/tokyonight.nvim",
    lazy = false, -- Loads immediately
    opts = {
      style = "night", -- Valid styles: 'storm', 'night', 'day'
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
    end,
  },

  -- TokyoDark theme configuration
  {
    "tiagovla/tokyodark.nvim",
    lazy = false, -- Loads immediately
    opts = {
      transparent_background = true,
      gamma = 1.0, -- Adjusted saturation
      styles = {
        comments = { italic = true },
        keywords = { italic = true, bold = true },
        identifiers = { italic = true },
        functions = { bold = true },
        variables = {},
      },
      terminal_colors = true,
      custom_highlights = function(highlights, palette)
        highlights.Normal = { bg = "none", fg = adjust_color(palette.fg, "#D800FF") }
        highlights.Comment = { fg = adjust_color(palette.magenta, "#FF61FF"), italic = true }
        highlights.Keyword = { fg = adjust_color(palette.red, "#FF007F"), bold = true, italic = true }
        highlights.Function = { fg = adjust_color(palette.cyan, "#00F9FF"), bold = true }
        highlights.String = { fg = adjust_color(palette.green, "#50fa7b") }
        highlights.Error = { fg = adjust_color(palette.red, "#FF073A"), bold = true }
        highlights.Number = { fg = adjust_color(palette.yellow, "#FFFA65"), bold = true }
        highlights.Boolean = { fg = adjust_color(palette.orange, "#FF8F1F"), bold = true }
        return highlights
      end,
    },
    config = function(_, opts)
      require("tokyodark").setup(opts)
      -- Apply the tokyodark theme with adjusted settings
      applyColorScheme("tokyodark")
    end,
  },

  -- Nightfox theme with Carbonfox customization
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
          terminal_colors = true,
          styles = {
            comments = "italic",
            keywords = "bold,italic",
            functions = "bold",
            variables = "NONE",
          },
        },
        palettes = {
          carbonfox = {
            bg = "#0D0221",
            fg = "#00F9FF",
            cyan = "#00F9FF",
            red = "#FF073A",
            yellow = "#FFFA65",
            orange = "#FF8F1F",
            pink = "#FF61FF",
            green = "#50fa7b",
            purple = "#D800FF",
          },
        },
        groups = {
          carbonfox = {
            Normal = { bg = "none", fg = "#00F9FF" },
            Comment = { fg = "#FF61FF", italic = true },
            Keyword = { fg = "#FF007F", bold = true, italic = true },
            Function = { fg = "#00F9FF", bold = true },
            String = { fg = "#50fa7b" },
            Error = { fg = "#FF073A", bold = true },
            Number = { fg = "#FFFA65", bold = true },
            Boolean = { fg = "#FFFA65", bold = true },
            NeoTreeFolderIcon = { fg = "#FF8F1F" },
            NeoTreeFolderName = { fg = "#50fa7b" },
            NeoTreeFileIcon = { fg = "#8be9fd" },
            NeoTreeFileName = { fg = "#FF61FF" },
            TelescopeResultsBorder = { fg = "#0D0221", bg = "#0D0221" },
            TelescopeTitle = { fg = "#FFFA65", bg = "#0D0221" },
            TelescopePromptPrefix = { fg = "#00F9FF" },
          },
        },
        overrides = overrides,
      })

      -- Apply the carbonfox theme
      applyColorScheme("carbonfox")
    end,
  },

  -- Gruvbox theme configuration
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = true, -- Loads on demand
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
      -- Uncomment to switch to Gruvbox if preferred
      -- applyColorScheme("gruvbox")
    end,
  },
}
