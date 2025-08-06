-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                    KORA NEURAL VISUAL MATRIX ENHANCED                   ║
-- ║                      CYBERPUNK INTERFACE THEME v2.0                     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
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
        saturation = 1.0,
        highlights = {
          -- ═══════════════════════════════════════════════════════════════════════
          -- 🧬 ENHANCED SYNTAX HIGHLIGHTING - NEURAL PATTERNS v2.0
          -- ═══════════════════════════════════════════════════════════════════════
          Comment = { fg = "#7B68EE", italic = true },
          ["@comment"] = { fg = "#7B68EE", italic = true },
          ["@keyword"] = { fg = "#FF79C6", italic = true },
          ["@keyword.function"] = { fg = "#FF79C6", italic = true },
          ["@keyword.return"] = { fg = "#FF79C6", italic = true },
          ["@keyword.operator"] = { fg = "#FF79C6", italic = false },
          ["@string"] = { fg = "#50FA7B" },
          ["@string.escape"] = { fg = "#F1FA8C", bold = true },
          ["@variable"] = { fg = "#F8F8F2" },
          ["@variable.builtin"] = { fg = "#BD93F9", italic = true },
          ["@function"] = { fg = "#8BE9FD", italic = false },
          ["@function.builtin"] = { fg = "#8BE9FD", italic = true },
          ["@function.call"] = { fg = "#8BE9FD" },
          ["@method"] = { fg = "#8BE9FD" },
          ["@method.call"] = { fg = "#8BE9FD" },
          ["@type"] = { fg = "#FFB86C", italic = true },
          ["@type.builtin"] = { fg = "#FFB86C", italic = true },
          ["@type.definition"] = { fg = "#FFB86C", bold = true },
          ["@constant"] = { fg = "#BD93F9" },
          ["@constant.builtin"] = { fg = "#BD93F9", italic = true },
          ["@constant.macro"] = { fg = "#BD93F9", bold = true },
          ["@operator"] = { fg = "#FF79C6" },
          ["@punctuation"] = { fg = "#F8F8F2" },
          ["@punctuation.bracket"] = { fg = "#F8F8F2" },
          ["@punctuation.delimiter"] = { fg = "#F8F8F2" },
          ["@tag"] = { fg = "#FF79C6" },
          ["@tag.attribute"] = { fg = "#50FA7B", italic = true },
          ["@tag.delimiter"] = { fg = "#F8F8F2" },
          ["@namespace"] = { fg = "#FFB86C", italic = true },
          ["@property"] = { fg = "#50FA7B" },
          ["@field"] = { fg = "#50FA7B" },
          ["@parameter"] = { fg = "#FFB86C", italic = true },
          ["@label"] = { fg = "#FF79C6" },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 🧠 LSP SEMANTIC TOKENS - ENHANCED INTELLIGENCE
          -- ═══════════════════════════════════════════════════════════════════════
          ["@lsp.type.class"] = { fg = "#FFB86C", italic = true },
          ["@lsp.type.interface"] = { fg = "#FFB86C", italic = true },
          ["@lsp.type.enum"] = { fg = "#FFB86C", italic = true },
          ["@lsp.type.struct"] = { fg = "#FFB86C", italic = true },
          ["@lsp.type.parameter"] = { fg = "#FFB86C", italic = true },
          ["@lsp.type.property"] = { fg = "#50FA7B" },
          ["@lsp.type.method"] = { fg = "#8BE9FD" },
          ["@lsp.type.function"] = { fg = "#8BE9FD" },
          ["@lsp.type.variable"] = { fg = "#F8F8F2" },
          ["@lsp.type.namespace"] = { fg = "#FFB86C", italic = true },
          ["@lsp.type.typeParameter"] = { fg = "#BD93F9", italic = true },
          ["@lsp.mod.readonly"] = { italic = true },
          ["@lsp.mod.deprecated"] = { strikethrough = true },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 🖥️ ENHANCED UI ELEMENTS - NEURAL HUD v2.0
          -- ═══════════════════════════════════════════════════════════════════════
          Normal = { fg = "#F8F8F2", bg = "#16213E" },
          NormalFloat = { bg = "#1E1E2E", fg = "#CDD6F4" },
          FloatBorder = { fg = "#7B68EE", bg = "#1E1E2E" },
          FloatTitle = { fg = "#FF79C6", bg = "#1E1E2E", bold = true },
          Pmenu = { bg = "#1E1E2E", fg = "#CDD6F4" },
          PmenuSel = { bg = "#313244", fg = "#CDD6F4", bold = true },
          PmenuSbar = { bg = "#313244" },
          PmenuThumb = { bg = "#7B68EE" },

          -- Status line enhancements
          StatusLine = { fg = "#CDD6F4", bg = "#1E1E2E" },
          StatusLineNC = { fg = "#6C7086", bg = "#1E1E2E" },
          WinBar = { fg = "#CDD6F4", bg = "NONE" },
          WinBarNC = { fg = "#6C7086", bg = "NONE" },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 🔍 ENHANCED TELESCOPE - QUANTUM SEARCH v2.0
          -- ═══════════════════════════════════════════════════════════════════════
          TelescopeBorder = { fg = "#7B68EE", bg = "NONE" },
          TelescopePromptBorder = { fg = "#FF79C6", bg = "NONE" },
          TelescopeResultsBorder = { fg = "#7B68EE", bg = "NONE" },
          TelescopePreviewBorder = { fg = "#7B68EE", bg = "NONE" },
          TelescopeSelectionCaret = { fg = "#FF79C6", bg = "NONE" },
          TelescopeSelection = { bg = "#313244", fg = "#CDD6F4" },
          TelescopeMatching = { fg = "#50FA7B", bold = true },
          TelescopePromptTitle = { fg = "#FF79C6", bold = true },
          TelescopeResultsTitle = { fg = "#7B68EE", bold = true },
          TelescopePreviewTitle = { fg = "#50FA7B", bold = true },
          TelescopePromptNormal = { bg = "#1E1E2E" },
          TelescopeResultsNormal = { bg = "#1E1E2E" },
          TelescopePreviewNormal = { bg = "#1E1E2E" },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 📝 ENHANCED COMPLETION - NEURAL ENGINE v2.0
          -- ═══════════════════════════════════════════════════════════════════════
          CmpBorder = { fg = "#7B68EE", bg = "NONE" },
          CmpDocBorder = { fg = "#4DABF7", bg = "NONE" },
          CmpItemKind = { fg = "#BD93F9" },
          CmpItemMenu = { fg = "#6C7086" },
          CmpItemAbbr = { fg = "#CDD6F4" },
          CmpItemAbbrMatch = { fg = "#50FA7B", bold = true },
          CmpItemAbbrMatchFuzzy = { fg = "#50FA7B", bold = true },

          -- Completion kind highlights
          CmpItemKindText = { fg = "#CDD6F4" },
          CmpItemKindMethod = { fg = "#8BE9FD" },
          CmpItemKindFunction = { fg = "#8BE9FD" },
          CmpItemKindConstructor = { fg = "#FFB86C" },
          CmpItemKindField = { fg = "#50FA7B" },
          CmpItemKindVariable = { fg = "#F8F8F2" },
          CmpItemKindClass = { fg = "#FFB86C" },
          CmpItemKindInterface = { fg = "#FFB86C" },
          CmpItemKindModule = { fg = "#BD93F9" },
          CmpItemKindProperty = { fg = "#50FA7B" },
          CmpItemKindUnit = { fg = "#F1FA8C" },
          CmpItemKindValue = { fg = "#BD93F9" },
          CmpItemKindEnum = { fg = "#FFB86C" },
          CmpItemKindKeyword = { fg = "#FF79C6" },
          CmpItemKindSnippet = { fg = "#BD93F9" },
          CmpItemKindColor = { fg = "#F1FA8C" },
          CmpItemKindFile = { fg = "#8BE9FD" },
          CmpItemKindReference = { fg = "#7B68EE" },
          CmpItemKindFolder = { fg = "#8BE9FD" },
          CmpItemKindEnumMember = { fg = "#50FA7B" },
          CmpItemKindConstant = { fg = "#BD93F9" },
          CmpItemKindStruct = { fg = "#FFB86C" },
          CmpItemKindEvent = { fg = "#FF79C6" },
          CmpItemKindOperator = { fg = "#FF79C6" },
          CmpItemKindTypeParameter = { fg = "#BD93F9" },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 🌿 ENHANCED GIT INTEGRATION
          -- ═══════════════════════════════════════════════════════════════════════
          GitSignsAdd = { fg = "#50FA7B" },
          GitSignsChange = { fg = "#FFB86C" },
          GitSignsDelete = { fg = "#FF5555" },
          GitSignsAddInline = { bg = "#50FA7B", fg = "#16213E" },
          GitSignsChangeInline = { bg = "#FFB86C", fg = "#16213E" },
          GitSignsDeleteInline = { bg = "#FF5555", fg = "#16213E" },
          GitSignsAddLn = { bg = "#193B2D" },
          GitSignsChangeLn = { bg = "#2D2416" },
          GitSignsDeleteLn = { bg = "#2D1B1F" },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 🚨 ENHANCED DIAGNOSTICS SYSTEM
          -- ═══════════════════════════════════════════════════════════════════════
          DiagnosticError = { fg = "#FF5555" },
          DiagnosticWarn = { fg = "#FFB86C" },
          DiagnosticInfo = { fg = "#8BE9FD" },
          DiagnosticHint = { fg = "#BD93F9" },
          DiagnosticOk = { fg = "#50FA7B" },
          DiagnosticVirtualTextError = { fg = "#FF5555", bg = "#2D1B1F" },
          DiagnosticVirtualTextWarn = { fg = "#FFB86C", bg = "#2D2416" },
          DiagnosticVirtualTextInfo = { fg = "#8BE9FD", bg = "#192A2D" },
          DiagnosticVirtualTextHint = { fg = "#BD93F9", bg = "#1E1B2D" },
          DiagnosticVirtualTextOk = { fg = "#50FA7B", bg = "#193B2D" },
          DiagnosticUnderlineError = { underline = true, sp = "#FF5555" },
          DiagnosticUnderlineWarn = { underline = true, sp = "#FFB86C" },
          DiagnosticUnderlineInfo = { underline = true, sp = "#8BE9FD" },
          DiagnosticUnderlineHint = { underline = true, sp = "#BD93F9" },
          DiagnosticUnderlineOk = { underline = true, sp = "#50FA7B" },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 🌐 ENHANCED TREE EXPLORER
          -- ═══════════════════════════════════════════════════════════════════════
          NvimTreeNormal = { bg = "#1A1A2E" },
          NvimTreeWinSeparator = { fg = "#313244", bg = "#1A1A2E" },
          NvimTreeRootFolder = { fg = "#BD93F9", bold = true },
          NvimTreeFolderName = { fg = "#8BE9FD" },
          NvimTreeFolderIcon = { fg = "#FFB86C" },
          NvimTreeOpenedFolderName = { fg = "#50FA7B", bold = true },
          NvimTreeSpecialFile = { fg = "#FF79C6", underline = true },
          NvimTreeExecFile = { fg = "#50FA7B", bold = true },
          NvimTreeImageFile = { fg = "#BD93F9" },
          NvimTreeMarkdownFile = { fg = "#8BE9FD" },
          NvimTreeIndentMarker = { fg = "#313244" },
          NvimTreeSymlink = { fg = "#FF79C6", italic = true },
          NvimTreeGitDirty = { fg = "#FFB86C" },
          NvimTreeGitStaged = { fg = "#50FA7B" },
          NvimTreeGitMerge = { fg = "#FF79C6" },
          NvimTreeGitRenamed = { fg = "#BD93F9" },
          NvimTreeGitNew = { fg = "#50FA7B" },
          NvimTreeGitDeleted = { fg = "#FF5555" },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 📑 ENHANCED BUFFER TABS
          -- ═══════════════════════════════════════════════════════════════════════
          BufferLineFill = { bg = "#11111B" },
          BufferLineBackground = { fg = "#6C7086", bg = "#1E1E2E" },
          BufferLineBufferSelected = { fg = "#CDD6F4", bg = "#313244", bold = true },
          BufferLineTab = { fg = "#6C7086", bg = "#1E1E2E" },
          BufferLineTabSelected = { fg = "#CDD6F4", bg = "#313244" },
          BufferLineTabClose = { fg = "#FF5555", bg = "#1E1E2E" },
          BufferLineIndicatorSelected = { fg = "#7B68EE", bg = "#313244" },
          BufferLineCloseButton = { fg = "#6C7086", bg = "#1E1E2E" },
          BufferLineCloseButtonSelected = { fg = "#FF5555", bg = "#313244" },
          BufferLineModified = { fg = "#FFB86C", bg = "#1E1E2E" },
          BufferLineModifiedSelected = { fg = "#FFB86C", bg = "#313244" },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 🔳 ENHANCED INDENTATION GUIDES
          -- ═══════════════════════════════════════════════════════════════════════
          IndentBlanklineChar = { fg = "#313244" },
          IndentBlanklineContextChar = { fg = "#7B68EE" },
          IndentBlanklineContextStart = { underline = true, sp = "#7B68EE" },
          IblIndent = { fg = "#313244" },
          IblScope = { fg = "#7B68EE" },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 🎯 ENHANCED WHICH-KEY COMMAND CENTER
          -- ═══════════════════════════════════════════════════════════════════════
          WhichKey = { fg = "#FF79C6", bold = true },
          WhichKeyGroup = { fg = "#8BE9FD" },
          WhichKeyDesc = { fg = "#CDD6F4" },
          WhichKeySeperator = { fg = "#6C7086" },
          WhichKeyFloat = { bg = "#1E1E2E" },
          WhichKeyBorder = { fg = "#7B68EE", bg = "#1E1E2E" },
          WhichKeyValue = { fg = "#BD93F9" },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 🔮 ENHANCED ADDITIONAL UI ELEMENTS
          -- ═══════════════════════════════════════════════════════════════════════
          WinSeparator = { fg = "#313244" },
          LineNr = { fg = "#6C7086" },
          CursorLineNr = { fg = "#FF79C6", bold = true },
          CursorLine = { bg = "#1A1A2E" },
          CursorColumn = { bg = "#1A1A2E" },
          ColorColumn = { bg = "#1A1A2E" },
          Visual = { bg = "#313244" },
          VisualNOS = { bg = "#313244" },
          Search = { bg = "#FFB86C", fg = "#16213E" },
          IncSearch = { bg = "#FF79C6", fg = "#16213E" },
          CurSearch = { bg = "#50FA7B", fg = "#16213E" },
          MatchParen = { bg = "#313244", bold = true },
          Substitute = { bg = "#BD93F9", fg = "#16213E" },

          -- Fold colors
          Folded = { fg = "#6C7086", bg = "#1A1A2E", italic = true },
          FoldColumn = { fg = "#6C7086", bg = "NONE" },

          -- Sign column
          SignColumn = { bg = "NONE" },
          SignColumnSB = { bg = "#1A1A2E" },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 🤖 ENHANCED COPILOT INTEGRATION
          -- ═══════════════════════════════════════════════════════════════════════
          CopilotSuggestion = { fg = "#6C7086", italic = true },
          CopilotAnnotation = { fg = "#7B68EE", italic = true },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 📢 NOTIFICATION ENHANCEMENTS
          -- ═══════════════════════════════════════════════════════════════════════
          NotifyBackground = { bg = "#1E1E2E" },
          NotifyBorder = { fg = "#7B68EE" },
          NotifyERRORBorder = { fg = "#FF5555" },
          NotifyWARNBorder = { fg = "#FFB86C" },
          NotifyINFOBorder = { fg = "#8BE9FD" },
          NotifyDEBUGBorder = { fg = "#BD93F9" },
          NotifyTRACEBorder = { fg = "#50FA7B" },
          NotifyERRORTitle = { fg = "#FF5555", bold = true },
          NotifyWARNTitle = { fg = "#FFB86C", bold = true },
          NotifyINFOTitle = { fg = "#8BE9FD", bold = true },
          NotifyDEBUGTitle = { fg = "#BD93F9", bold = true },
          NotifyTRACETitle = { fg = "#50FA7B", bold = true },

          -- ═══════════════════════════════════════════════════════════════════════
          -- 🔧 TROUBLE ENHANCED
          -- ═══════════════════════════════════════════════════════════════════════
          TroubleText = { fg = "#CDD6F4" },
          TroubleCount = { fg = "#FF79C6", bg = "#313244" },
          TroubleNormal = { fg = "#CDD6F4", bg = "#1E1E2E" },
        },
      },
    },
    config = function(_, opts)
      require("cyberdream").setup(opts)
      vim.cmd("colorscheme cyberdream")

      -- ═════════════════════════════════════════════════════════════════════════
      -- 🎨 ENHANCED CUSTOM HIGHLIGHTS
      -- ═════════════════════════════════════════════════════════════════════════

      -- Additional custom highlights for perfect integration
      vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#1E1E2E" })
      vim.api.nvim_set_hl(0, "NotifyBorder", { fg = "#7B68EE" })

      -- Enhanced transparency support for Kitty
      if vim.env.TERM == "xterm-kitty" or vim.env.KITTY_WINDOW_ID then
        vim.api.nvim_set_hl(0, "Normal", { fg = "#F8F8F2", bg = "NONE" })
        vim.api.nvim_set_hl(0, "NormalNC", { fg = "#F8F8F2", bg = "NONE" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#6C7086", bg = "NONE" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FF79C6", bg = "NONE", bold = true })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#16213E", bg = "NONE" })
      end

      -- Terminal colors for perfect integration
      vim.g.terminal_color_0 = "#1E1E2E"
      vim.g.terminal_color_1 = "#FF5555"
      vim.g.terminal_color_2 = "#50FA7B"
      vim.g.terminal_color_3 = "#F1FA8C"
      vim.g.terminal_color_4 = "#8BE9FD"
      vim.g.terminal_color_5 = "#FF79C6"
      vim.g.terminal_color_6 = "#7B68EE"
      vim.g.terminal_color_7 = "#F8F8F2"
      vim.g.terminal_color_8 = "#313244"
      vim.g.terminal_color_9 = "#FF6E6E"
      vim.g.terminal_color_10 = "#69FF94"
      vim.g.terminal_color_11 = "#FFFFA5"
      vim.g.terminal_color_12 = "#94EDFF"
      vim.g.terminal_color_13 = "#FF92DF"
      vim.g.terminal_color_14 = "#9580FF"
      vim.g.terminal_color_15 = "#FFFFFF"

      -- Success notification with neural styling
      -- vim.defer_fn(function()
      --   vim.notify("🚀 KORA Neural Matrix v2.0 Activated", vim.log.levels.INFO, {
      --     title = "NEURAL INTERFACE",
      --     timeout = 2000,
      --   })
      -- end, 200)
    end,
  },
}

