-- ~/.config/nvim/lua/plugins/lualine.lua

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "nvim-nonicons" }, -- Dependências
  config = function()
    local lualine = require("lualine")
    local nonicons = require('nvim-nonicons')
    local lazy_status = require("lazy.status") -- Para contar atualizações pendentes

    -- Definição de ícones
    local icons = {
      mode = {
        normal = nonicons.get("vim-normal-mode"),
        insert = nonicons.get("vim-insert-mode"),
        visual = nonicons.get("vim-visual-mode"),
        replace = nonicons.get("vim-replace-mode"),
        command = nonicons.get("vim-command-mode"),
      },
      git = nonicons.get("git-branch"),
      diagnostic = {
        error = nonicons.get("x-circle-fill"),
        warn = nonicons.get("alert"),
        info = nonicons.get("info"),
      },
      diff = {
        added = nonicons.get("diff-added"),
        modified = nonicons.get("diff-modified"),
        removed = nonicons.get("diff-removed"),
      },
      file = {
        modified = nonicons.get("pencil"),
      },
    }

    -- Tabela de cores para destaques
    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      bg = "#112638",
      inactive_bg = "#2c3043",
    }

    -- Configuração do Lualine
    lualine.setup {
      options = {
        icons_enabled = true,
        theme = {
          normal = {
            a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          insert = {
            a = { bg = colors.green, fg = colors.bg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          visual = {
            a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          command = {
            a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          replace = {
            a = { bg = colors.red, fg = colors.bg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
          },
          inactive = {
            a = { bg = colors.inactive_bg, fg = colors.fg, gui = "bold" },
            b = { bg = colors.inactive_bg, fg = colors.fg },
            c = { bg = colors.inactive_bg, fg = colors.fg },
          },
        },
        component_separators = { '│', '│' }, -- Separadores de componentes
        section_separators = { '', '' }, -- Separadores de seções
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          {
            'mode',
            icons_enabled = true,
            fmt = function(str)
              local mode_icon = icons.mode[string.lower(str)] or ''
              return mode_icon .. ' ' .. str
            end,
            color = { fg = colors.fg, bg = colors.bg },
          },
        },
        lualine_b = {
          { 'branch', icon = icons.git, color = { fg = colors.blue } },
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
            color = { fg = colors.violet, gui = 'bold' },
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
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
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
  end,
}

