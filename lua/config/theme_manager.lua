-- Theme Manager
-- Noir/DedSec colorscheme with kitty/tmux integration
-- Inspired by nvpunk's theme_manager

local M = {}

-- Noir/DedSec color palette
M.noir_palette = {
  -- Base colors
  base00 = "#0a0a0f", -- Deepest black
  base01 = "#12121a", -- Slightly lighter
  base02 = "#1a1a24", -- UI background
  base03 = "#22222e", -- Selection/active
  base04 = "#3a4354", -- Borders / low contrast UI
  comment = "#7f8cab", -- Readable comments
  base05 = "#d7e2f0", -- Default text
  base06 = "#f0e8f8", -- Bright text
  base07 = "#ffffff", -- Brightest

  -- Accent colors (DedSec cyan/amber/red)
  cyan = "#00ffff",
  cyan_dim = "#00cccc",
  cyan_dark = "#008888",
  amber = "#ffbf00",
  amber_dim = "#cc9900",
  amber_dark = "#996600",
  red = "#ff2e63",
  red_dim = "#cc244d",
  red_dark = "#991a3a",

  -- Semantic colors
  green = "#00ff88",
  green_dim = "#00cc6e",
  yellow = "#ffcc00",
  orange = "#ff8800",
  blue = "#00aaff",
  purple = "#cc00ff",
  pink = "#ff00aa",

  -- Git
  git_add = "#00ff88",
  git_change = "#ffcc00",
  git_delete = "#ff2e63",
  git_modified = "#00aaff",

  -- Diagnostic
  error = "#ff2e63",
  warn = "#ffbf00",
  info = "#00aaff",
  hint = "#00ffff",
}

-- ASCII banner generation
M.banners = {
  wide = [[
 ▊  VEGA / DEDSEC PDE
 ▊  ┌────────────────────────────────────────────────────────────────────────────┐
 ▊  │  CODE FIRST  │  MISE RUNTIME  │  UV PYTHON  │  TMUX BRIDGE  │  OBSIDIAN  │
 ▊  └────────────────────────────────────────────────────────────────────────────┘
 ▊  01010110 01000101 01000111 01000001  // signal clean // focus locked
]],
  compact = [[
 ▊ VEGA DEDSEC PDE
 ▊ ── code first · mise · uv · tmux · obsidian ──
]],
  tiny = [[
 ▊ VEGA
 ▊ DEDSEC PDE
]],
  -- Snacks dashboard header (compact, tactical)
  snacks_header = [[
  ▄▄▄▄    ▄▄▄      ▄▄▄█████▓
 ▓█████▄ ▒████▄    ▓  ██▒ ▓▒
 ▒██▒ ▄██▒██  ▀█▄  ▒ ▓██░ ▒░
 ▒██░█▀  ░██▄▄▄▄██ ░ ▓██▓ ░
 ░▓█  ▀█▓ ▓█   ▓██▒  ▒██▒ ░
 ░▒▓███▀▒ ▒▒   ▓▒█░  ▒ ░░
   ░▒   ▒   ▒   ▒▒ ░    ░
    ░   ░   ░   ▒     ░
 DEDSEC // VEGA NODE
]],
}

-- Get banner based on width
function M.get_banner(width)
  width = width or vim.o.columns
  if width < 50 then
    return M.banners.tiny
  elseif width < 92 then
    return M.banners.compact
  else
    return M.banners.wide
  end
end

