-- Statusline.
-- Editor state only. Session state belongs to tmux.

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local c = {
        bg = "#0d0f18",
        fg = "#c8d3f5",
        muted = "#828bb8",
        red = "#ff757f",
        green = "#c3e88d",
        yellow = "#ffc777",
        blue = "#82aaff",
        magenta = "#c099ff",
        cyan = "#86e1fc",
      }

      local theme = {
        normal = {
          a = { fg = c.blue, bg = c.bg, gui = "bold" },
          b = { fg = c.fg, bg = c.bg },
          c = { fg = c.fg, bg = c.bg },
        },
        insert = {
          a = { fg = c.green, bg = c.bg, gui = "bold" },
          b = { fg = c.fg, bg = c.bg },
          c = { fg = c.fg, bg = c.bg },
        },
        visual = {
          a = { fg = c.magenta, bg = c.bg, gui = "bold" },
          b = { fg = c.fg, bg = c.bg },
          c = { fg = c.fg, bg = c.bg },
        },
        replace = {
          a = { fg = c.red, bg = c.bg, gui = "bold" },
          b = { fg = c.fg, bg = c.bg },
          c = { fg = c.fg, bg = c.bg },
        },
        command = {
          a = { fg = c.yellow, bg = c.bg, gui = "bold" },
          b = { fg = c.fg, bg = c.bg },
          c = { fg = c.fg, bg = c.bg },
        },
        inactive = {
          a = { fg = c.muted, bg = c.bg },
          b = { fg = c.muted, bg = c.bg },
          c = { fg = c.muted, bg = c.bg },
        },
      }

      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        icons_enabled = false,
        theme = theme,
        globalstatus = true,
        always_divide_middle = false,
        component_separators = "",
        section_separators = "",
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
            color = { fg = c.yellow, bg = c.bg, gui = "bold" },
          },
        },
        lualine_b = {},
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
        },
        lualine_y = {
          { "branch", color = { fg = c.magenta, bg = c.bg, gui = "bold" } },
          { "diff", symbols = { added = "+", modified = "~", removed = "-" } },
        },
        lualine_z = {
          { "progress" },
          { "location", color = { fg = c.blue, bg = c.bg, gui = "bold" } },
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
