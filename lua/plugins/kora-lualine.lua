return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    opts = function(_, opts)
      local colors = {
        bg = "#0d0f18",
        panel = "#161a2a",
        surface = "#222436",
        border = "#2d3f76",
        fg = "#c8d3f5",
        soft = "#a5b6cf",
        muted = "#828bb8",
        red = "#ff757f",
        green = "#c3e88d",
        yellow = "#ffc777",
        blue = "#82aaff",
        magenta = "#c099ff",
        cyan = "#86e1fc",
      }

      local noir = {
        normal = {
          a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
          b = { fg = colors.fg, bg = colors.surface },
          c = { fg = colors.soft, bg = colors.bg },
        },
        insert = {
          a = { fg = colors.bg, bg = colors.green, gui = "bold" },
          b = { fg = colors.fg, bg = colors.surface },
          c = { fg = colors.soft, bg = colors.bg },
        },
        visual = {
          a = { fg = colors.bg, bg = colors.magenta, gui = "bold" },
          b = { fg = colors.fg, bg = colors.surface },
          c = { fg = colors.soft, bg = colors.bg },
        },
        replace = {
          a = { fg = colors.bg, bg = colors.red, gui = "bold" },
          b = { fg = colors.fg, bg = colors.surface },
          c = { fg = colors.soft, bg = colors.bg },
        },
        command = {
          a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
          b = { fg = colors.fg, bg = colors.surface },
          c = { fg = colors.soft, bg = colors.bg },
        },
        inactive = {
          a = { fg = colors.muted, bg = colors.bg },
          b = { fg = colors.muted, bg = colors.bg },
          c = { fg = colors.muted, bg = colors.bg },
        },
      }

      local function kora_icon()
        return "󰭟"
      end

      local function short_cwd()
        return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end

      local function lsp_clients()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          return "LSP off"
        end

        local names = {}
        for _, client in ipairs(clients) do
          table.insert(names, client.name)
        end
        return " " .. table.concat(names, ",")
      end

      local function macro_recording()
        local reg = vim.fn.reg_recording()
        return reg ~= "" and ("REC @" .. reg) or ""
      end

      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        icons_enabled = true,
        theme = noir,
        globalstatus = true,
        always_divide_middle = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
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
          { kora_icon, color = { fg = colors.bg, bg = colors.yellow, gui = "bold" } },
          {
            "mode",
            fmt = function(mode)
              return mode:sub(1, 1)
            end,
          },
        },
        lualine_b = {
          { "branch", icon = "", color = { fg = colors.magenta, bg = colors.surface, gui = "bold" } },
          { "diff", symbols = { added = "+", modified = "~", removed = "-" } },
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = {
              modified = " ●",
              readonly = " ",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
        },
        lualine_x = {
          { macro_recording, color = { fg = colors.yellow, bg = colors.bg, gui = "bold" } },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          },
          { lsp_clients, color = { fg = colors.cyan, bg = colors.bg } },
        },
        lualine_y = {
          { "filetype", colored = true, icon_only = false },
          { "progress" },
        },
        lualine_z = {
          { "location", color = { fg = colors.bg, bg = colors.blue, gui = "bold" } },
          { short_cwd, color = { fg = colors.bg, bg = colors.cyan, gui = "bold" } },
        },
      }

      opts.inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1, color = { fg = colors.muted, bg = colors.bg } } },
        lualine_x = { { "location", color = { fg = colors.muted, bg = colors.bg } } },
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