-- Generate highlights from palette
local function generate_highlights(palette)
  local hl = {}

  -- Base UI
  hl.Normal = { fg = palette.base05, bg = palette.base00 }
  hl.NormalFloat = { fg = palette.base05, bg = palette.base01 }
  hl.FloatBorder = { fg = palette.cyan_dim, bg = palette.base01 }
  hl.FloatTitle = { fg = palette.cyan, bg = palette.base01, bold = true }
  hl.FloatFooter = { fg = palette.base04, bg = palette.base01 }

  -- Cursor
  hl.Cursor = { fg = palette.base00, bg = palette.cyan }
  hl.CursorLine = { bg = palette.base02 }
  hl.CursorLineNr = { fg = palette.cyan, bold = true }
  hl.CursorColumn = { bg = palette.base02 }
  hl.ColorColumn = { bg = palette.base02 }

  -- Line numbers
  hl.LineNr = { fg = palette.base04 }
  hl.LineNrAbove = { fg = palette.base04 }
  hl.LineNrBelow = { fg = palette.base04 }

  -- Selection
  hl.Visual = { bg = palette.base03 }
  hl.VisualNOS = { bg = palette.base03 }
  hl.Search = { fg = palette.base00, bg = palette.amber }
  hl.IncSearch = { fg = palette.base00, bg = palette.cyan }
  hl.Substitute = { fg = palette.base00, bg = palette.red }
  hl.MatchParen = { fg = palette.cyan, bg = palette.base03, bold = true, underline = true }

  -- UI elements
  hl.VertSplit = { fg = palette.base04, bg = "NONE" }
  hl.WinSeparator = { fg = palette.cyan_dim, bg = "NONE" }
  hl.WinBar = { fg = palette.base05, bg = palette.base01 }
  hl.WinBarNC = { fg = palette.base04, bg = palette.base01 }
  hl.StatusLine = { fg = palette.base05, bg = palette.base01 }
  hl.StatusLineNC = { fg = palette.base04, bg = palette.base00 }
  hl.TabLine = { fg = palette.base04, bg = palette.base01 }
  hl.TabLineFill = { bg = palette.base01 }
  hl.TabLineSel = { fg = palette.cyan, bg = palette.base02, bold = true }

  -- Popup menu
  hl.Pmenu = { fg = palette.base05, bg = palette.base01 }
  hl.PmenuSel = { fg = palette.base00, bg = palette.cyan }
  hl.PmenuSbar = { bg = palette.base02 }
  hl.PmenuThumb = { bg = palette.cyan }
  hl.PmenuKind = { fg = palette.blue }
  hl.PmenuKindSel = { fg = palette.base00, bg = palette.blue }
  hl.PmenuExtra = { fg = palette.base04 }
  hl.PmenuExtraSel = { fg = palette.base03 }

  -- Folds
  hl.Folded = { fg = palette.base04, bg = palette.base01 }
  hl.FoldColumn = { fg = palette.base04, bg = palette.base00 }

  -- Tabs/Buffers
  hl.TabLine = { fg = palette.base04, bg = palette.base01 }
  hl.TabLineFill = { bg = palette.base00 }
  hl.TabLineSel = { fg = palette.cyan, bg = palette.base02, bold = true }

  -- Syntax
  hl.Comment = { fg = palette.comment, italic = true }
  hl.Constant = { fg = palette.cyan }
  hl.String = { fg = palette.green }
  hl.Character = { fg = palette.green }
  hl.Number = { fg = palette.cyan }
  hl.Boolean = { fg = palette.cyan, bold = true }
  hl.Float = { fg = palette.cyan }
  hl.Identifier = { fg = palette.base05 }
  hl.Function = { fg = palette.blue, bold = true }
  hl.Statement = { fg = palette.red, bold = true }
  hl.Conditional = { fg = palette.red, bold = true }
  hl.Repeat = { fg = palette.red, bold = true }
  hl.Label = { fg = palette.red }
  hl.Operator = { fg = palette.red }
  hl.Keyword = { fg = palette.red, bold = true }
  hl.Exception = { fg = palette.red, bold = true }
  hl.PreProc = { fg = palette.purple }
  hl.Include = { fg = palette.purple }
  hl.Define = { fg = palette.purple }
  hl.Macro = { fg = palette.purple }
  hl.Type = { fg = palette.blue }
  hl.StorageClass = { fg = palette.blue }
  hl.Structure = { fg = palette.blue }
  hl.Typedef = { fg = palette.blue }
  hl.Special = { fg = palette.cyan }
  hl.SpecialChar = { fg = palette.cyan }
  hl.Tag = { fg = palette.red }
  hl.Delimiter = { fg = palette.base04 }
  hl.SpecialComment = { fg = palette.comment, italic = true }
  hl.Debug = { fg = palette.red }
  hl.Underlined = { underline = true }
  hl.Ignore = { fg = palette.base03 }
  hl.Error = { fg = palette.red, bold = true }
  hl.Todo = { fg = palette.amber, bg = palette.base00, bold = true }

  -- Diagnostics
  hl.DiagnosticError = { fg = palette.error }
  hl.DiagnosticWarn = { fg = palette.warn }
  hl.DiagnosticInfo = { fg = palette.info }
  hl.DiagnosticHint = { fg = palette.hint }
  hl.DiagnosticVirtualTextError = { fg = palette.error, bg = palette.base00 }
  hl.DiagnosticVirtualTextWarn = { fg = palette.warn, bg = palette.base00 }
  hl.DiagnosticVirtualTextInfo = { fg = palette.info, bg = palette.base00 }
  hl.DiagnosticVirtualTextHint = { fg = palette.hint, bg = palette.base00 }
  hl.DiagnosticUnderlineError = { undercurl = true, sp = palette.error }
  hl.DiagnosticUnderlineWarn = { undercurl = true, sp = palette.warn }
  hl.DiagnosticUnderlineInfo = { undercurl = true, sp = palette.info }
  hl.DiagnosticUnderlineHint = { undercurl = true, sp = palette.hint }
  hl.DiagnosticSignError = { fg = palette.error }
  hl.DiagnosticSignWarn = { fg = palette.warn }
  hl.DiagnosticSignInfo = { fg = palette.info }
  hl.DiagnosticSignHint = { fg = palette.hint }
  hl.DiagnosticFloatingError = { fg = palette.error }
  hl.DiagnosticFloatingWarn = { fg = palette.warn }
  hl.DiagnosticFloatingInfo = { fg = palette.info }
  hl.DiagnosticFloatingHint = { fg = palette.hint }

  -- LSP
  hl.LspReferenceText = { bg = palette.base03 }
  hl.LspReferenceRead = { bg = palette.base03 }
  hl.LspReferenceWrite = { bg = palette.base03 }
  hl.LspCodeLens = { fg = palette.base04 }
  hl.LspSignatureActiveParameter = { fg = palette.cyan, bold = true }
  hl.LspInlayHint = { fg = palette.base04, bg = palette.base01 }

  -- Treesitter
  hl["@variable"] = { fg = palette.base05 }
  hl["@variable.builtin"] = { fg = palette.red }
  hl["@variable.parameter"] = { fg = palette.blue }
  hl["@variable.member"] = { fg = palette.blue }
  hl["@constant"] = { fg = palette.cyan }
  hl["@constant.builtin"] = { fg = palette.cyan, bold = true }
  hl["@constant.macro"] = { fg = palette.purple }
  hl["@module"] = { fg = palette.purple }
  hl["@module.builtin"] = { fg = palette.purple }
  hl["@label"] = { fg = palette.red }
  hl["@string"] = { fg = palette.green }
  hl["@string.escape"] = { fg = palette.cyan }
  hl["@string.special"] = { fg = palette.cyan }
  hl["@character"] = { fg = palette.green }
  hl["@character.special"] = { fg = palette.cyan }
  hl["@number"] = { fg = palette.cyan }
  hl["@number.float"] = { fg = palette.cyan }
  hl["@boolean"] = { fg = palette.cyan, bold = true }
  hl["@type"] = { fg = palette.blue }
  hl["@type.builtin"] = { fg = palette.blue, bold = true }
  hl["@attribute"] = { fg = palette.purple }
  hl["@property"] = { fg = palette.blue }
  hl["@function"] = { fg = palette.blue, bold = true }
  hl["@function.builtin"] = { fg = palette.blue, bold = true }
  hl["@function.call"] = { fg = palette.blue }
  hl["@function.macro"] = { fg = palette.purple }
  hl["@function.method"] = { fg = palette.blue }
  hl["@constructor"] = { fg = palette.blue }
  hl["@operator"] = { fg = palette.red }
  hl["@keyword"] = { fg = palette.red, bold = true }
  hl["@keyword.coroutine"] = { fg = palette.red }
  hl["@keyword.function"] = { fg = palette.red }
  hl["@keyword.operator"] = { fg = palette.red }
  hl["@keyword.import"] = { fg = palette.purple, italic = true }
  hl["@keyword.export"] = { fg = palette.purple, italic = true }
  hl["@keyword.type"] = { fg = palette.blue, italic = true }
  hl["@keyword.modifier"] = { fg = palette.red, italic = true }
  hl["@keyword.repeat"] = { fg = palette.red }
  hl["@keyword.return"] = { fg = palette.red }
  hl["@keyword.debug"] = { fg = palette.red }
  hl["@keyword.exception"] = { fg = palette.red }
  hl["@keyword.conditional"] = { fg = palette.red }
  hl["@keyword.conditional.ternary"] = { fg = palette.red }
  hl["@keyword.directive"] = { fg = palette.purple }
  hl["@keyword.directive.define"] = { fg = palette.purple }
  hl["@punctuation.delimiter"] = { fg = palette.base04 }
  hl["@punctuation.bracket"] = { fg = palette.base04 }
  hl["@punctuation.special"] = { fg = palette.cyan }
  hl["@comment"] = { fg = palette.comment, italic = true }
  hl["@comment.documentation"] = { fg = palette.comment, italic = true }
  hl["@comment.error"] = { fg = palette.red }
  hl["@comment.warning"] = { fg = palette.warn }
  hl["@comment.todo"] = { fg = palette.amber, bold = true }
  hl["@comment.note"] = { fg = palette.info }
  hl["@markup.strong"] = { bold = true }
  hl["@markup.italic"] = { italic = true }
  hl["@markup.strikethrough"] = { strikethrough = true }
  hl["@markup.underline"] = { underline = true }
  hl["@markup.heading"] = { fg = palette.cyan, bold = true, italic = true }
  hl["@markup.heading.1"] = { fg = palette.cyan, bold = true, italic = true }
  hl["@markup.heading.2"] = { fg = palette.blue, bold = true, italic = true }
  hl["@markup.heading.3"] = { fg = palette.purple, bold = true, italic = true }
  hl["@markup.heading.4"] = { fg = palette.purple, bold = true, italic = true }
  hl["@markup.heading.5"] = { fg = palette.pink, bold = true, italic = true }
  hl["@markup.heading.6"] = { fg = palette.pink, italic = true }
  hl["@markup.link"] = { fg = palette.blue, underline = true }
  hl["@markup.link.url"] = { fg = palette.cyan, underline = true }
  hl["@markup.raw"] = { fg = palette.green }
  hl["@markup.math"] = { fg = palette.purple }
  hl["@markup.environment"] = { fg = palette.purple }
  hl["@markup.environment.name"] = { fg = palette.blue }
  hl["@diff.plus"] = { fg = palette.green }
  hl["@diff.minus"] = { fg = palette.red }
  hl["@diff.delta"] = { fg = palette.warn }

  -- VSCode-like font-style rules adapted to Tree-sitter/LSP captures.
  hl["@type"] = { fg = palette.blue, bold = true }
  hl["@type.builtin"] = { fg = palette.blue, italic = true }
  hl["@lsp.type.class"] = { fg = palette.blue, bold = true }
  hl["@lsp.type.interface"] = { fg = palette.cyan, bold = true }
  hl["@tag.attribute"] = { fg = palette.purple, italic = true }
  hl["@markup.raw.markdown_inline"] = { fg = palette.green, italic = true }
  hl["@number"] = { fg = palette.cyan }
  hl["@number.float"] = { fg = palette.cyan }
  hl["@constant.builtin"] = { fg = palette.cyan }

  -- Git
  hl.GitSignsAdd = { fg = palette.git_add }
  hl.GitSignsChange = { fg = palette.git_change }
  hl.GitSignsDelete = { fg = palette.git_delete }
  hl.GitSignsCurrentLineBlame = { fg = palette.base04 }

  -- UI plugins
  hl.WhichKey = { fg = palette.cyan }
  hl.WhichKeyGroup = { fg = palette.cyan }
  hl.WhichKeyDesc = { fg = palette.base05 }
  hl.WhichKeyValue = { fg = palette.base04 }
  hl.WhichKeySeparator = { fg = palette.base04 }
  hl.WhichKeyFloat = { bg = palette.base01 }
  hl.WhichKeyBorder = { fg = palette.cyan_dim, bg = palette.base01 }

  hl.TelescopeNormal = { fg = palette.base05, bg = palette.base01 }
  hl.TelescopeBorder = { fg = palette.cyan_dim, bg = palette.base01 }
  hl.TelescopePromptNormal = { fg = palette.base05, bg = palette.base02 }
  hl.TelescopePromptBorder = { fg = palette.cyan, bg = palette.base02 }
  hl.TelescopePromptTitle = { fg = palette.cyan, bg = palette.base02, bold = true }
  hl.TelescopeResultsTitle = { fg = palette.cyan, bg = palette.base01, bold = true }
  hl.TelescopePreviewTitle = { fg = palette.cyan, bg = palette.base01, bold = true }
  hl.TelescopeSelection = { bg = palette.base03 }
  hl.TelescopeSelectionCaret = { fg = palette.cyan }
  hl.TelescopeMatching = { fg = palette.cyan, bold = true }
  hl.TelescopePromptPrefix = { fg = palette.cyan }

  hl.SnacksPickerNormal = { fg = palette.base05, bg = palette.base01 }
  hl.SnacksPickerBorder = { fg = palette.cyan_dim, bg = palette.base01 }
  hl.SnacksPickerInput = { fg = palette.base05, bg = palette.base02 }
  hl.SnacksPickerInputBorder = { fg = palette.cyan, bg = palette.base02 }
  hl.SnacksPickerInputTitle = { fg = palette.cyan, bg = palette.base02, bold = true }
  hl.SnacksPickerBoxTitle = { fg = palette.cyan, bg = palette.base01, bold = true }
  hl.SnacksPickerSelected = { bg = palette.base03 }
  hl.SnacksPickerToggle = { fg = palette.cyan, bold = true }

  -- Snacks Dashboard (Stealth Cockpit)
  hl.SnacksDashboardHeader = { fg = palette.cyan, bold = true }
  hl.SnacksDashboardIcon = { fg = palette.red }
  hl.SnacksDashboardDesc = { fg = palette.base05 }
  hl.SnacksDashboardKey = { fg = palette.green, bold = true }
  hl.SnacksDashboardFooter = { fg = palette.base04, italic = true }
  hl.SnacksDashboardNormal = { fg = palette.base05, bg = palette.base00 }
  hl.SnacksDashboardBorder = { fg = palette.cyan_dim, bg = palette.base00 }

  -- Mode indicator colors (used dynamically by statusline)
  hl.LualineEvilineModeNormal = { fg = palette.green, bg = palette.base00, bold = true }
  hl.LualineEvilineModeInsert = { fg = palette.pink, bg = palette.base00, bold = true }
  hl.LualineEvilineModeVisual = { fg = palette.red, bg = palette.base00, bold = true }
  hl.LualineEvilineModeReplace = { fg = palette.purple, bg = palette.base00, bold = true }
  hl.LualineEvilineModeCommand = { fg = palette.amber, bg = palette.base00, bold = true }
  hl.LualineEvilineModeTerminal = { fg = palette.green, bg = palette.base00, bold = true }

  hl.MiniStatuslineNormal = { fg = palette.base05, bg = palette.base01 }
  hl.MiniStatuslineModeNormal = { fg = palette.base00, bg = palette.cyan, bold = true }
  hl.MiniStatuslineModeInsert = { fg = palette.base00, bg = palette.green, bold = true }
  hl.MiniStatuslineModeVisual = { fg = palette.base00, bg = palette.amber, bold = true }
  hl.MiniStatuslineModeReplace = { fg = palette.base00, bg = palette.red, bold = true }
  hl.MiniStatuslineModeCommand = { fg = palette.base00, bg = palette.purple, bold = true }
  hl.MiniStatuslineDevinfo = { fg = palette.base04, bg = palette.base01 }
  hl.MiniStatuslineFilename = { fg = palette.base05, bg = palette.base01 }
  hl.MiniStatuslineFileinfo = { fg = palette.base04, bg = palette.base01 }
  hl.MiniStatuslineInactive = { fg = palette.base03, bg = palette.base00 }

  hl.MiniIndentscopeSymbol = { fg = palette.cyan }
  hl.MiniIndentscopePrefix = { fg = palette.cyan }

  hl.IndentBlanklineChar = { fg = palette.base03 }
  hl.IndentBlanklineContextChar = { fg = palette.cyan }
  hl.IndentBlanklineContextStart = { underline = true, sp = palette.cyan }

  -- Lazy/LazyGit
  hl.LazyNormal = { fg = palette.base05, bg = palette.base01 }
  hl.LazyBorder = { fg = palette.cyan_dim, bg = palette.base01 }
  hl.LazyButton = { fg = palette.base05, bg = palette.base02 }
  hl.LazyButtonActive = { fg = palette.cyan, bg = palette.base03, bold = true }
  hl.LazyH1 = { fg = palette.cyan, bold = true }
  hl.LazyH2 = { fg = palette.blue, bold = true }
  hl.LazyProgressTodo = { fg = palette.base03 }
  hl.LazyProgressDone = { fg = palette.cyan }

  -- LazyGit
  hl.LazyGitFloat = { bg = palette.base01 }
  hl.LazyGitBorder = { fg = palette.cyan_dim, bg = palette.base01 }
  hl.LazyGitTitle = { fg = palette.cyan, bg = palette.base01, bold = true }

  -- Neotree
  hl.NeoTreeNormal = { fg = palette.base05, bg = palette.base01 }
  hl.NeoTreeNormalNC = { fg = palette.base05, bg = palette.base01 }
  hl.NeoTreeBorder = { fg = palette.cyan_dim, bg = palette.base01 }
  hl.NeoTreeTitleBar = { fg = palette.cyan, bg = palette.base02, bold = true }
  hl.NeoTreeDirectoryName = { fg = palette.blue }
  hl.NeoTreeDirectoryIcon = { fg = palette.cyan }
  hl.NeoTreeFileName = { fg = palette.base05 }
  hl.NeoTreeFileIcon = { fg = palette.base04 }
  hl.NeoTreeGitAdded = { fg = palette.green }
  hl.NeoTreeGitModified = { fg = palette.warn }
  hl.NeoTreeGitDeleted = { fg = palette.red }
  hl.NeoTreeGitUntracked = { fg = palette.base04 }
  hl.NeoTreeRootName = { fg = palette.cyan, bold = true }

  return hl
