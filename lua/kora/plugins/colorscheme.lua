local M = {}

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- CYBERSYNTH NEURAL PALETTE - Core color definitions
-- ═══════════════════════════════════════════════════════════════════════════════════════════════
local synth_palette = {
  -- Base layers - The noir foundation
  void = "#0B0A12",      -- The digital abyss
  surface = "#141127",    -- Neural substrate
  shadow = "#16213E",     -- Primary background
  whisper = "#1A1A2E",   -- Subtle UI elements
  ghost = "#1E1E2E",     -- Floating elements
  
  -- Neon spectrum - The electric soul
  neon_pink = "#FF2D95",     -- Primary accent
  neon_magenta = "#FF6EC7",  -- Selection highlight
  neon_cyan = "#00F0FF",     -- Function calls
  neon_blue = "#00CFFF",     -- Information
  neon_purple = "#9A6CFF",   -- Keywords
  neon_yellow = "#FFD166",   -- Warnings
  neon_green = "#7CFF00",    -- Success states
  
  -- Classic spectrum - Enhanced originals
  dracula_pink = "#FF79C6",
  dracula_purple = "#BD93F9",
  dracula_cyan = "#8BE9FD",
  dracula_green = "#50FA7B",
  dracula_orange = "#FFB86C",
  dracula_yellow = "#F1FA8C",
  dracula_red = "#FF5555",
  
  -- Text hierarchy
  text_primary = "#F8F8F2",
  text_secondary = "#CDD6F4",
  text_muted = "#6C7086",
  text_disabled = "#313244",
  
  -- LSP semantic enhancement
  medium_slate_blue = "#7B68EE",
}

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- NEURAL SYNTAX MATRIX - Enhanced treesitter + LSP semantic tokens
-- ═══════════════════════════════════════════════════════════════════════════════════════════════
local function get_syntax_highlights(palette)
  return {
    -- Core language constructs
    Comment = { fg = palette.medium_slate_blue, italic = true },
    ["@comment"] = { fg = palette.medium_slate_blue, italic = true },
    
    -- Keywords 
    ["@keyword"] = { fg = palette.dracula_pink, italic = true },
    ["@keyword.function"] = { fg = palette.dracula_pink, italic = true },
    ["@keyword.return"] = { fg = palette.dracula_pink, italic = true },
    ["@keyword.operator"] = { fg = palette.dracula_pink, italic = false },
    
    -- Strings and literals - The incantations
    ["@string"] = { fg = palette.dracula_green },
    ["@string.escape"] = { fg = palette.dracula_yellow, bold = true },
    
    -- Variables and identifiers
    ["@variable"] = { fg = palette.text_primary },
    ["@variable.builtin"] = { fg = palette.dracula_purple, italic = true },
    
    -- Functions - The neural pathways
    ["@function"] = { fg = palette.dracula_cyan, italic = false },
    ["@function.builtin"] = { fg = palette.dracula_cyan, italic = true },
    ["@function.call"] = { fg = palette.dracula_cyan },
    ["@method"] = { fg = palette.dracula_cyan },
    ["@method.call"] = { fg = palette.dracula_cyan },
    
    -- Types - The data architects
    ["@type"] = { fg = palette.dracula_orange, italic = true },
    ["@type.builtin"] = { fg = palette.dracula_orange, italic = true },
    ["@type.definition"] = { fg = palette.dracula_orange, bold = true },
    
    -- Constants and macros
    ["@constant"] = { fg = palette.dracula_purple },
    ["@constant.builtin"] = { fg = palette.dracula_purple, italic = true },
    ["@constant.macro"] = { fg = palette.dracula_purple, bold = true },
    
    -- Operators and punctuation
    ["@operator"] = { fg = palette.dracula_pink },
    ["@punctuation"] = { fg = palette.text_primary },
    ["@punctuation.bracket"] = { fg = palette.text_primary },
    ["@punctuation.delimiter"] = { fg = palette.text_primary },
    
    -- Markup and tags
    ["@tag"] = { fg = palette.dracula_pink },
    ["@tag.attribute"] = { fg = palette.dracula_green, italic = true },
    ["@tag.delimiter"] = { fg = palette.text_primary },
    
    -- Structure elements
    ["@namespace"] = { fg = palette.dracula_orange, italic = true },
    ["@property"] = { fg = palette.dracula_green },
    ["@field"] = { fg = palette.dracula_green },
    ["@parameter"] = { fg = palette.dracula_orange, italic = true },
    ["@label"] = { fg = palette.dracula_pink },
  }
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- LSP SEMANTIC ENHANCEMENTS - Neural language server integration
-- ═══════════════════════════════════════════════════════════════════════════════════════════════
local function get_lsp_highlights(palette)
  return {
    -- Semantic token types
    ["@lsp.type.class"] = { fg = palette.dracula_orange, italic = true },
    ["@lsp.type.interface"] = { fg = palette.dracula_orange, italic = true },
    ["@lsp.type.enum"] = { fg = palette.dracula_orange, italic = true },
    ["@lsp.type.struct"] = { fg = palette.dracula_orange, italic = true },
    ["@lsp.type.parameter"] = { fg = palette.dracula_orange, italic = true },
    ["@lsp.type.property"] = { fg = palette.dracula_green },
    ["@lsp.type.method"] = { fg = palette.dracula_cyan },
    ["@lsp.type.function"] = { fg = palette.dracula_cyan },
    ["@lsp.type.variable"] = { fg = palette.text_primary },
    ["@lsp.type.namespace"] = { fg = palette.dracula_orange, italic = true },
    ["@lsp.type.typeParameter"] = { fg = palette.dracula_purple, italic = true },
    
    -- Semantic modifiers
    ["@lsp.mod.readonly"] = { italic = true },
    ["@lsp.mod.deprecated"] = { strikethrough = true },
  }
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- UI NEURAL INTERFACE - Core editor elements
-- ═══════════════════════════════════════════════════════════════════════════════════════════════
local function get_ui_highlights(palette)
  return {
    -- Base interface
    Normal = { fg = palette.text_primary, bg = palette.shadow },
    NormalFloat = { bg = palette.ghost, fg = palette.text_secondary },
    FloatBorder = { fg = palette.medium_slate_blue, bg = palette.ghost },
    FloatTitle = { fg = palette.dracula_pink, bg = palette.ghost, bold = true },
    
    -- Popup menu
    Pmenu = { bg = palette.ghost, fg = palette.text_secondary },
    PmenuSel = { bg = palette.text_disabled, fg = palette.text_secondary, bold = true },
    PmenuSbar = { bg = palette.text_disabled },
    PmenuThumb = { bg = palette.medium_slate_blue },
    
    -- Status and window elements
    StatusLine = { fg = palette.text_secondary, bg = palette.ghost },
    StatusLineNC = { fg = palette.text_muted, bg = palette.ghost },
    WinBar = { fg = palette.text_secondary, bg = "NONE" },
    WinBarNC = { fg = palette.text_muted, bg = "NONE" },
    WinSeparator = { fg = palette.text_disabled },
    
    -- Cursor and selection
    CursorLine = { bg = palette.whisper },
    CursorColumn = { bg = palette.whisper },
    CursorLineNr = { fg = palette.dracula_pink, bold = true },
    LineNr = { fg = palette.text_muted },
    ColorColumn = { bg = palette.whisper },
    Visual = { bg = palette.text_disabled },
    
    -- Search highlighting
    Search = { bg = palette.dracula_orange, fg = palette.shadow },
    IncSearch = { bg = palette.dracula_pink, fg = palette.shadow },
    CurSearch = { bg = palette.dracula_green, fg = palette.shadow },
    
    -- Folding
    Folded = { fg = palette.text_muted, bg = palette.whisper, italic = true },
    FoldColumn = { fg = palette.text_muted, bg = "NONE" },
  }
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- PLUGIN ECOSYSTEM INTEGRATION - Third-party plugin theming
-- ═══════════════════════════════════════════════════════════════════════════════════════════════
local function get_plugin_highlights(palette)
  return {
    -- Telescope - The neural scope
    TelescopeBorder = { fg = palette.medium_slate_blue, bg = "NONE" },
    TelescopePromptBorder = { fg = palette.dracula_pink, bg = "NONE" },
    TelescopeResultsBorder = { fg = palette.medium_slate_blue, bg = "NONE" },
    TelescopePreviewBorder = { fg = palette.medium_slate_blue, bg = "NONE" },
    TelescopeSelectionCaret = { fg = palette.dracula_pink, bg = "NONE" },
    TelescopeSelection = { bg = palette.text_disabled, fg = palette.text_secondary },
    TelescopeMatching = { fg = palette.dracula_green, bold = true },
    TelescopePromptTitle = { fg = palette.dracula_pink, bold = true },
    TelescopeResultsTitle = { fg = palette.medium_slate_blue, bold = true },
    TelescopePreviewTitle = { fg = palette.dracula_green, bold = true },
    TelescopePromptNormal = { bg = palette.ghost },
    TelescopeResultsNormal = { bg = palette.ghost },
    TelescopePreviewNormal = { bg = palette.ghost },
    
    -- Completion - Neural suggestions
    CmpBorder = { fg = palette.medium_slate_blue, bg = "NONE" },
    CmpDocBorder = { fg = palette.neon_blue, bg = "NONE" },
    CmpItemKind = { fg = palette.dracula_purple },
    CmpItemMenu = { fg = palette.text_muted },
    CmpItemAbbr = { fg = palette.text_secondary },
    CmpItemAbbrMatch = { fg = palette.dracula_green, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = palette.dracula_green, bold = true },
    
    -- Git integration
    GitSignsAdd = { fg = palette.dracula_green },
    GitSignsChange = { fg = palette.dracula_orange },
    GitSignsDelete = { fg = palette.dracula_red },
    
    -- Diagnostics - Neural health monitoring
    DiagnosticError = { fg = palette.dracula_red },
    DiagnosticWarn = { fg = palette.dracula_orange },
    DiagnosticInfo = { fg = palette.dracula_cyan },
    DiagnosticHint = { fg = palette.dracula_purple },
    
    -- Tree explorer
    NvimTreeNormal = { bg = palette.whisper },
    NvimTreeWinSeparator = { fg = palette.text_disabled, bg = palette.whisper },
    
    -- Buffer line
    BufferLineFill = { bg = "#11111B" },
    BufferLineBackground = { fg = palette.text_muted, bg = palette.ghost },
    BufferLineBufferSelected = { fg = palette.text_secondary, bg = palette.text_disabled, bold = true },
    
    -- Indent guides
    IndentBlanklineChar = { fg = palette.text_disabled },
    IndentBlanklineContextChar = { fg = palette.medium_slate_blue },
    
    -- Which-key
    WhichKey = { fg = palette.dracula_pink, bold = true },
    WhichKeyGroup = { fg = palette.dracula_cyan },
    WhichKeyDesc = { fg = palette.text_secondary },
    
    -- AI assistants
    CopilotSuggestion = { fg = palette.text_muted, italic = true },
    CopilotAnnotation = { fg = palette.medium_slate_blue, italic = true },
    
    -- Notifications
    NotifyBackground = { bg = palette.ghost },
    NotifyBorder = { fg = palette.medium_slate_blue },
    
    -- Trouble
    TroubleText = { fg = palette.text_secondary },
    TroubleCount = { fg = palette.dracula_pink, bg = palette.text_disabled },
    TroubleNormal = { fg = palette.text_secondary, bg = palette.ghost },
  }
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- CYBERSYNTH NEURAL ENHANCEMENT SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════════════════════
local function apply_cybersynth_enhancements()
  local function set_highlight(name, opts)
    vim.api.nvim_set_hl(0, name, opts)
  end
  
  -- Neural enhancement overlays - subtle neon accents
  set_highlight("CursorLineNr", { fg = synth_palette.neon_pink, bold = true })
  set_highlight("PmenuSel", { bg = synth_palette.neon_magenta, fg = synth_palette.void, bold = true })
  set_highlight("TelescopeBorder", { fg = synth_palette.neon_purple })
  set_highlight("TelescopePromptBorder", { fg = synth_palette.neon_pink })
  set_highlight("CmpItemAbbrMatch", { fg = synth_palette.neon_cyan, bold = true })
  set_highlight("GitSignsAdd", { fg = synth_palette.neon_green })
  
  -- Terminal neural palette
  vim.g.terminal_color_0 = synth_palette.ghost
  vim.g.terminal_color_1 = synth_palette.neon_pink
  vim.g.terminal_color_2 = synth_palette.neon_green
  vim.g.terminal_color_3 = synth_palette.neon_yellow
  vim.g.terminal_color_4 = synth_palette.neon_cyan
  vim.g.terminal_color_5 = synth_palette.neon_magenta
  vim.g.terminal_color_6 = synth_palette.neon_purple
  vim.g.terminal_color_7 = synth_palette.text_primary
  vim.g.terminal_color_8 = synth_palette.text_muted
  vim.g.terminal_color_9 = synth_palette.dracula_red
  vim.g.terminal_color_10 = synth_palette.dracula_green
  vim.g.terminal_color_11 = synth_palette.dracula_yellow
  vim.g.terminal_color_12 = synth_palette.dracula_cyan
  vim.g.terminal_color_13 = synth_palette.dracula_purple
  vim.g.terminal_color_14 = synth_palette.dracula_orange
  vim.g.terminal_color_15 = synth_palette.text_primary
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- NEURAL COMMAND INTERFACE - User commands for theme manipulation
-- ═══════════════════════════════════════════════════════════════════════════════════════════════
local function create_kora_commands()
  -- CyberSynth intensity booster
  vim.api.nvim_create_user_command("KoraSynthBoost", function(opts)
    local mode = opts.args == "off" and "off" or "on"
    
    if mode == "on" then
      vim.api.nvim_set_hl(0, "Normal", { 
        fg = synth_palette.text_primary, 
        bg = synth_palette.void 
      })
      vim.api.nvim_set_hl(0, "PmenuSel", { 
        bg = synth_palette.neon_magenta, 
        fg = synth_palette.void, 
        bold = true 
      })
      vim.notify("⚡ KORA CyberSynth: NEURAL BOOST ACTIVATED", vim.log.levels.INFO)
    else
      vim.cmd("colorscheme cyberdream")
      vim.notify("🔌 KORA CyberSynth: NEURAL BOOST DEACTIVATED", vim.log.levels.INFO)
    end
  end, { 
    nargs = "?", 
    desc = "Toggle CyberSynth neural enhancement boost"
  })
  
  -- Theme switcher command
  vim.api.nvim_create_user_command("KoraTheme", function(opts)
    local themes = {
      cyber = "cyberdream",
      rose = "rose-pine",
      gruvbox = "gruvbox",
      kanagawa = "kanagawa",
      osaka = "solarized-osaka",
      tokyo = "tokyonight"
    }
    
    local theme = themes[opts.args] or opts.args or "cyberdream"
    vim.cmd("colorscheme " .. theme)
    
    if theme == "cyberdream" then
      apply_cybersynth_enhancements()
      vim.notify("🌆 KORA: CyberSynth neural matrix activated", vim.log.levels.INFO)
    else
      vim.notify("🎨 KORA: Theme switched to " .. theme, vim.log.levels.INFO)
    end
  end, {
    nargs = "?",
    complete = function() 
      return { "cyber", "rose", "gruvbox", "kanagawa", "osaka", "tokyo" }
    end,
    desc = "Switch between KORA colorschemes"
  })
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════════
-- PLUGIN CONFIGURATION MATRIX - LazyVim plugin specifications
-- ═══════════════════════════════════════════════════════════════════════════════════════════════
return {
  -- ═════════════════════════════════════════════════════════════════════════════════════════════
  -- PRIMARY: CYBERDREAM + CYBERSYNTH NEURAL ENHANCEMENT
  -- ═════════════════════════════════════════════════════════════════════════════════════════════
  {
    "scottmckendry/cyberdream.nvim",
    name = "cyberdream",
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
        highlights = vim.tbl_extend("force",
          get_syntax_highlights(synth_palette),
          get_lsp_highlights(synth_palette),
          get_ui_highlights(synth_palette),
          get_plugin_highlights(synth_palette)
        ),
      },
    },
    config = function(_, opts)
      require("cyberdream").setup(opts)
      vim.cmd("colorscheme cyberdream")
      
      -- Apply CyberSynth neural enhancements
      apply_cybersynth_enhancements()
      
      -- Initialize command interface
      create_kora_commands()
      
      vim.notify("⚡ KORA Neural Visual Matrix: ONLINE", vim.log.levels.INFO)
    end,
  },

  -- ═════════════════════════════════════════════════════════════════════════════════════════════
  -- ALTERNATIVE COLORSCHEMES - Fallback neural configurations
  -- ═════════════════════════════════════════════════════════════════════════════════════════════
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      variant = "main",
      dark_variant = "main",
      dim_inactive_windows = false,
      styles = {
        bold = true,
        italic = true,
        transparency = true,
      },
      highlight_groups = {
        Normal = { bg = "none" },
        ColorColumn = { bg = "#1C1C21" },
        Pmenu = { bg = "", fg = "#e0def4" },
        PmenuSel = { bg = "#4a465d", fg = "#f8f5f2" },
        PmenuSbar = { bg = "#191724" },
        PmenuThumb = { bg = "#9ccfd8" },
      },
    },
  },

  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = true,
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        comments = true,
        folds = false,
        operators = false,
      },
      transparent_mode = true,
    },
  },

  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = true,
    opts = {
      compile = false,
      commentStyle = { italic = true },
      transparent = true,
      terminalColors = true,
      overrides = function(colors)
        local theme = colors.theme
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptBorder = { fg = theme.ui.special },
        }
      end,
      theme = "wave",
    },
  },

  {
    "craftzdog/solarized-osaka.nvim",
    name = "solarized-osaka",
    lazy = true,
    opts = {
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
      },
      day_brightness = 0.3,
    },
  },

  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = true,
    opts = {
      style = "night",
      transparent = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
      },
    },
  },
}
