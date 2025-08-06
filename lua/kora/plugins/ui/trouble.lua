-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                KORA TROUBLE - DIAGNOSTIC ENHANCEMENT MATRIX             ║
-- ║                     Visual Studio Code + JetBrains Style                ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- ═══════════════════════════════════════════════════════════════════════════
  -- 🚨 TROUBLE - ENHANCED DIAGNOSTIC INTERFACE (FIXED)
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "folke/lsp-colors.nvim", -- Better LSP colors
    },
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    keys = {
      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🎯 MAIN DIAGNOSTICS
      -- ═══════════════════════════════════════════════════════════════════════════
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "🚨 Diagnostics (Trouble)" },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "📄 Buffer Diagnostics",
      },
      {
        "<leader>xw",
        "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.WARN<cr>",
        desc = "⚠️ Warnings Only",
      },
      {
        "<leader>xe",
        "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>",
        desc = "❌ Errors Only",
      },

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🔍 LSP & SYMBOLS
      -- ═══════════════════════════════════════════════════════════════════════════
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "🔖 Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "🔗 LSP References",
      },
      { "<leader>cd", "<cmd>Trouble lsp_definitions toggle<cr>", desc = "📍 Definitions" },
      {
        "<leader>ct",
        "<cmd>Trouble lsp_type_definitions toggle<cr>",
        desc = "🏷️ Type Definitions",
      },
      {
        "<leader>ci",
        "<cmd>Trouble lsp_implementations toggle<cr>",
        desc = "⚙️ Implementations",
      },

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 📋 LISTS & NAVIGATION
      -- ═══════════════════════════════════════════════════════════════════════════
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "📍 Location List" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "⚡ Quickfix List" },
      { "<leader>xj", "<cmd>Trouble jumps toggle<cr>", desc = "🦘 Jump List" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "✅ Todo Comments" },

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🎮 NAVIGATION SHORTCUTS
      -- ═══════════════════════════════════════════════════════════════════════════
      {
        "]x",
        function()
          require("trouble").next({ skip_groups = true, jump = true })
        end,
        desc = "Next Trouble",
      },
      {
        "[x",
        function()
          require("trouble").prev({ skip_groups = true, jump = true })
        end,
        desc = "Prev Trouble",
      },
      {
        "]X",
        function()
          require("trouble").last({ skip_groups = true, jump = true })
        end,
        desc = "Last Trouble",
      },
      {
        "[X",
        function()
          require("trouble").first({ skip_groups = true, jump = true })
        end,
        desc = "First Trouble",
      },
    },
    opts = {
      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🎨 VISUAL CONFIGURATION - CYBERPUNK STYLE (FIXED)
      -- ═══════════════════════════════════════════════════════════════════════════
      warn_no_results = false,
      open_no_results = false,

      -- Window configuration
      win = {
        type = "split",
        position = "bottom",
        size = { height = 12 },
        border = "rounded",
        title = "🚨 KORA Trouble Matrix",
        title_pos = "center",
        padding = { top = 1, bottom = 1 },
        zindex = 200,
      },

      -- Preview window
      preview = {
        type = "main",
        scratch = true,
      },

      -- Throttle updates
      throttle = {
        refresh = 20,
        update = 10,
        render = 10,
        follow = 50,
        preview = { ms = 100, debounce = true },
      },

      -- Key mappings
      keys = {
        ["?"] = "help",
        r = "refresh",
        R = "toggle_refresh",
        q = "close",
        o = "jump_close",
        ["<esc>"] = "cancel",
        ["<cr>"] = "jump",
        ["<2-leftmouse>"] = "jump",
        ["<c-s>"] = "jump_split",
        ["<c-v>"] = "jump_vsplit",
        ["dd"] = "delete",
        d = { action = "delete", mode = "v" },
        i = "inspect",
        p = "preview",
        P = "toggle_preview",
        zo = "fold_open",
        zO = "fold_open_recursive",
        zc = "fold_close",
        zC = "fold_close_recursive",
        za = "fold_toggle",
        zA = "fold_toggle_recursive",
        zm = "fold_more",
        zM = "fold_close_all",
        zr = "fold_reduce",
        zR = "fold_open_all",
        zx = "fold_update",
        zX = "fold_update_all",
        zn = "fold_disable",
        zN = "fold_enable",
        zi = "fold_toggle_enable",
        gb = { -- example of a custom action that toggles the active view filter
          action = function(view)
            view:filter({ buf = 0 }, { toggle = true })
          end,
          desc = "Toggle Current Buffer Filter",
        },
        s = { -- example of a custom action that toggles the severity
          action = function(view)
            local f = view:get_filter("severity")
            local severity = ((f and f.filter.severity or 0) + 1) % 5
            view:filter(
              { severity = severity },
              {
                id = "severity",
                template = "{hl:Title}Filter:{hl} {severity}",
                del = severity == 0,
              }
            )
          end,
          desc = "Toggle Severity Filter",
        },
      },

      -- Mode-specific configurations
      modes = {
        -- LSP Document Symbols
        lsp_document_symbols = {
          win = { position = "right", size = { width = 0.3 } },
          filter = {
            any = {
              ft = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
            },
          },
        },

        -- Diagnostics with proper formatting
        diagnostics = {
          mode = "diagnostics",
          filter = { buf = 0 },
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
          format = "{severity_icon} {filename} {pos} {item.message}",
          groups = {
            { "filename", format = "{file_icon} {filename} {count}" },
          },
        },

        -- Symbols mode
        symbols = {
          desc = "document symbols",
          mode = "lsp_document_symbols",
          focus = false,
          win = { position = "right" },
          filter = {
            -- Remove Package symbols for Lua
            ["not"] = { ft = "lua", kind = "Package" },
            any = {
              ft = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
            },
          },
        },

        -- LSP references and definitions
        lsp = {
          mode = "lsp_references",
          focus = true,
        },

        -- Quickfix list
        qflist = {
          mode = "qflist",
          format = "{pos} {item.text}",
        },

        -- Location list
        loclist = {
          mode = "loclist",
          format = "{pos} {item.text}",
        },
      },

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🎯 ICONS CONFIGURATION (PROPER FORMAT)
      -- ═══════════════════════════════════════════════════════════════════════════
      icons = {
        indent = {
          top = "│ ",
          middle = "├╴",
          last = "└╴",
          fold_open = " ",
          fold_closed = " ",
          ws = "  ",
        },
        folder_closed = " ",
        folder_open = " ",
        kinds = {
          Array = " ",
          Boolean = "󰨙 ",
          Class = " ",
          Constant = "󰏿 ",
          Constructor = " ",
          Enum = " ",
          EnumMember = " ",
          Event = " ",
          Field = " ",
          File = " ",
          Function = "󰊕 ",
          Interface = " ",
          Key = " ",
          Method = "󰊕 ",
          Module = " ",
          Namespace = "󰦮 ",
          Null = " ",
          Number = "󰎠 ",
          Object = " ",
          Operator = " ",
          Package = " ",
          Property = " ",
          String = " ",
          Struct = "󰆼 ",
          TypeParameter = " ",
          Variable = "󰀫 ",
        },
      },

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🎨 FORMATTERS (SAFE CONFIGURATION)
      -- ═══════════════════════════════════════════════════════════════════════════
      formatters = {
        diagnostic = {
          format = function(ctx)
            local icon = "󰅚"
            if ctx.item.severity == vim.diagnostic.severity.ERROR then
              icon = "󰅚"
            elseif ctx.item.severity == vim.diagnostic.severity.WARN then
              icon = "󰀪"
            elseif ctx.item.severity == vim.diagnostic.severity.INFO then
              icon = "󰋽"
            elseif ctx.item.severity == vim.diagnostic.severity.HINT then
              icon = "󰌶"
            end
            return string.format("%s %s", icon, ctx.item.message)
          end,
        },
      },
    },
    config = function(_, opts)
      require("trouble").setup(opts)

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🎨 CUSTOM HIGHLIGHTS - CYBERPUNK THEME
      -- ═══════════════════════════════════════════════════════════════════════════
      local function setup_highlights()
        local colors = {
          bg = "#16213E",
          fg = "#F8F8F2",
          purple = "#BD93F9",
          cyan = "#8BE9FD",
          green = "#50FA7B",
          yellow = "#F1FA8C",
          orange = "#FFB86C",
          red = "#FF5555",
          pink = "#FF79C6",
          gray = "#6272A4",
        }

        vim.api.nvim_set_hl(0, "TroubleNormal", { fg = colors.fg, bg = colors.bg })
        vim.api.nvim_set_hl(0, "TroubleCount", { fg = colors.purple, bold = true })
        vim.api.nvim_set_hl(0, "TroubleFile", { fg = colors.cyan, bold = true })
        vim.api.nvim_set_hl(0, "TroubleDirectory", { fg = colors.gray })
        vim.api.nvim_set_hl(0, "TroubleCode", { fg = colors.orange })
        vim.api.nvim_set_hl(0, "TroubleSource", { fg = colors.gray })
        vim.api.nvim_set_hl(0, "TroublePos", { fg = colors.pink })

        -- Diagnostic severity colors
        vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.red })
        vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = colors.yellow })
        vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.cyan })
        vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.green })
      end

      setup_highlights()

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🤖 AI-POWERED DIAGNOSTIC EXPLANATIONS
      -- ═══════════════════════════════════════════════════════════════════════════
      local function explain_diagnostic_with_ai()
        local current_line = vim.api.nvim_get_current_line()
        local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })

        if #diagnostics == 0 then
          print("No diagnostics on current line")
          return
        end

        local diagnostic = diagnostics[1]
        local prompt = string.format(
          "Explain this %s diagnostic and suggest a fix:\n\nMessage: %s\nCode: %s\nLine: %s",
          vim.diagnostic.severity[diagnostic.severity]:lower(),
          diagnostic.message,
          diagnostic.code or "unknown",
          current_line:gsub("^%s+", "") -- Remove leading whitespace
        )

        -- Use your Copilot Chat if available
        if pcall(require, "CopilotChat") then
          require("CopilotChat").ask(prompt, {
            selection = require("CopilotChat.select").line,
            window = {
              layout = "float",
              title = "🤖 Diagnostic Explanation",
              width = 0.8,
              height = 0.6,
            },
          })
        else
          print("AI explanation requires CopilotChat plugin")
        end
      end

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🎮 ENHANCED COMMANDS
      -- ═══════════════════════════════════════════════════════════════════════════
      vim.api.nvim_create_user_command("TroubleAI", explain_diagnostic_with_ai, {
        desc = "🤖 AI explanation for current diagnostic",
      })

      vim.api.nvim_create_user_command("TroubleStats", function()
        local diagnostics = vim.diagnostic.get()
        local stats = { error = 0, warn = 0, info = 0, hint = 0 }

        for _, diag in ipairs(diagnostics) do
          local severity = vim.diagnostic.severity[diag.severity]:lower()
          if severity == "error" then
            stats.error = stats.error + 1
          elseif severity == "warn" then
            stats.warn = stats.warn + 1
          elseif severity == "info" then
            stats.info = stats.info + 1
          elseif severity == "hint" then
            stats.hint = stats.hint + 1
          end
        end

        local report = string.format(
          "📊 Diagnostic Stats:\n"
            .. "❌ Errors: %d\n"
            .. "⚠️  Warnings: %d\n"
            .. "ℹ️  Info: %d\n"
            .. "💡 Hints: %d\n"
            .. "📈 Total: %d",
          stats.error,
          stats.warn,
          stats.info,
          stats.hint,
          stats.error + stats.warn + stats.info + stats.hint
        )

        print(report)
      end, { desc = "📊 Show diagnostic statistics" })

      vim.api.nvim_create_user_command("TroubleExport", function()
        local diagnostics = vim.diagnostic.get()
        local lines = { "# KORA Diagnostic Report - " .. os.date("%Y-%m-%d %H:%M:%S"), "" }

        for _, diag in ipairs(diagnostics) do
          local severity = vim.diagnostic.severity[diag.severity]
          local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(diag.bufnr), ":t")
          table.insert(
            lines,
            string.format("- **%s** `%s:%d` - %s", severity, file, diag.lnum + 1, diag.message)
          )
        end

        local export_file = "/tmp/kora_diagnostics.md"
        vim.fn.writefile(lines, export_file)
        print("📤 Diagnostics exported to: " .. export_file)
      end, { desc = "📤 Export diagnostics to markdown" })

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🗝️ ADDITIONAL KEYMAPS
      -- ═══════════════════════════════════════════════════════════════════════════
      vim.keymap.set("n", "<leader>xA", "<cmd>TroubleAI<cr>", { desc = "🤖 AI Diagnostic Help" })
      vim.keymap.set("n", "<leader>xS", "<cmd>TroubleStats<cr>", { desc = "📊 Diagnostic Stats" })
      vim.keymap.set(
        "n",
        "<leader>xE",
        "<cmd>TroubleExport<cr>",
        { desc = "📤 Export Diagnostics" }
      )

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🔧 AUTO-CONFIGURATION
      -- ═══════════════════════════════════════════════════════════════════════════

      -- Auto-open trouble for severe issues
      vim.api.nvim_create_autocmd("DiagnosticChanged", {
        callback = function()
          local diagnostics = vim.diagnostic.get(0)
          local error_count = 0

          for _, diag in ipairs(diagnostics) do
            if diag.severity == vim.diagnostic.severity.ERROR then
              error_count = error_count + 1
            end
          end

          -- Auto-open if more than 3 errors
          if error_count > 3 and not require("trouble").is_open() then
            vim.defer_fn(function()
              vim.cmd("Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR")
            end, 1000)
          end
        end,
      })

      -- Smart focus management
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "Trouble",
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = "no"
          vim.opt_local.foldcolumn = "0"
          vim.opt_local.winbar = ""
        end,
      })
    end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- 🌈 LSP COLORS ENHANCEMENT
  -- ═══════════════════════════════════════════════════════════════════════════
  {
    "folke/lsp-colors.nvim",
    event = "LspAttach",
    config = function()
      require("lsp-colors").setup({
        Error = "#FF5555",
        Warning = "#F1FA8C",
        Information = "#8BE9FD",
        Hint = "#50FA7B",
      })
    end,
  },
}