end

-- Apply noir theme
function M.apply_noir()
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "noir"

  local hl = generate_highlights(M.noir_palette)
  for group, opts in pairs(hl) do
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- Transparency
  if vim.g.transparency then
    local transparent_groups = {
      "Normal",
      "NormalFloat",
      "NormalNC",
      "NormalSB",
      "FloatBorder",
      "FloatTitle",
      "FloatFooter",
      "Pmenu",
      "PmenuSel",
      "PmenuSbar",
      "PmenuThumb",
      "TelescopeNormal",
      "TelescopeBorder",
      "TelescopePromptNormal",
      "TelescopePromptBorder",
      "TelescopeResultsNormal",
      "TelescopeResultsBorder",
      "TelescopePreviewNormal",
      "TelescopePreviewBorder",
      "SnacksPickerNormal",
      "SnacksPickerInputBorder",
      "SnacksPickerBoxTitle",
      "SnacksPickerSelected",
      "SnacksPickerPreview",
      "MiniPickNormal",
      "MiniPickBorder",
      "MiniPickBorderBusy",
      "MiniPickBorderText",
      "MiniPickHeader",
      "MiniPickMatchCurrent",
      "MiniPickMatchMarked",
      "MiniPickMatchRanges",
      "MiniPickPreviewLine",
      "MiniPickPreviewRegion",
      "OilFloat",
      "OilFloatBorder",
      "NoicePopup",
      "NoicePopupBorder",
      "LazyNormal",
      "LazyBorder",
      "MasonNormal",
      "MasonBorder",
      "WhichKeyFloat",
      "WhichKeyBorder",
      "Pmenu",
      "PmenuSel",
      "PmenuSbar",
      "PmenuThumb",
    }
    for _, group in ipairs(transparent_groups) do
      pcall(vim.api.nvim_set_hl, 0, group, { bg = "NONE" })
    end
  end
