return {
  'nvim-lualine/lualine.nvim',
  requires = {
    'nvim-tree/nvim-web-devicons', -- Mantenha isso caso ainda não tenha.
    'yamatsum/nvim-nonicons',
    'nvim-lua/plenary.nvim',       -- Dependência necessária para alguns plugins.
  },
  config = function()
    local lualine = require('lualine')
    local nonicons = require('nvim-nonicons')

    -- Defina ícones
    local icons = {
      sep = {
        right = "",
        left = ""
      },
      diagnostic = {
        error = nonicons.get("x-circle-fill"),
        warn = nonicons.get("alert"),
        info = nonicons.get("info")
      },
      diff = {
        added = nonicons.get("diff-added"),
        modified = nonicons.get("diff-modified"),
        removed = nonicons.get("diff-removed"),
      },
      git = nonicons.get("git-branch"),
      file = {
        modified = nonicons.get("pencil"),
      },
      mode = {
        normal = nonicons.get("vim-normal-mode"),
        insert = nonicons.get("vim-insert-mode"),
        visual = nonicons.get("vim-visual-mode"),
        replace = nonicons.get("vim-replace-mode"),
        command = nonicons.get("vim-command-mode"),
        terminal = nonicons.get("terminal"),
      }
    }

    -- Defina a tabela de cores
    local colors = {
      bg = "#282c34",
      fg = "#d8dee9",
      red = "#df8890",
      green = "#7ed491",
      yellow = "#cccc00",
      blue = "#61afef",
      magenta = "#c678dd",
      cyan = "#00FFFF",
      white = "#d8dee9",
      grey = "#3c4048",
    }

    -- Configuração do Lualine
    lualine.setup {
      options = {
        icons_enabled = true,
        theme = 'tokyodark', -- Você pode trocar por um tema de sua escolha
        component_separators = { '▌', '▌' },
        section_separators = { '', '' },
      },
      sections = {
        lualine_a = {
          {
            'mode',
            icons_enabled = true,
            fmt = function(str)
              local mode_icon = icons.mode[string.lower(str)] or '' -- Pega o ícone correspondente ao modo
              return mode_icon .. ' ' .. str                        -- Retorna ícone e nome do modo
            end,
            color = { fg = colors.fg, bg = colors.bg },
          },
        },
        lualine_b = {
          { 'branch', icon = icons.git, color = { fg = colors.blue, gui = 'bold' } },
          {
            'diff',
            source = { 'added', 'modified', 'removed' },
            icons = {
              added = icons.diff.added,
              modified = icons.diff.modified,
              removed = icons.diff.removed,
            },
            color_added = colors.green,
            color_modified = colors.yellow,
            color_removed = colors.red,
          },
        },
        lualine_c = {
          {
            'filename',
            file_status = true,
            path = 1,
            icon = icons.file.modified,
            color = { fg = colors.magenta, gui = 'bold' },
          },
          {
            'diagnostics',
            sources = { 'nvim_lsp' },
            symbols = {
              error = icons.diagnostic.error,
              warn = icons.diagnostic.warn,
              info = icons.diagnostic.info,
            },
            color_error = colors.red,
            color_warn = colors.yellow,
            color_info = colors.cyan,
          },
        },
        lualine_x = {
          -- { 'encoding',   color = { fg = colors.green } }, -- Apenas o encoding
          { 'fileformat', color = { fg = colors.green } },
          { 'filetype' },
        },
        lualine_y = {
          { 'progress', color = { fg = colors.fg } },
          { 'location', color = { fg = colors.fg } },
        },
        lualine_z = {
          { 'o:encoding', fmt = string.upper, icon = nonicons.get("text") },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = {}
    }
  end
}
