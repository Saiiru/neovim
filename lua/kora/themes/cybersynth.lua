-- lua/kora/themes/cybersynth.lua
-- KORA · CYBERSYNTH (synthwave / neon, vibrant, puff)
--
-- Este colorscheme foi projetado para um ambiente de desenvolvimento "grimório neo-noir",
-- com foco em cores vibrantes e contrastantes sobre um fundo escuro, inspirado em
-- estéticas cyberpunk e synthwave. Ele busca ser produtivo, bonito e fácil de manter.
--
-- Paleta de Cores:
--   - Fundo: Tons de preto e roxo escuro para uma base discreta.
--   - Destaques: Neons vibrantes (rosa, ciano, verde, amarelo, roxo) para sintaxe,
--     seleções e elementos de UI, criando um efeito de "brilho".
--   - Texto: Branco suave para legibilidade.
--
-- Integração:
--   - Projetado para funcionar perfeitamente com Neovim, tmux e Kitty, garantindo
--     coerência visual em todo o ambiente.
--   - Utiliza `termguicolors` e `pumblend` para transparência e efeitos visuais.
--
-- Uso:
--   - Este arquivo é um módulo Lua que define o colorscheme.
--   - A função `M.apply()` define os destaques.
--   - `M.setup()` é o ponto de entrada principal.
--   - `KoraSynthBoost` é um comando de usuário para ajustar a intensidade do "puff".

local M = {}

M.palette = {
  bg        = "#0B0A12", -- near-black
  surf      = "#141127",
  neon_pink = "#FF2D95",
  neon_mag  = "#FF6EC7",
  neon_cyan = "#00F0FF",
  neon_blue = "#00CFFF",
  neon_purple = "#9A6CFF",
  neon_yellow = "#FFD166",
  neon_green = "#7CFF00",
  text      = "#F8F8F2",
  muted     = "#6C7086",
  dim       = "#262533",
  glowfav   = "#7C3AED" -- user fav purple
}

-- Utility to set highlight safely
local function hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