end

-- Kitty integration
function M.setup_kitty()
  local kitty_conf = [[
# Noir/DedSec Kitty Configuration
# Generated by theme_manager.lua

# Colors
background_opacity 0.95
background #0a0a0f
foreground #e0d8e8

# Cursor
cursor #00ffff
cursor_text_color #0a0a0f

# Selection
selection_background #00ffff
selection_foreground #0a0a0f

# URL
url_color #00ffff

# Window
window_padding_width 10
window_margin_width 5

# Tabs
tab_bar_style fade
active_tab_foreground #0a0a0f
active_tab_background #00ffff
inactive_tab_foreground #e0d8e8
inactive_tab_background #1a1a24
tab_bar_background #0a0a0f

# Scrollback
scrollback_lines 10000
scrollback_fill_enlarged_window yes

# Font (adjust as needed)
font_family JetBrainsMono Nerd Font
bold_font auto
italic_font auto
bold_italic_font auto
font_size 12.0

# Colors
color0 #0a0a0f
color1 #ff2e63
color2 #00ff88
color3 #ffbf00
color4 #00aaff
color5 #cc00ff
color6 #00ffff
color7 #e0d8e8
color8 #2a2a3a
color9 #ff5c8a
color10 #33ff99
color11 #ffcc33
color12 #33bbff
color13 #cc66ff
color14 #33ffff
color15 #ffffff

# Cursor
cursor_blink_interval 0.5
cursor_blink_timeout 5.0

# Bell
enable_audio_bell no
visual_bell yes
visual_bell_duration 0.1

# URL
open_url_with default
]]

  return kitty_conf
