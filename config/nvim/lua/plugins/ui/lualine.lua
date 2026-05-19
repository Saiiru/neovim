return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    priority = 1100,
    dependencies = {
      "echasnovski/mini.icons",
    },
    opts = function()
      local mini_icons = require("mini.icons")
      local p = vim.g.noctis_palette
        or {
          bg = "#0A0E14",
          bg_dark = "#111826",
          border = "#22304A",
          fg = "#F2F7FF",
          fg_dark = "#98A9C2",
          red = "#FF3B5C",
          orange = "#FF8F40",
          yellow = "#FFD000",
          green = "#39FF14",
          blue = "#2AC3FF",
          cyan = "#56D4DD",
          magenta = "#A77DFF",
          github = "#C9D1D9",
        }

      local function env_cleanup(venv)
        return venv:match("[^/]+$") or venv
      end

      local cond = {
        has_file = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        wide = function()
          return vim.o.columns > 100
        end,
        is_git = function()
          local fp = vim.fn.expand("%:p:h")
          local gd = vim.fn.finddir(".git", fp .. ";")
          return gd and #gd > 0 and #gd < #fp
        end,
        has_python_env = function()
          return vim.bo.filetype == "python" and (vim.env.CONDA_DEFAULT_ENV ~= nil or vim.env.VIRTUAL_ENV ~= nil)
        end,
      }

      local mode_names = {
        n = "NORMAL",
        no = "NORMAL",
        nov = "NORMAL",
        noV = "NORMAL",
        niI = "NORMAL",
        niR = "NORMAL",
        niV = "NORMAL",
        nt = "NORMAL",
        i = "INSERT",
        ic = "INSERT",
        ix = "INSERT",
        v = "VISUAL",
        vs = "VISUAL",
        V = "V-LINE",
        Vs = "V-LINE",
        s = "SELECT",
        S = "S-LINE",
        R = "REPLACE",
        Rc = "REPLACE",
        Rv = "V-RPLC",
        c = "COMMAND",
        cv = "COMMAND",
        r = "PROMPT",
        rm = "MORE",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        t = "TERMINAL",
        ["\22"] = "V-BLOCK",
        ["\22s"] = "V-BLOCK",
        ["\19"] = "S-BLOCK",
      }

      local mode_colors = {
        n = p.blue,
        no = p.blue,
        nov = p.blue,
        noV = p.blue,
        niI = p.blue,
        niR = p.blue,
        niV = p.blue,
        nt = p.blue,
        i = p.cyan,
        ic = p.cyan,
        ix = p.cyan,
        v = p.magenta,
        vs = p.magenta,
        V = p.magenta,
        Vs = p.magenta,
        s = p.yellow,
        S = p.yellow,
        R = p.red,
        Rc = p.red,
        Rv = p.red,
        c = p.orange,
        cv = p.orange,
        r = p.orange,
        rm = p.orange,
        ["r?"] = p.orange,
        ["!"] = p.red,
        t = p.magenta,
        ["\22"] = p.magenta,
        ["\22s"] = p.magenta,
        ["\19"] = p.yellow,
      }

      local function mode_str()
        return " " .. (mode_names[vim.fn.mode()] or "NORMAL") .. " "
      end

      local function mode_color()
        return mode_colors[vim.fn.mode()] or p.blue
      end

      local function smart_filename()
        local full = vim.fn.expand("%:p")
        if full == "" then
          return "[No Name]"
        end

        local cwd = vim.fn.getcwd()
        local shown = vim.fn.expand("%:t")

        if cwd ~= "" and vim.startswith(full, cwd) then
          local rel = full:sub(#cwd + 2)
          shown = rel:gsub("([^/]+)/", function(d)
            return d:sub(1, 1) .. "/"
          end)
        end

        local flags = ""
        if vim.bo.readonly then
          flags = flags .. " 󰌾"
        end
        if vim.bo.modified then
          flags = flags .. " ●"
        end

        return shown .. flags
      end

      local function python_env()
        if vim.bo.filetype ~= "python" then
          return ""
        end
        local venv = vim.env.CONDA_DEFAULT_ENV or vim.env.VIRTUAL_ENV
        return venv and (" " .. env_cleanup(venv)) or ""
      end

      local function ft_segment()
        local ft = vim.bo.filetype
        local label = ft ~= "" and ft:upper() or vim.fn.expand("%:e"):upper()
        local icon = mini_icons.get("filetype", ft)
        if type(icon) == "table" then
          icon = icon[1]
        end
        return (icon and icon ~= "" and (icon .. " " .. label)) or label
      end

      local function lsp_segment()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if vim.tbl_isempty(clients) then
          return ""
        end
        local labels = require("config.icons").lsp_labels
        local names = {}
        for _, client in ipairs(clients) do
          table.insert(names, labels[client.name] or client.name:upper())
        end
        return " " .. table.concat(names, "+")
      end

      local function pos_segment()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        local total = vim.api.nvim_buf_line_count(0)
        local pct = total > 0 and math.floor((line / total) * 100 + 0.5) or 0
        return string.format("%3d:%-2d %d%%%%", line, col, pct)
      end

      local function enc_segment()
        local enc = (vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding):upper()
        local ff = vim.bo.fileformat:upper()
        return enc .. " · " .. ff
      end

      return {
        options = {
          theme = {
            normal = {
              a = { bg = p.bg, fg = p.red, gui = "bold" },
              b = { bg = p.bg, fg = p.blue, gui = "bold" },
              c = { bg = p.bg, fg = p.fg },
              x = { bg = p.bg_dark, fg = p.fg },
              y = { bg = p.bg_dark, fg = p.fg },
              z = { bg = p.bg, fg = p.fg_dark },
            },
            insert = {
              a = { bg = p.bg, fg = p.cyan, gui = "bold" },
              b = { bg = p.bg, fg = p.blue, gui = "bold" },
              c = { bg = p.bg, fg = p.fg },
              x = { bg = p.bg_dark, fg = p.fg },
              y = { bg = p.bg_dark, fg = p.fg },
              z = { bg = p.bg, fg = p.fg_dark },
            },
            visual = {
              a = { bg = p.bg, fg = p.magenta, gui = "bold" },
              b = { bg = p.bg, fg = p.blue, gui = "bold" },
              c = { bg = p.bg, fg = p.fg },
              x = { bg = p.bg_dark, fg = p.fg },
              y = { bg = p.bg_dark, fg = p.fg },
              z = { bg = p.bg, fg = p.fg_dark },
            },
            replace = {
              a = { bg = p.bg, fg = p.orange, gui = "bold" },
              b = { bg = p.bg, fg = p.blue, gui = "bold" },
              c = { bg = p.bg, fg = p.fg },
              x = { bg = p.bg_dark, fg = p.fg },
              y = { bg = p.bg_dark, fg = p.fg },
              z = { bg = p.bg, fg = p.fg_dark },
            },
            command = {
              a = { bg = p.bg, fg = p.yellow, gui = "bold" },
              b = { bg = p.bg, fg = p.blue, gui = "bold" },
              c = { bg = p.bg, fg = p.fg },
              x = { bg = p.bg_dark, fg = p.fg },
              y = { bg = p.bg_dark, fg = p.fg },
              z = { bg = p.bg, fg = p.fg_dark },
            },
            inactive = {
              a = { bg = p.bg, fg = p.fg_dark },
              b = { bg = p.bg, fg = p.fg_dark },
              c = { bg = p.bg, fg = p.fg_dark },
              x = { bg = p.bg, fg = p.fg_dark },
              y = { bg = p.bg, fg = p.fg_dark },
              z = { bg = p.bg, fg = p.fg_dark },
            },
          },
          component_separators = "",
          section_separators = "",
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            -- Refresh agressivo deixa tmux/tpipeline e command-line piscando.
            statusline = 500,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = {
            {
              function()
                return "󰭟"
              end,
              color = { fg = p.red, bg = p.bg, gui = "bold" },
              padding = { left = 1, right = 1 },
            },
            {
              mode_str,
              color = function()
                return { fg = mode_color(), bg = p.bg, gui = "bold" }
              end,
              padding = { left = 0, right = 1 },
            },
          },
          lualine_b = {
            {
              python_env,
              cond = cond.has_python_env,
              color = { fg = p.cyan, bg = p.bg, gui = "bold" },
            },
            {
              smart_filename,
              cond = cond.has_file,
              color = { fg = p.fg, bg = p.bg, gui = "bold" },
            },
            {
              pos_segment,
              color = { fg = p.blue, bg = p.bg, gui = "bold" },
            },
          },
          lualine_c = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = "ERR ", warn = "WRN ", info = "INF ", hint = "HNT " },
              diagnostics_color = {
                error = { fg = p.red, bg = p.bg, gui = "bold" },
                warn = { fg = p.yellow, bg = p.bg, gui = "bold" },
                info = { fg = p.cyan, bg = p.bg, gui = "bold" },
                hint = { fg = p.magenta, bg = p.bg, gui = "bold" },
              },
            },
          },
          lualine_x = {
            {
              lsp_segment,
              cond = function()
                return lsp_segment() ~= ""
              end,
              color = { fg = p.magenta, bg = p.bg_dark, gui = "bold" },
            },
            {
              ft_segment,
              color = { fg = p.cyan, bg = p.bg_dark, gui = "bold" },
            },
            {
              enc_segment,
              cond = cond.wide,
              color = { fg = p.fg_dark, bg = p.bg_dark },
            },
          },
          lualine_y = {
            {
              "branch",
              icon = " ",
              cond = cond.is_git,
              color = { fg = p.github, bg = p.bg_dark, gui = "bold" },
            },
            {
              "diff",
              cond = cond.is_git,
              symbols = { added = " +", modified = " ~", removed = " -" },
              diff_color = {
                added = { fg = p.cyan, bg = p.bg_dark, gui = "bold" },
                modified = { fg = p.yellow, bg = p.bg_dark, gui = "bold" },
                removed = { fg = p.red, bg = p.bg_dark, gui = "bold" },
              },
            },
          },
          lualine_z = {
            {
              function()
                return "▍"
              end,
              color = { fg = p.border, bg = p.bg, gui = "bold" },
              padding = { left = 0, right = 0 },
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            { smart_filename, color = { fg = p.fg_dark, bg = p.bg } },
          },
          lualine_x = {
            { "location", color = { fg = p.fg_dark, bg = p.bg } },
          },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "oil", "quickfix", "trouble", "neo-tree" },
      }
    end,
  },

  {
    "vimpostor/vim-tpipeline",
    lazy = false,
    enabled = vim.env.TMUX ~= nil,
    init = function()
      vim.g.tpipeline_autoembed = 0
      vim.g.tpipeline_restore = 1
      vim.g.tpipeline_statusline = "%!tpipeline#stl#line()"
    end,
  },
}
