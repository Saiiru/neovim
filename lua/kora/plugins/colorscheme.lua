-- lua/kora/plugins/colorscheme.lua
-- KORA NEURAL VISUAL MATRIX - CYBERPUNK x ROSEPINE HYBRID v3.0
-- Centralized colorscheme configuration for KORA.

return {
  -- CYBERDREAM - Core Colorscheme (primary)
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      italic_comments = true,
      hide_fillchars = false,
      borderless_telescope = true,
      terminal_colors = true,
      cache = true,
      theme = {
        variant = "default",
        saturation = 1.0, -- Adjusted for overall vibrancy
        highlights = {
          -- KORA CYBERSYNTH PALETTE HIGHLIGHTS
          -- Base UI
          Normal = { fg = "#F8F8F2", bg = "#0B0A12" }, -- near-black background
          NormalFloat = { fg = "#F8F8F2", bg = "NONE" }, -- allow terminal transparency
          FloatBorder = { fg = "#9A6CFF", bg = "NONE", bold = true }, -- Neon purple border
          FloatTitle = { fg = "#FF2D95", bg = "NONE", bold = true }, -- Neon pink title

          -- Line numbers
          LineNr = { fg = "#6C7086", bg = "NONE" },
          CursorLineNr = { fg = "#FF2D95", bold = true }, -- Neon pink cursor line number
          CursorLine = { bg = "#141127" }, -- Darker background for cursor line
          CursorColumn = { bg = "#141127" }, -- Darker background for cursor column
          ColorColumn = { bg = "#262533" }, -- Dim background for color column

          -- Visual / selection
          Visual = { bg = "#9A6CFF", fg = "#0B0A12", bold = true, blend = 10 }, -- Neon purple selection
          Search = { bg = "#FFD166", fg = "#0B0A12", bold = true }, -- Neon yellow search
          IncSearch = { bg = "#FF6EC7", fg = "#0B0A12", bold = true }, -- Neon magenta incremental search

          -- Comments, keywords, strings, functions
          Comment = { fg = "#9A6CFF", italic = true }, -- Neon purple comments
          [" @comment"] = { fg = "#9A6CFF", italic = true },

          [" @keyword"] = { fg = "#FF2D95", italic = true, bold = true }, -- Neon pink keywords
          [" @keyword.function"] = { fg = "#FF2D95", italic = true },
          [" @keyword.return"] = { fg = "#FF2D95", italic = true },
          [" @keyword.operator"] = { fg = "#FF2D95", italic = false },

          [" @string"] = { fg = "#7CFF00" }, -- Neon green strings
          [" @string.escape"] = { fg = "#FFD166", bold = true }, -- Neon yellow string escapes

          [" @function"] = { fg = "#00F0FF", bold = true }, -- Neon cyan functions
          [" @function.builtin"] = { fg = "#00F0FF", italic = true },
          [" @function.call"] = { fg = "#00CFFF" }, -- Slightly darker cyan for calls
          [" @method"] = { fg = "#00CFFF" },
          [" @method.call"] = { fg = "#00CFFF" },

          -- Types, constants, tags
          [" @type"] = { fg = "#FFD166", italic = true }, -- Neon yellow types
          [" @type.builtin"] = { fg = "#FFD166", italic = true },
          [" @type.definition"] = { fg = "#FFD166", bold = true },
          [" @constant"] = { fg = "#9A6CFF", bold = true }, -- Neon purple constants
          [" @constant.builtin"] = { fg = "#9A6CFF", italic = true },
          [" @constant.macro"] = { fg = "#9A6CFF", bold = true },
          [" @operator"] = { fg = "#FF2D95" }, -- Neon pink operators
          [" @punctuation"] = { fg = "#F8F8F2" },
          [" @punctuation.bracket"] = { fg = "#F8F8F2" },
          [" @punctuation.delimiter"] = { fg = "#F8F8F2" },
          [" @tag"] = { fg = "#FF2D95" }, -- Neon pink tags
          [" @tag.attribute"] = { fg = "#7CFF00", italic = true }, -- Neon green tag attributes
          [" @tag.delimiter"] = { fg = "#F8F8F2" },
          [" @namespace"] = { fg = "#FFD166", italic = true },
          [" @property"] = { fg = "#7CFF00" }, -- Neon green properties
          [" @field"] = { fg = "#7CFF00" },
          [" @parameter"] = { fg = "#FFD166", italic = true }, -- Neon yellow parameters
          [" @label"] = { fg = "#FF2D95" }, -- Neon pink labels

          -- LSP SEMANTIC TOKENS (aligned with Tree-sitter)
          [" @lsp.type.class"] = { fg = "#FFD166", italic = true },
          [" @lsp.type.interface"] = { fg = "#FFD166", italic = true },
          [" @lsp.type.enum"] = { fg = "#FFD166", italic = true },
          [" @lsp.type.struct"] = { fg = "#FFD166", italic = true },
          [" @lsp.type.parameter"] = { fg = "#FFD166", italic = true },
          [" @lsp.type.property"] = { fg = "#7CFF00" },
          [" @lsp.type.method"] = { fg = "#00CFFF" },
          [" @lsp.type.function"] = { fg = "#00F0FF" },
          [" @lsp.type.variable"] = { fg = "#F8F8F2" },
          [" @lsp.type.namespace"] = { fg = "#FFD166", italic = true },
          [" @lsp.type.typeParameter"] = { fg = "#9A6CFF", italic = true },
          [" @lsp.mod.readonly"] = { italic = true },
          [" @lsp.mod.deprecated"] = { strikethrough = true },

          -- DIAGNOSTICS (neon)
          DiagnosticError = { fg = "#FF2D95" }, -- Neon pink error
          DiagnosticWarn = { fg = "#FFD166" }, -- Neon yellow warning
          DiagnosticInfo = { fg = "#00F0FF" }, -- Neon cyan info
          DiagnosticHint = { fg = "#9A6CFF" }, -- Neon purple hint
          DiagnosticOk = { fg = "#7CFF00" }, -- Neon green ok
          DiagnosticVirtualTextError = { fg = "#FF2D95", bg = "#2D1B1F" },
          DiagnosticVirtualTextWarn = { fg = "#FFD166", bg = "#2D2416" },
          DiagnosticVirtualTextInfo = { fg = "#00F0FF", bg = "#192A2D" },
          DiagnosticVirtualTextHint = { fg = "#9A6CFF", bg = "#1E1B2D" },
          DiagnosticVirtualTextOk = { fg = "#7CFF00", bg = "#193B2D" },
          DiagnosticUnderlineError = { underline = true, sp = "#FF2D95" },
          DiagnosticUnderlineWarn = { underline = true, sp = "#FFD166" },
          DiagnosticUnderlineInfo = { underline = true, sp = "#00F0FF" },
          DiagnosticUnderlineHint = { underline = true, sp = "#9A6CFF" },
          DiagnosticUnderlineOk = { underline = true, sp = "#7CFF00" },

          -- GIT SIGNS (neon)
          GitSignsAdd = { fg = "#7CFF00" }, -- Neon green add
          GitSignsChange = { fg = "#FFD166" }, -- Neon yellow change
          GitSignsDelete = { fg = "#FF2D95" }, -- Neon pink delete
          GitSignsAddInline = { bg = "#7CFF00", fg = "#0B0A12" },
          GitSignsChangeInline = { bg = "#FFD166", fg = "#0B0A12" },
          GitSignsDeleteInline = { bg = "#FF2D95", fg = "#0B0A12" },
          GitSignsAddLn = { bg = "#193B2D" },
          GitSignsChangeLn = { bg = "#2D2416" },
          GitSignsDeleteLn = { bg = "#2D1B1F" },

          -- NvimTree (aligned with palette)
          NvimTreeNormal = { bg = "#0B0A12" },
          NvimTreeWinSeparator = { fg = "#262533", bg = "#0B0A12" },
          NvimTreeRootFolder = { fg = "#9A6CFF", bold = true },
          NvimTreeFolderName = { fg = "#00F0FF" },
          NvimTreeFolderIcon = { fg = "#FFD166" },
          NvimTreeOpenedFolderName = { fg = "#7CFF00", bold = true },
          NvimTreeSpecialFile = { fg = "#FF2D95", underline = true },
          NvimTreeExecFile = { fg = "#7CFF00", bold = true },
          NvimTreeImageFile = { fg = "#9A6CFF" },
          NvimTreeMarkdownFile = { fg = "#00F0FF" },
          NvimTreeIndentMarker = { fg = "#262533" },
          NvimTreeSymlink = { fg = "#FF2D95", italic = true },
          NvimTreeGitDirty = { fg = "#FFD166" },
          NvimTreeGitStaged = { fg = "#7CFF00" },
          NvimTreeGitMerge = { fg = "#FF2D95" },
          NvimTreeGitRenamed = { fg = "#9A6CFF" },
          NvimTreeGitNew = { fg = "#7CFF00" },
          NvimTreeGitDeleted = { fg = "#FF2D95" },

          -- Bufferline (aligned with palette)
          BufferLineFill = { bg = "#0B0A12" },
          BufferLineBackground = { fg = "#6C7086", bg = "#141127" },
          BufferLineBufferSelected = { fg = "#F8F8F2", bg = "#9A6CFF", bold = true },
          BufferLineTab = { fg = "#6C7086", bg = "#141127" },
          BufferLineTabSelected = { fg = "#F8F8F2", bg = "#9A6CFF" },
          BufferLineTabClose = { fg = "#FF2D95", bg = "#141127" },
          BufferLineIndicatorSelected = { fg = "#00F0FF", bg = "#9A6CFF" },
          BufferLineCloseButton = { fg = "#6C7086", bg = "#141127" },
          BufferLineCloseButtonSelected = { fg = "#FF2D95", bg = "#9A6CFF" },
          BufferLineModified = { fg = "#FFD166", bg = "#141127" },
          BufferLineModifiedSelected = { fg = "#FFD166", bg = "#9A6CFF" },

          -- Indent guides
          IndentBlanklineChar = { fg = "#262533" },
          IndentBlanklineContextChar = { fg = "#9A6CFF" },
          IndentBlanklineContextStart = { underline = true, sp = "#9A6CFF" },
          IblIndent = { fg = "#262533" },
          IblScope = { fg = "#9A6CFF" },

          -- Which-key (aligned with palette)
          WhichKey = { fg = "#FF2D95", bold = true },
          WhichKeyGroup = { fg = "#00F0FF" },
          WhichKeyDesc = { fg = "#F8F8F2" },
          WhichKeySeperator = { fg = "#6C7086" },
          WhichKeyFloat = { bg = "#141127" },
          WhichKeyBorder = { fg = "#9A6CFF", bg = "#141127" },
          WhichKeyValue = { fg = "#9A6CFF" },

          -- Additional UI
          WinSeparator = { fg = "#262533" },
          LineNr = { fg = "#6C7086" },
          CursorLineNr = { fg = "#FF2D95", bold = true },
          CursorLine = { bg = "#141127" },
          CursorColumn = { bg = "#141127" },
          ColorColumn = { bg = "#141127" },
          Visual = { bg = "#9A6CFF" },
          VisualNOS = { bg = "#9A6CFF" },
          Search = { bg = "#FFD166", fg = "#0B0A12" },
          IncSearch = { bg = "#FF6EC7", fg = "#0B0A12" },
          CurSearch = { bg = "#7CFF00", fg = "#0B0A12" },
          MatchParen = { bg = "#262533", bold = true },
          Substitute = { bg = "#9A6CFF", fg = "#0B0A12" },

          Folded = { fg = "#6C7086", bg = "#141127", italic = true },
          FoldColumn = { fg = "#6C7086", bg = "NONE" },

          SignColumn = { bg = "NONE" },
          SignColumnSB = { bg = "#0B0A12" },

          CopilotSuggestion = { fg = "#6C7086", italic = true },
          CopilotAnnotation = { fg = "#9A6CFF", italic = true },

          NotifyBackground = { bg = "#141127" },
          NotifyBorder = { fg = "#9A6CFF" },
          NotifyERRORBorder = { fg = "#FF2D95" },
          NotifyWARNBorder = { fg = "#FFD166" },
          NotifyINFOBorder = { fg = "#00F0FF" },
          NotifyDEBUGBorder = { fg = "#9A6CFF" },
          NotifyTRACEBorder = { fg = "#7CFF00" },
          NotifyERRORTitle = { fg = "#FF2D95", bold = true },
          NotifyWARNTitle = { fg = "#FFD166", bold = true },
          NotifyINFOTitle = { fg = "#00F0FF", bold = true },
          NotifyDEBUGTitle = { fg = "#9A6CFF", bold = true },
          NotifyTRACETitle = { fg = "#7CFF00", bold = true },
        },
      },
    },
    config = function(_, opts)
      require("cyberdream").setup(opts)
      vim.cmd("colorscheme cyberdream")

      -- KORA CYBERSYNTH TERMINAL PALETTE
      vim.g.terminal_color_0 = "#0B0A12"
      vim.g.terminal_color_1 = "#FF2D95"
      vim.g.terminal_color_2 = "#7CFF00"
      vim.g.terminal_color_3 = "#FFD166"
      vim.g.terminal_color_4 = "#00F0FF"
      vim.g.terminal_color_5 = "#FF6EC7"
      vim.g.terminal_color_6 = "#9A6CFF"
      vim.g.terminal_color_7 = "#F8F8F2"
      vim.g.terminal_color_8 = "#262533"
      vim.g.terminal_color_9 = "#FF2D95"
      vim.g.terminal_color_10 = "#7CFF00"
      vim.g.terminal_color_11 = "#FFD166"
      vim.g.terminal_color_12 = "#00CFFF"
      vim.g.terminal_color_13 = "#FF6EC7"
      vim.g.terminal_color_14 = "#9A6CFF"
      vim.g.terminal_color_15 = "#FFFFFF"

      -- extra: override endofbuffer to keep "clean" look
      vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = opts.theme.highlights.Normal.bg })

      -- small UX touches
      vim.o.pumblend = 10 -- transparency for completion popup (requires term support)
      vim.o.termguicolors = true

      -- optional user command to toggle "puff" intensity
      vim.api.nvim_create_user_command("KoraSynthBoost", function(opts)
        local mode = opts.args == "off" and "off" or "on"
        if mode == "on" then
          -- increase saturation by switching highlight variants
          vim.api.nvim_set_hl(0, "Normal", { fg = "#F8F8F2", bg = "#07060A" })
          vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#FF6EC7", fg = "#0B0A12", bold = true })
          vim.notify("KORA CyberSynth: BOOST ON", vim.log.levels.INFO)
        else
          vim.api.nvim_set_hl(0, "Normal", { fg = "#F8F8F2", bg = "#0B0A12" })
          vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#9A6CFF", fg = "#0B0A12", bold = true })
          vim.notify("KORA CyberSynth: BOOST OFF", vim.log.levels.INFO)
        end
      end, { nargs = "?" })
    end,
  },
}