end

-- Tmux integration
function M.setup_tmux()
  local tmux_conf = [[
# Noir/DedSec Tmux Configuration
# Generated by theme_manager.lua

# Colors
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# Status bar
set -g status on
set -g status-interval 5
set -g status-position bottom
set -g status-justify left
set -g status-style "bg=#12121a,fg=#e0d8e8"

# Status left
set -g status-left-length 100
set -g status-left "#[fg=#0a0a0f,bg=#00ffff,bold] 󰠠 #[fg=#e0d8e8,bg=#1a1a24] #S #[fg=#1a1a24,bg=#12121a]"

# Status right
set -g status-right-length 150
set -g status-right "#[fg=#00ffff,bg=#1a1a24] 󰃭 %H:%M #[fg=#00ff88,bg=#1a1a24] 󰃭 %d/%m/%Y #[fg=#e0d8e8,bg=#12121a]"

# Window status
set -g window-status-format "#[fg=#6e6a86,bg=#12121a] #I:#W#{?window_zoomed_flag, 󰍭 ,} "
set -g window-status-current-format "#[fg=#0a0a0f,bg=#00ffff,bold] #I:#W#{?window_zoomed_flag, 󰍭 ,} "
set -g window-status-separator ""

# Pane borders
set -g pane-border-style "fg=#2a2a3a"
set -g pane-active-border-style "fg=#00ffff"
set -g display-panes-colour "#00ffff"
set -g display-panes-active-colour "#00ff88"

# Messages
set -g message-style "fg=#e0d8e8,bg=#1a1a24"
set -g message-command-style "fg=#00ffff,bg=#1a1a24"

# Clock
set -g clock-mode-colour "#00ffff"
set -g clock-mode-style 24

# Mode
set -g mode-style "fg=#0a0a0f,bg=#00ffff"

# Copy mode
setw -g mode-style "fg=#0a0a0f,bg=#00ffff,bold"

# Window/session
set -g base-index 1
set -g pane-base-index 1
set -g renumber-windows on
set -g allow-rename off

# Mouse
set -g mouse on

# History
set -g history-limit 50000

# Terminal
set -s escape-time 0
set -g focus-events on
set -g set-titles on
set -g set-titles-string "#S:#I:#W - #T"
]]

  return tmux_conf
