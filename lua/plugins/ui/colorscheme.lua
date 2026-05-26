return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local p = {
        bg = "#0a0e14",
        bg_dark = "#101722",
        bg_float = "#182132",
        border = "#22304A",

        fg = "#d7e2f0",
        fg_dark = "#6f7d99",

        red = "#ff5d73",
        orange = "#ff9e64",
        yellow = "#ffd76e",
        green = "#7ee787",
        blue = "#82aaff",
        cyan = "#86e1fc",
        magenta = "#c792ea",

        github = "#d7e2f0",
      }

      vim.g.noctis_palette = p

      require("nightfox").setup({
        options = {
          transparent = true,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
          styles = {
            -- Comentários com mais contraste visual para leitura rápida
            comments = "italic",
            keywords = "bold",
            -- Funções em negrito para achar fluxo de execução mais rápido
            functions = "bold",
            types = "italic",
          },
        },
        palettes = {
          carbonfox = {
            bg0 = p.bg,
            bg1 = p.bg_dark,
            bg2 = p.bg_float,
            bg3 = p.border,
            sel0 = p.bg_dark,
            sel1 = p.bg_float,
            comment = p.fg_dark,
            black = p.bg,
            red = p.red,
            green = p.green,
            yellow = p.yellow,
            blue = p.blue,
            magenta = p.magenta,
            cyan = p.cyan,
            white = p.fg,
            orange = p.orange,
            pink = p.magenta,
          },
        },
        groups = {
          carbonfox = {
            NormalFloat = { bg = p.bg_dark },
            FloatBorder = { fg = p.border, bg = p.bg_dark },
            Pmenu = { bg = p.bg_dark },
            PmenuSel = { bg = p.cyan, fg = p.bg, style = "bold" },
            CursorLineNr = { fg = p.cyan, style = "bold" },
            Visual = { bg = p.bg_float },
            WinSeparator = { fg = p.border },
            StatusLine = { bg = p.bg, fg = p.fg },
            StatusLineNC = { bg = p.bg, fg = p.fg_dark },

            WhichKeyNormal = { bg = p.bg_dark, fg = p.fg },
            WhichKeyBorder = { bg = p.bg_dark, fg = p.border },
            WhichKey = { bg = p.bg_dark, fg = p.blue, style = "bold" },
            WhichKeyGroup = { bg = p.bg_dark, fg = p.blue, style = "bold" },
            WhichKeyDesc = { bg = p.bg_dark, fg = p.fg },
            WhichKeySeparator = { bg = p.bg_dark, fg = p.border },
            WhichKeyValue = { bg = p.bg_dark, fg = p.fg_dark },

            FzfLuaNormal = { bg = p.bg, fg = p.fg },
            FzfLuaBorder = { bg = p.bg, fg = p.border },
            FzfLuaTitle = { bg = p.bg, fg = p.blue, style = "bold" },
            FzfLuaPreviewNormal = { bg = p.bg, fg = p.fg },
            FzfLuaPreviewBorder = { bg = p.bg, fg = p.border },
            FzfLuaCursor = { bg = p.bg_float, fg = p.fg },
            FzfLuaSearch = { fg = p.yellow, style = "bold" },

            NoiceCmdlinePopup = { bg = p.bg_dark, fg = p.fg },
            NoiceCmdlinePopupBorder = { bg = p.bg_dark, fg = p.blue },
            NoiceCmdlineIcon = { bg = p.bg_dark, fg = p.yellow },
            NoicePopup = { bg = p.bg_dark, fg = p.fg },
            NoicePopupBorder = { bg = p.bg_dark, fg = p.border },
            NotifyBackground = { bg = p.bg },
            NotifyERRORBorder = { fg = p.red, bg = p.bg },
            NotifyWARNBorder = { fg = p.yellow, bg = p.bg },
            NotifyINFOBorder = { fg = p.cyan, bg = p.bg },
            NotifyDEBUGBorder = { fg = p.fg_dark, bg = p.bg },
            NotifyTRACEBorder = { fg = p.magenta, bg = p.bg },

            DiagnosticError = { fg = p.red, style = "bold" },
            DiagnosticWarn = { fg = p.yellow, style = "bold" },
            DiagnosticInfo = { fg = p.cyan, style = "bold" },
            DiagnosticHint = { fg = p.magenta, style = "bold" },

            RainbowDelimiter1 = { fg = p.red },
            RainbowDelimiter2 = { fg = p.yellow },
            RainbowDelimiter3 = { fg = p.green },
            RainbowDelimiter4 = { fg = p.blue },
            RainbowDelimiter5 = { fg = p.magenta },
            RainbowDelimiter6 = { fg = p.cyan },
            RainbowDelimiter7 = { fg = p.orange },

            SnacksIndent1 = { fg = p.border },
            SnacksIndent2 = { fg = p.border },
            SnacksIndent3 = { fg = p.border },
            SnacksIndent4 = { fg = p.border },
            SnacksIndent5 = { fg = p.border },
            SnacksIndent6 = { fg = p.border },
            SnacksIndent7 = { fg = p.border },

            MiniFilesBorder = { fg = p.border, bg = p.bg },
            MiniFilesBorderModified = { fg = p.yellow, bg = p.bg },
            MiniFilesCursorLine = { bg = p.bg_float },
            MiniFilesDirectory = { fg = p.blue, style = "bold" },
            MiniFilesFile = { fg = p.fg },
            MiniFilesNormal = { fg = p.fg, bg = p.bg },
            MiniFilesTitle = { fg = p.magenta, bg = p.bg, style = "bold" },
            MiniFilesTitleFocused = { fg = p.bg, bg = p.blue, style = "bold" },
            MiniFilesTitleModified = { fg = p.yellow, bg = p.bg, style = "bold" },

            OilDir = { fg = p.blue, style = "bold" },
            OilFile = { fg = p.fg },
            OilLink = { fg = p.cyan, style = "underline" },
            OilCopy = { fg = p.green },
            OilMove = { fg = p.yellow },
            OilChange = { fg = p.orange },
            OilCreate = { fg = p.green },
            OilDelete = { fg = p.red },
            OilPermissionRead = { fg = p.blue },
            OilPermissionWrite = { fg = p.yellow },
            OilPermissionExecute = { fg = p.green },

            -- Destaques extras de código para uma leitura mais “viva”
            Comment = { fg = p.fg_dark, style = "italic" },
            Function = { fg = p.blue, style = "bold" },
            ["@function"] = { fg = p.blue, style = "bold" },
            ["@function.call"] = { fg = p.cyan, style = "bold" },
            Constant = { fg = p.yellow, style = "bold" },
            ["@constant"] = { fg = p.yellow, style = "bold" },
            ["@constant.builtin"] = { fg = p.orange, style = "bold" },
            ["@variable.builtin"] = { fg = p.magenta, style = "bold" },
          },
        },
      })

      vim.g.noctis_lualine_theme = {
        normal = {
          a = { bg = p.red,     fg = p.bg, gui = "bold" },
          b = { bg = p.blue,    fg = p.bg, gui = "bold" },
          c = { bg = p.bg,      fg = p.fg },
          x = { bg = p.bg_dark, fg = p.fg },
          y = { bg = p.bg_dark, fg = p.fg },
          z = { bg = p.bg,      fg = p.fg_dark },
        },
        insert = {
          a = { bg = p.cyan,    fg = p.bg, gui = "bold" },
          b = { bg = p.blue,    fg = p.bg, gui = "bold" },
          c = { bg = p.bg,      fg = p.fg },
          x = { bg = p.bg_dark, fg = p.fg },
          y = { bg = p.bg_dark, fg = p.fg },
          z = { bg = p.bg,      fg = p.fg_dark },
        },
        visual = {
          a = { bg = p.magenta, fg = p.bg, gui = "bold" },
          b = { bg = p.blue,    fg = p.bg, gui = "bold" },
          c = { bg = p.bg,      fg = p.fg },
          x = { bg = p.bg_dark, fg = p.fg },
          y = { bg = p.bg_dark, fg = p.fg },
          z = { bg = p.bg,      fg = p.fg_dark },
        },
        replace = {
          a = { bg = p.orange,  fg = p.bg, gui = "bold" },
          b = { bg = p.blue,    fg = p.bg, gui = "bold" },
          c = { bg = p.bg,      fg = p.fg },
          x = { bg = p.bg_dark, fg = p.fg },
          y = { bg = p.bg_dark, fg = p.fg },
          z = { bg = p.bg,      fg = p.fg_dark },
        },
        command = {
          a = { bg = p.yellow,  fg = p.bg, gui = "bold" },
          b = { bg = p.blue,    fg = p.bg, gui = "bold" },
          c = { bg = p.bg,      fg = p.fg },
          x = { bg = p.bg_dark, fg = p.fg },
          y = { bg = p.bg_dark, fg = p.fg },
          z = { bg = p.bg,      fg = p.fg_dark },
        },
        inactive = {
          a = { bg = p.bg,      fg = p.fg_dark },
          b = { bg = p.bg,      fg = p.fg_dark },
          c = { bg = p.bg,      fg = p.fg_dark },
          x = { bg = p.bg,      fg = p.fg_dark },
          y = { bg = p.bg,      fg = p.fg_dark },
          z = { bg = p.bg,      fg = p.fg_dark },
        },
      }

      vim.cmd.colorscheme("carbonfox")
    end,
  },
}
