-- Statusline.
-- Editor state only. Session state belongs to tmux.

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local formatting = require("config.formatting")
      local c = {
        bg = "#0a0e14",
        panel = "#131a24",
        surface = "#1b2433",
        edge = "#2d3f76",
        fg = "#d7e2f0",
        muted = "#7f8cab",
        red = "#ff5d73",
        green = "#7ee787",
        yellow = "#ffd76e",
        blue = "#82aaff",
        magenta = "#c792ea",
        cyan = "#86e1fc",
      }

      local function autoformat_color()
        return formatting.enabled() and { fg = c.green, bg = c.surface, gui = "bold" }
          or { fg = c.red, bg = c.surface, gui = "bold" }
      end

      local theme = {
        normal = {
          a = { fg = c.bg, bg = c.blue, gui = "bold" },
          b = { fg = c.fg, bg = c.panel },
          c = { fg = c.fg, bg = c.surface },
          x = { fg = c.fg, bg = c.panel },
          y = { fg = c.fg, bg = c.surface },
          z = { fg = c.bg, bg = c.cyan, gui = "bold" },
        },
        insert = {
          a = { fg = c.bg, bg = c.green, gui = "bold" },
          b = { fg = c.fg, bg = c.panel },
          c = { fg = c.fg, bg = c.surface },
          x = { fg = c.fg, bg = c.panel },
          y = { fg = c.fg, bg = c.surface },
          z = { fg = c.bg, bg = c.cyan, gui = "bold" },
        },
        visual = {
          a = { fg = c.bg, bg = c.magenta, gui = "bold" },
          b = { fg = c.fg, bg = c.panel },
          c = { fg = c.fg, bg = c.surface },
          x = { fg = c.fg, bg = c.panel },
          y = { fg = c.fg, bg = c.surface },
          z = { fg = c.bg, bg = c.cyan, gui = "bold" },
        },
        replace = {
          a = { fg = c.bg, bg = c.red, gui = "bold" },
          b = { fg = c.fg, bg = c.panel },
          c = { fg = c.fg, bg = c.surface },
          x = { fg = c.fg, bg = c.panel },
          y = { fg = c.fg, bg = c.surface },
          z = { fg = c.bg, bg = c.cyan, gui = "bold" },
        },
        command = {
          a = { fg = c.bg, bg = c.yellow, gui = "bold" },
          b = { fg = c.fg, bg = c.panel },
          c = { fg = c.fg, bg = c.surface },
          x = { fg = c.fg, bg = c.panel },
          y = { fg = c.fg, bg = c.surface },
          z = { fg = c.bg, bg = c.cyan, gui = "bold" },
        },
        inactive = {
          a = { fg = c.muted, bg = c.bg },
          b = { fg = c.muted, bg = c.bg },
          c = { fg = c.muted, bg = c.bg },
          x = { fg = c.muted, bg = c.bg },
          y = { fg = c.muted, bg = c.bg },
          z = { fg = c.muted, bg = c.bg },
        },
      }

      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        icons_enabled = false,
        theme = theme,
        globalstatus = true,
        always_divide_middle = false,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter", "lazy", "mason" },
          winbar = {},
        },
        refresh = {
          statusline = 500,
          tabline = 1000,
          winbar = 1000,
        },
      })

      opts.sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(mode)
              return mode:sub(1, 1)
            end,
            color = { fg = c.bg, bg = c.blue, gui = "bold" },
          },
        },
        lualine_b = {
          {
            "branch",
            icon = nil,
            color = { fg = c.fg, bg = c.panel, gui = "bold" },
          },
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = {
              modified = " *",
              readonly = " [ro]",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
          },
          {
            function()
              return formatting.status()
            end,
            color = autoformat_color,
          },
        },
        lualine_y = {
          { "diff", symbols = { added = "+", modified = "~", removed = "-" } },
        },
        lualine_z = {
          { "progress" },
          { "location", color = { fg = c.bg, bg = c.cyan, gui = "bold" } },
        },
      }

      opts.inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { "filename", path = 1, color = { fg = c.muted, bg = c.bg } },
        },
        lualine_x = {
          { "location", color = { fg = c.muted, bg = c.bg } },
        },
        lualine_y = {},
        lualine_z = {},
      }

      opts.extensions = vim.list_extend(opts.extensions or {}, {
        "lazy",
        "mason",
        "quickfix",
        "man",
        "oil",
      })
    end,
  },
}
