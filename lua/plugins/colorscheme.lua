-- Função para aplicar o tema e as cores personalizadas
function ColorMyPencils(color)
  color = color or "sonokai"  -- Tema padrão
  vim.cmd.colorscheme(color)

  -- Remover o fundo das janelas para estilo neon
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

  -- Ajuste de negrito para maior contraste no estilo neon
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "#282c34", fg = "#abb2bf" })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3e4451" })
  vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#3e4451" })

  -- Definir o tema para interfaces de Neovim como o NeoTree
  vim.api.nvim_set_hl(0, "NeoTreeNormal", { fg = "#ffffff", bg = "#21252b" })
  vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#98c379" })
  vim.api.nvim_set_hl(0, "NeoTreeFileIcon", { fg = "#e06c75" })
end

-- Configuração do Tema Sonokai
return {
  -- Tema Sonokai
  {
    "sainnhe/sonokai",
    priority = 1000,
    config = function()
      vim.g.sonokai_transparent_background = "1"
      vim.g.sonokai_enable_italic = "1"
      vim.g.sonokai_style = "andromeda"
      -- Aplica o tema Sonokai
      vim.cmd.colorscheme("sonokai")

      -- Chama a função para aplicar as cores personalizadas
      ColorMyPencils("sonokai")
    end,
  },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",  -- Night style
        transparent = true,  -- Transparent background
        terminal_colors = true,  -- Enable terminal colors
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = "transparent",  -- Transparent sidebars
          floats = "transparent",  -- Transparent floating windows
        },
      })
    end,
  },

  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        transparent = false,  -- Disable transparency for better visibility
        terminal_colors = true,  -- Enable terminal colors
        styles = {
          comments = "italic",  -- Comments in italics
          keywords = "bold",  -- Keywords in bold
          types = "italic,bold",  -- Types in both italic and bold
        },
      },
      palettes = {
        carbonfox = {
          bg1 = "#0d0d0d",
          fg1 = "#f8f8f2",
          blue = "#8be9fd",
          green = "#50fa7b",
          red = "#ff5555",
          yellow = "#f1fa8c",
          magenta = "#ff79c6",
          cyan = "#8be9fd",
        },
      },
      groups = {
        carbonfox = {
          CursorLine = { bg = "#1a1a1a" },
          Normal = { bg = "#0d0d0d", fg = "#f8f8f2" },
          Comment = { fg = "#6272a4", style = "italic" },
          Function = { fg = "#8be9fd", style = "italic,bold" },
        },
      },
    },
    config = function()
      -- vim.cmd.colorscheme("carbonfox")
    end,
  },
}

