local p = require("theme.palette")

local M = {}

function M.apply()
  local set = vim.api.nvim_set_hl
  local groups = {
    Normal = { fg = p.fg0, bg = p.bg0 },
    NormalFloat = { fg = p.fg0, bg = p.bg1 },
    FloatBorder = { fg = p.border, bg = p.bg1 },
    WinSeparator = { fg = p.border },
    CursorLine = { bg = p.bg2 },
    CursorLineNr = { fg = p.blue, bold = true },
    LineNr = { fg = p.subtle },
    SignColumn = { bg = p.bg0 },
    Visual = { bg = p.bg3 },
    Search = { fg = p.bg0, bg = p.amber, bold = true },
    IncSearch = { fg = p.bg0, bg = p.cyan, bold = true },

    Comment = { fg = p.muted, italic = true },
    String = { fg = p.green },
    Number = { fg = p.amber },
    Boolean = { fg = p.amber, bold = true },
    Constant = { fg = p.amber },
    Identifier = { fg = p.fg0 },
    Function = { fg = p.blue, bold = true },
    Type = { fg = p.violet, bold = true },
    Keyword = { fg = p.violet },
    Statement = { fg = p.violet },
    Conditional = { fg = p.violet, italic = true },
    Repeat = { fg = p.violet },
    Operator = { fg = p.fg1 },
    Special = { fg = p.orange },

    ["@comment"] = { fg = p.muted, italic = true },
    ["@string"] = { fg = p.green },
    ["@string.escape"] = { fg = p.orange },
    ["@string.special"] = { fg = p.cyan },
    ["@number"] = { fg = p.amber },
    ["@boolean"] = { fg = p.amber, bold = true },
    ["@constant"] = { fg = p.amber },
    ["@constant.builtin"] = { fg = p.amber, bold = true },

    ["@variable"] = { fg = p.fg0 },
    ["@variable.builtin"] = { fg = p.cyan, italic = true },
    ["@variable.parameter"] = { fg = p.cyan, italic = true },
    ["@parameter"] = { fg = p.cyan, italic = true },
    ["@variable.member"] = { fg = p.teal },
    ["@property"] = { fg = p.teal },
    ["@field"] = { fg = p.teal },

    ["@function"] = { fg = p.blue, bold = true },
    ["@function.call"] = { fg = p.blue },
    ["@function.builtin"] = { fg = p.cyan, bold = true },
    ["@function.macro"] = { fg = p.orange, bold = true },
    ["@method"] = { fg = p.blue, bold = true },
    ["@method.call"] = { fg = p.blue },

    ["@constructor"] = { fg = p.violet, bold = true },
    ["@type"] = { fg = p.violet, bold = true },
    ["@type.builtin"] = { fg = p.violet, italic = true },
    ["@module"] = { fg = p.cyan },
    ["@namespace"] = { fg = p.cyan },

    ["@keyword"] = { fg = p.violet },
    ["@keyword.function"] = { fg = p.violet },
    ["@keyword.import"] = { fg = p.violet, italic = true },
    ["@keyword.return"] = { fg = p.violet, italic = true },
    ["@keyword.conditional"] = { fg = p.violet, italic = true },
    ["@keyword.repeat"] = { fg = p.violet },
    ["@keyword.operator"] = { fg = p.fg1 },
    ["@operator"] = { fg = p.fg1 },

    ["@tag"] = { fg = p.violet },
    ["@tag.attribute"] = { fg = p.teal, italic = true },
    ["@punctuation"] = { fg = p.fg1 },

    ["@lsp.type.parameter"] = { fg = p.cyan, italic = true },
    ["@lsp.type.property"] = { fg = p.teal },
    ["@lsp.type.variable"] = { fg = p.fg0 },
    ["@lsp.type.function"] = { fg = p.blue, bold = true },
    ["@lsp.type.method"] = { fg = p.blue, bold = true },
    ["@lsp.type.class"] = { fg = p.violet, bold = true },
    ["@lsp.type.interface"] = { fg = p.violet, italic = true },
    ["@lsp.type.type"] = { fg = p.violet, bold = true },
    ["@lsp.type.typeParameter"] = { fg = p.cyan, italic = true },
    ["@lsp.type.enum"] = { fg = p.violet, bold = true },
    ["@lsp.type.enumMember"] = { fg = p.amber },
    ["@lsp.type.namespace"] = { fg = p.cyan },
    ["@lsp.type.decorator"] = { fg = p.orange, italic = true },
    ["@lsp.mod.readonly"] = { fg = p.amber },
    ["@lsp.mod.defaultLibrary"] = { fg = p.cyan, italic = true },
    ["@lsp.mod.deprecated"] = { fg = p.muted, strikethrough = true },

    LspInlayHint = { fg = "#60738A", bg = p.bg1, italic = true },
    LspReferenceText = { bg = p.bg3 },
    LspReferenceRead = { bg = p.bg3 },
    LspReferenceWrite = { bg = p.bg3, underline = true },
    CmpGhostText = { fg = p.subtle, italic = true },

    DiagnosticError = { fg = p.red },
    DiagnosticWarn = { fg = p.amber },
    DiagnosticInfo = { fg = p.blue },
    DiagnosticHint = { fg = p.cyan },
    DiagnosticUnderlineError = { undercurl = true, sp = p.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = p.amber },
    DiagnosticUnderlineInfo = { undercurl = true, sp = p.blue },
    DiagnosticUnderlineHint = { undercurl = true, sp = p.cyan },
    DiagnosticVirtualTextError = { fg = p.red, bg = p.bg1 },
    DiagnosticVirtualTextWarn = { fg = p.amber, bg = p.bg1 },
    DiagnosticVirtualTextInfo = { fg = p.blue, bg = p.bg1 },
    DiagnosticVirtualTextHint = { fg = p.cyan, bg = p.bg1, italic = true },

    Directory = { fg = p.cyan, bold = true },
    SnacksPicker = { fg = p.fg0, bg = p.bg0 },
    SnacksPickerList = { fg = p.fg0, bg = p.bg0 },
    SnacksPickerInput = { fg = p.fg0, bg = p.bg1 },
    SnacksPickerPreview = { fg = p.fg0, bg = p.bg0 },
    SnacksPickerBorder = { fg = p.border, bg = p.bg0 },
    SnacksPickerTitle = { fg = p.blue, bg = p.bg0, bold = true },
    SnacksPickerListCursorLine = { bg = p.bg3 },
    SnacksPickerCursorLine = { bg = p.bg3 },
    SnacksPickerDir = { fg = p.cyan, bold = true },
    SnacksPickerFile = { fg = p.fg0 },
    SnacksPickerPathHidden = { fg = p.subtle },
    SnacksPickerPathIgnored = { fg = p.subtle },
    SnacksPickerGitStatusUntracked = { fg = p.green },
    SnacksPickerGitStatusModified = { fg = p.amber },
    SnacksPickerGitStatusDeleted = { fg = p.red },
    SnacksPickerMatch = { fg = p.bg0, bg = p.cyan, bold = true },
    SnacksPickerIcon = { fg = p.cyan },
    SnacksPickerIconDirectory = { fg = p.cyan },
    SnacksPickerDimmed = { fg = p.muted },
    SnacksPickerDelim = { fg = p.subtle },
    SnacksPickerToggle = { fg = p.amber },
    SnacksExplorerNormal = { fg = p.fg0, bg = p.bg0 },
    SnacksExplorerDir = { fg = p.cyan, bold = true },
    SnacksExplorerFile = { fg = p.fg0 },
    SnacksExplorerGitStatusUntracked = { fg = p.green },
    SnacksExplorerGitStatusModified = { fg = p.amber },
    SnacksExplorerGitStatusDeleted = { fg = p.red },

    EdgyNormal = { fg = p.fg0, bg = p.bg0 },
    EdgyTitle = { fg = p.blue, bg = p.bg0, bold = true },
    EdgyWinBar = { fg = p.cyan, bg = p.bg1, bold = true },
    EdgyWinBarNC = { fg = p.muted, bg = p.bg0 },

    TroubleNormal = { fg = p.fg0, bg = p.bg1 },
    TroubleText = { fg = p.fg1 },
    TroubleCount = { fg = p.amber, bold = true },
    TroublePreview = { bg = p.bg2 },
    NoiceCmdlinePopup = { fg = p.fg0, bg = p.bg1 },
    NoiceCmdlinePopupBorder = { fg = p.border, bg = p.bg1 },
    NoiceCmdlineIcon = { fg = p.cyan, bg = p.bg1, bold = true },
    NoiceMini = { fg = p.fg1, bg = p.bg2 },
    TinyInlineDiagnosticVirtualTextError = { fg = p.red, bg = p.bg1 },
    TinyInlineDiagnosticVirtualTextWarn = { fg = p.amber, bg = p.bg1 },
    TinyInlineDiagnosticVirtualTextInfo = { fg = p.blue, bg = p.bg1 },
    TinyInlineDiagnosticVirtualTextHint = { fg = p.cyan, bg = p.bg1, italic = true },
  }

  for group, spec in pairs(groups) do
    set(0, group, spec)
  end
end

function M.setup()
  M.apply()
  vim.api.nvim_create_autocmd({ "ColorScheme", "LspAttach", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("sairu_theme_overrides", { clear = true }),
    callback = function()
      vim.schedule(M.apply)
    end,
  })
end

return M