-- ══════════════════════════════════════════════════════════════════════════
-- EXEMPLOS DE USO - COLORSCHEME.LUA
-- ══════════════════════════════════════════════════════════════════════════
-- Este arquivo configura o tema visual do sistema:
--
-- TEMA PRINCIPAL:
-- cyberdream                  -- Tema cyberpunk com cores neon purple
--
-- COMANDOS PARA TESTAR CORES:
-- :colorscheme cyberdream     -- Aplicar tema
-- :hi                         -- Listar todas as cores
-- :hi Normal                  -- Ver cor do texto normal
-- :hi Comment                 -- Ver cor dos comentários
--
-- PERSONALIZAÇÃO:
-- transparent = true          -- Fundo transparente
-- italic_comments = true      -- Comentários em itálico
-- borderless_telescope = true -- Telescope sem bordas
--
-- CORES PRINCIPAIS DO SISTEMA:
-- #FF79C6                     -- Rosa neon (keywords, prompts)
-- #7B68EE                     -- Roxo médio (comentários, bordas)
-- #50FA7B                     -- Verde neon (strings, sucesso)
-- #8BE9FD                     -- Azul ciano (funções, folders)
-- #FFB86C                     -- Laranja (tipos, avisos)
-- #BD93F9                     -- Roxo claro (constantes, builtin)
-- #F8F8F2                     -- Branco (texto normal)
-- #6C7086                     -- Cinza (números de linha, menu)
--
-- COMPONENTES ESTILIZADOS:
-- - Telescope (busca de arquivos)
-- - Completion menu (autocompletar)
-- - Git signs (indicadores git)
-- - LSP diagnostics (erros/avisos)
-- - Tree explorer (navegador arquivos)
-- - Buffer tabs (abas de arquivos)
-- - Which-key (guia de comandos)
-- - Status line (barra de status)
--
-- Para verificar se as cores estão corretas:
-- :Telescope colorscheme      -- Testar outros temas
-- :checkhealth                -- Verificar problemas de cor