function M.apply()
  local p = M.palette

  -- Base UI
  hl("Normal",           { fg = p.text, bg = p.bg })
  hl("Terminal",         { fg = p.text, bg = p.bg })
  hl("NormalFloat",      { fg = p.text, bg = "NONE" }) -- allow terminal transparency
  hl("FloatBorder",      { fg = p.neon_purple, bg = "NONE", bold = true })
  hl("CursorLine",       { bg = p.surf })
  hl("CursorColumn",     { bg = p.surf })
  hl("ColorColumn",      { bg = p.dim })

  -- Line numbers
  hl("LineNr",           { fg = p.muted, bg = "NONE" })
  hl("CursorLineNr",     { fg = p.neon_pink, bold = true })

  -- Visual / selection
  hl("Visual",           { bg = p.neon_purple, fg = p.bg, bold = true, blend = 10 })
  hl("Search",           { bg = p.neon_yellow, fg = p.bg, bold = true })
  hl("IncSearch",        { bg = p.neon_mag, fg = p.bg, bold = true })

  -- Comments, keywords, strings, functions
  hl("Comment",          { fg = p.neon_purple, italic = true })
  hl(" @comment",         { fg = p.neon_purple, italic = true })

  hl("Keyword",          { fg = p.neon_pink, italic = true, bold = true })
  hl(" @keyword",         { fg = p.neon_pink, italic = true, bold = true })
  hl(" @keyword.function",{ fg = p.neon_pink, italic = true })

  hl("String",           { fg = p.neon_green })
  hl(" @string",          { fg = p.neon_green, bold = true })
  hl(" @string.escape",   { fg = p.neon_yellow, bold = true })

  hl("Function",         { fg = p.neon_cyan, bold = true })
  hl(" @function",        { fg = p.neon_cyan, italic = false })
  hl(" @function.call",   { fg = p.neon_cyan })

  hl("Method",           { fg = p.neon_cyan })
  hl("Identifier",       { fg = p.text })

  -- Types, constants, tags
  hl("Type",             { fg = p.neon_yellow, italic = true })
  hl("Constant",         { fg = p.neon_purple, bold = true })
  hl("Tag",              { fg = p.neon_pink })

  -- Pmenu / completion window: synth puff
  hl("Pmenu",            { bg = p.surf, fg = p.text })
  hl("PmenuSel",         { bg = p.neon_purple, fg = p.bg, bold = true })
  hl("PmenuThumb",       { bg = p.neon_cyan })
  hl("PmenuSbar",        { bg = p.dim })
  hl("CmpItemAbbr",      { fg = p.text })
  hl("CmpItemAbbrMatch", { fg = p.neon_cyan, bold = true })
  hl("CmpItemKind",      { fg = p.neon_purple })

  -- Telescope neon
  hl("TelescopeBorder",  { fg = p.neon_purple, bg = "NONE" })
  hl("TelescopePromptBorder", { fg = p.neon_pink })
  hl("TelescopePromptTitle",  { fg = p.neon_pink, bg = "NONE", bold = true })
  hl("TelescopeResultsTitle", { fg = p.neon_purple, bg = "NONE" })
  hl("TelescopePreviewTitle", { fg = p.neon_green, bg = "NONE" })
  hl("TelescopeSelection", { bg = p.neon_blue, fg = p.bg, bold = true })

  -- Git signs
  hl("GitSignsAdd",      { fg = p.neon_green, bg = "NONE", bold = true })
  hl("GitSignsChange",   { fg = p.neon_yellow, bold = true })
  hl("GitSignsDelete",   { fg = p.neon_pink, bold = true })

  -- Diagnostics
  hl("DiagnosticError",  { fg = p.neon_pink, bold = true })
  hl("DiagnosticWarn",   { fg = p.neon_yellow, bold = true })
  hl("DiagnosticInfo",   { fg = p.neon_cyan })
  hl("DiagnosticHint",   { fg = p.neon_purple })

  -- Bufferline / tabline
  hl("BufferLineTab",            { fg = p.muted, bg = p.surf })
  hl("BufferLineTabSelected",    { fg = p.text, bg = p.neon_purple, bold = true })
  hl("BufferLineIndicatorSelected",{ fg = p.neon_cyan })

  -- WhichKey
  hl("WhichKey",         { fg = p.neon_pink, bold = true })
  hl("WhichKeyGroup",    { fg = p.neon_cyan })
  hl("WhichKeyDesc",     { fg = p.text })

  -- Treesitter semantic overrides (more explicit)
  hl(" @variable",        { fg = p.text })
  hl(" @variable.builtin",{ fg = p.neon_purple, italic = true })
  hl(" @parameter",       { fg = p.neon_yellow, italic = true })
  hl(" @property",        { fg = p.neon_green })

  -- UI glow accents (fake glow via bold/italic + bright fg)
  hl("StatusLine",       { fg = p.text, bg = p.surf })
  hl("StatusLineNC",     { fg = p.muted, bg = p.surf })
  hl("WinBar",           { fg = p.neon_cyan, bg = "NONE", bold = true })

  -- Terminal palette mapping (very important for real neon in terminal)
  vim.g.terminal_color_0  = p.bg
  vim.g.terminal_color_1  = p.neon_pink
  vim.g.terminal_color_2  = p.neon_green
  vim.g.terminal_color_3  = p.neon_yellow
  vim.g.terminal_color_4  = p.neon_cyan
  vim.g.terminal_color_5  = p.neon_mag
  vim.g.terminal_color_6  = p.neon_purple
  vim.g.terminal_color_7  = p.text
  vim.g.terminal_color_8  = p.dim
  vim.g.terminal_color_9  = p.neon_pink
  vim.g.terminal_color_10 = p.neon_green
  vim.g.terminal_color_11 = p.neon_yellow
  vim.g.terminal_color_12 = p.neon_blue
  vim.g.terminal_color_13 = p.neon_mag
  vim.g.terminal_color_14 = p.neon_purple
  vim.g.terminal_color_15 = "#FFFFFF"

  -- extra: override endofbuffer to keep "clean" look
  hl("EndOfBuffer", { fg = p.bg })

  -- small UX touches
  vim.o.pumblend = 10 -- transparency for completion popup (requires term support)
  vim.o.termguicolors = true

  -- optional user command to toggle "puff" intensity
  vim.api.nvim_create_user_command("KoraSynthBoost", function(opts)
    local mode = opts.args == "off" and "off" or "on"
    if mode == "on" then
      -- increase saturation by switching highlight variants
      hl("Normal", { fg = p.text, bg = "#07060A" })
      hl("PmenuSel", { bg = p.neon_mag, fg = p.bg, bold = true })
      vim.notify("KORA CyberSynth: BOOST ON", vim.log.levels.INFO)
    else
      hl("Normal", { fg = p.text, bg = p.bg })
      hl("PmenuSel", { bg = p.neon_purple, fg = p.bg, bold = true })
      vim.notify("KORA CyberSynth: BOOST OFF", vim.log.levels.INFO)
    end
  end, { nargs = "?" })
end

-- Apply immediately when module required
M.setup = function()
  M.apply()
  -- prefer cyberdream if installed
  if pcall(require, "cyberdream") then
    -- If cyberdream is installed, we can potentially use it as a base
    -- and then overlay our custom highlights. For now, we'll assume
    -- this file is the primary colorscheme.
    -- require("cyberdream").setup({ transparent = false })
    -- vim.cmd("colorscheme cyberdream")
  else
    -- fallback: set basic colorscheme to default and apply highlights
    vim.cmd("highlight clear")
  end
end

return M
