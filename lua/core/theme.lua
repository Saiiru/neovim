local M = {}

local c = {
  bg = "#1a1b26",
  bg_dark = "#16161e",
  bg_float = "#1f2335",
  fg = "#c0caf5",
  muted = "#565f89",
  blue = "#7aa2f7",
  cyan = "#7dcfff",
  green = "#9ece6a",
  yellow = "#e0af68",
  orange = "#ff9e64",
  red = "#f7768e",
  magenta = "#bb9af7",
  border = "#292e42",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.setup()
  vim.g.colors_name = "vega-tokyo"
  vim.o.termguicolors = true

  hi("Normal", { fg = c.fg, bg = c.bg })
  hi("NormalFloat", { fg = c.fg, bg = c.bg_float })
  hi("FloatBorder", { fg = c.blue, bg = c.bg_float })
  hi("CursorLine", { bg = c.bg_dark })
  hi("LineNr", { fg = c.muted })
  hi("CursorLineNr", { fg = c.yellow, bold = true })
  hi("SignColumn", { bg = c.bg })
  hi("Visual", { bg = "#33467c" })
  hi("Search", { fg = c.bg, bg = c.yellow })
  hi("IncSearch", { fg = c.bg, bg = c.orange })
  hi("Pmenu", { fg = c.fg, bg = c.bg_float })
  hi("PmenuSel", { fg = c.bg, bg = c.blue })

  hi("Comment", { fg = c.muted, italic = true })
  hi("String", { fg = c.green })
  hi("Number", { fg = c.orange })
  hi("Boolean", { fg = c.orange })
  hi("Function", { fg = c.blue })
  hi("Identifier", { fg = c.fg })
  hi("Keyword", { fg = c.magenta, italic = true })
  hi("Type", { fg = c.cyan })
  hi("Constant", { fg = c.orange })
  hi("Statement", { fg = c.magenta })

  hi("DiagnosticError", { fg = c.red })
  hi("DiagnosticWarn", { fg = c.yellow })
  hi("DiagnosticInfo", { fg = c.blue })
  hi("DiagnosticHint", { fg = c.cyan })
  hi("DiagnosticVirtualTextError", { fg = c.red, bg = "#2a1f2a" })
  hi("DiagnosticVirtualTextWarn", { fg = c.yellow, bg = "#2a261a" })
  hi("DiagnosticVirtualTextInfo", { fg = c.blue, bg = "#1f2533" })
  hi("DiagnosticVirtualTextHint", { fg = c.cyan, bg = "#1f2933" })

  hi("DiffAdd", { fg = c.green })
  hi("DiffChange", { fg = c.yellow })
  hi("DiffDelete", { fg = c.red })
  hi("MiniDiffSignAdd", { fg = c.green })
  hi("MiniDiffSignChange", { fg = c.yellow })
  hi("MiniDiffSignDelete", { fg = c.red })

  hi("StatusLine", { fg = c.fg, bg = c.bg_dark })
  hi("StatusLineNC", { fg = c.muted, bg = c.bg_dark })
end

return M
