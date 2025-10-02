-- lua/util/colors.lua
local M = {}

-- ===== PALETA BASE (neon legível, fundo escuro) =============================
local P = {
  bg   = "#0B0A12",
  surf = "#141127",
  base = "#1A1A2E",
  float= "#1E1E2E",
  text = "#F8F8F2",
  mut  = "#6C7086",
  dim  = "#262533",

  pink = "#FF2D95",
  mag  = "#FF6EC7",
  cyan = "#00F0FF",
  blue = "#00CFFF",
  purp = "#9A6CFF",
  yel  = "#FFD166",
  grn  = "#7CFF00",
  red  = "#FF5555",
}

local state = {
  transparent = true,
  boost = 1,            -- 0,1,2  (2 = mais neon)
}

local function hl(g, o) vim.api.nvim_set_hl(0, g, o) end

-- ====== OVERRIDES GENÉRICOS (aplicados sobre qualquer colorscheme) =========
local function apply_core()
  local bg_float = state.transparent and "NONE" or P.float
  local bg_norm  = state.transparent and "NONE" or P.base

  -- Base / Float / Separadores
  hl("Normal",       { fg = P.text, bg = bg_norm })
  hl("NormalFloat",  { fg = P.text, bg = bg_float })
  hl("FloatBorder",  { fg = P.purp, bg = "NONE" })
  hl("WinSeparator", { fg = "#2a2740", bg = "NONE" })
  hl("LineNr",       { fg = P.mut })
  hl("CursorLine",   { bg = state.transparent and "#17152b" or P.surf })
  hl("CursorLineNr", { fg = P.pink, bold = true })
  hl("ColorColumn",  { bg = "#17152b" })

  -- Pmenu / Completion
  hl("Pmenu",        { bg = "#1a1830", fg = P.text })
  hl("PmenuSel",     { bg = state.boost == 2 and P.mag or P.purp, fg = P.bg, bold = true })
  hl("PmenuSbar",    { bg = P.dim })
  hl("PmenuThumb",   { bg = P.cyan })

  -- Sintaxe (Treesitter)
  hl("@comment",           { fg = P.purp, italic = true })
  hl("@keyword",           { fg = P.pink, italic = true })
  hl("@keyword.function",  { fg = P.pink, italic = true })
  hl("@string",            { fg = P.grn })
  hl("@string.escape",     { fg = P.yel, bold = true })
  hl("@function",          { fg = P.cyan })
  hl("@function.call",     { fg = P.cyan })
  hl("@method",            { fg = P.cyan })
  hl("@type",              { fg = P.yel, italic = true })
  hl("@variable",          { fg = P.text })
  hl("@property",          { fg = P.grn })
  hl("@parameter",         { fg = P.yel, italic = true })
  hl("@operator",          { fg = P.pink })

  -- LSP semantic
  hl("@lsp.type.namespace", { fg = P.yel, italic = true })
  hl("@lsp.type.class",     { fg = P.yel, italic = true })
  hl("@lsp.type.interface", { fg = P.yel, italic = true })
  hl("@lsp.type.enum",      { fg = P.yel, italic = true })
  hl("@lsp.type.parameter", { fg = P.yel, italic = true })
  hl("@lsp.type.property",  { fg = P.grn })
  hl("@lsp.type.method",    { fg = P.cyan })
  hl("@lsp.type.function",  { fg = P.cyan })
  hl("@lsp.type.variable",  { fg = P.text })

  -- Diagnostics
  hl("DiagnosticError", { fg = P.red })
  hl("DiagnosticWarn",  { fg = P.yel })
  hl("DiagnosticInfo",  { fg = P.cyan })
  hl("DiagnosticHint",  { fg = P.purp })

  -- Telescope
  hl("TelescopeBorder",       { fg = P.purp, bg = "NONE" })
  hl("TelescopePromptBorder", { fg = P.pink, bg = "NONE" })
  hl("TelescopeSelection",    { bg = P.blue, fg = P.bg, bold = true })
  hl("TelescopeMatching",     { fg = P.grn, bold = true })

  -- Snacks / Noice / Notify (se existirem)
  hl("SnacksNotifierBorderInfo", { fg = P.cyan })
  hl("SnacksNotifierIconInfo",   { fg = P.cyan })
  hl("NoiceCmdlinePopupBorder",  { fg = P.purp })
  hl("NotifyBackground",         { bg = "NONE" })

  -- GitSigns
  hl("GitSignsAdd",    { fg = P.grn })
  hl("GitSignsChange", { fg = P.yel })
  hl("GitSignsDelete", { fg = P.red })

  -- Terminal palette
  vim.g.terminal_color_0  = P.bg
  vim.g.terminal_color_1  = P.pink
  vim.g.terminal_color_2  = P.grn
  vim.g.terminal_color_3  = P.yel
  vim.g.terminal_color_4  = P.cyan
  vim.g.terminal_color_5  = P.mag
  vim.g.terminal_color_6  = P.purp
  vim.g.terminal_color_7  = P.text
  vim.g.terminal_color_8  = P.dim
  vim.g.terminal_color_9  = P.pink
  vim.g.terminal_color_10 = P.grn
  vim.g.terminal_color_11 = P.yel
  vim.g.terminal_color_12 = P.blue
  vim.g.terminal_color_13 = P.mag
  vim.g.terminal_color_14 = P.purp
  vim.g.terminal_color_15 = "#FFFFFF"

  -- Limpeza visual
  hl("EndOfBuffer", { fg = state.transparent and "NONE" or P.bg })
end

-- ===== API ================================================================
function M.set(theme)
  theme = theme or (vim.g.neosairu_theme or "cyberdream")
  vim.schedule(function()
    pcall(vim.cmd.colorscheme, theme)
    apply_core()
  end)
end

function M.transparent(mode)   -- true/false/"toggle"
  if mode == "toggle" then state.transparent = not state.transparent
  else state.transparent = not not mode end
  apply_core()
end

function M.boost(level)        -- 0/1/2
  state.boost = math.max(0, math.min(2, tonumber(level) or 1))
  apply_core()
end

function M.setup()
  -- compat com tua função ColorMyPencils
  _G.ColorMyPencils = function(color)
    M.set(color or "rose-pine")
    M.transparent(true)
  end

  -- comandos
  vim.api.nvim_create_user_command("NeoTheme", function(o) M.set(o.args ~= "" and o.args or nil) end, { nargs = "?" })
  vim.api.nvim_create_user_command("NeoTransparent", function(o)
    local arg = o.args
    if arg == "on" then M.transparent(true)
    elseif arg == "off" then M.transparent(false)
    else M.transparent("toggle") end
  end, { nargs = "?" })
  vim.api.nvim_create_user_command("NeoBoost", function(o) M.boost(o.args) end, { nargs = "?" })

  -- re-aplica quando ColorScheme mudar
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("neosairu_colors", { clear = true }),
    callback = function() apply_core() end,
  })
end

return M