end

M.themes = {
  noir = {
    name = "noir",
    palette = M.noir_palette,
    apply = M.apply_noir,
  },
}

function M.setup()
  -- Create theme commands
  vim.api.nvim_create_user_command("Theme", function(opts)
    if opts.args == "" then
      vim.notify("Available themes: noir", vim.log.levels.INFO)
      return
    end
    local theme = M.themes[opts.args]
    if theme then
      theme.apply()
      vim.g.theme = opts.args
      vim.notify("Theme applied: " .. opts.args, vim.log.levels.INFO)
    else
      vim.notify("Theme not found: " .. opts.args, vim.log.levels.ERROR)
    end
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_keys(M.themes)
    end,
    desc = "Switch colorscheme",
  })

  vim.api.nvim_create_user_command("ThemeKitty", function(opts)
    local path = opts.args ~= "" and opts.args or vim.fn.stdpath("config") .. "/kitty.conf"
    local conf = M.setup_kitty()
    local file = io.open(path, "w")
    if file then
      file:write(conf)
      file:close()
      vim.notify("Kitty config written to " .. path, vim.log.levels.INFO)
    else
      vim.notify("Failed to write kitty config", vim.log.levels.ERROR)
    end
  end, {
    nargs = "?",
    complete = "file",
    desc = "Generate kitty config",
  })

  vim.api.nvim_create_user_command("ThemeTmux", function(opts)
    local path = opts.args ~= "" and opts.args or vim.fn.stdpath("config") .. "/tmux.conf"
    local conf = M.setup_tmux()
    local file = io.open(path, "w")
    if file then
      file:write(conf)
      file:close()
      vim.notify("Tmux config written to " .. path, vim.log.levels.INFO)
    else
      vim.notify("Failed to write tmux config", vim.log.levels.ERROR)
    end
  end, {
    nargs = "?",
    complete = "file",
    desc = "Generate tmux config",
  })

  -- Apply theme on startup
  vim.defer_fn(function()
    M.themes.noir.apply()
  end, 100)
end

return M
