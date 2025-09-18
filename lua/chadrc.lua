-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

-- paleta única para os overrides
local P = {
  bg = "#0B0A12",
  surf = "#141127",
  neon_pink = "#FF2D95",
  neon_mag = "#FF6EC7",
  neon_cyan = "#00F0FF",
  neon_blue = "#00CFFF",
  neon_purple = "#9A6CFF",
  neon_yellow = "#FFD166",
  neon_green = "#7CFF00",
  text = "#F8F8F2",
  muted = "#6C7086",
  dim = "#262533",
}

M.base46 = {
  theme = "onedark", -- usa a UI do NVChad, mas pintamos abaixo
  transparency = true,
  theme_toggle = { "onedark", "one_light" },

  hl_override = {
    -- base transparente + contraste legível
    Normal = { fg = P.text, bg = "NONE" },
    NormalNC = { fg = P.muted, bg = "NONE" },
    NormalFloat = { fg = P.text, bg = "NONE" },
    FloatBorder = { fg = P.neon_purple, bg = "NONE", bold = true },
    WinSeparator = { fg = P.dim },

    CursorLine = { bg = "NONE" },
    CursorColumn = { bg = "NONE" },
    ColorColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "NONE", bg = "NONE" },

    SignColumn = { fg = P.text, bg = "NONE" },
    StatusLine = { fg = P.text, bg = "NONE" },
    StatusLineNC = { fg = P.muted, bg = "NONE" },
    TabLine = { fg = P.muted, bg = "NONE" },
    TabLineSel = { fg = P.text, bg = "NONE", bold = true },
    TabLineFill = { fg = P.muted, bg = "NONE" },

    -- Pmenu / Telescope
    Pmenu = { fg = P.text, bg = "NONE" },
    PmenuSel = { fg = "#000000", bg = P.neon_blue, bold = true },
    PmenuSbar = { bg = "NONE" },
    PmenuThumb = { bg = P.neon_cyan },
    TelescopeBorder = { fg = P.neon_purple, bg = "NONE" },
    TelescopePromptBorder = { fg = P.neon_pink, bg = "NONE" },
    TelescopePromptTitle = { fg = P.neon_pink, bg = "NONE", bold = true },
    TelescopeResultsTitle = { fg = P.neon_purple, bg = "NONE" },
    TelescopePreviewTitle = { fg = P.neon_green, bg = "NONE" },

    -- Diags
    DiagnosticError = { fg = P.neon_pink },
    DiagnosticWarn = { fg = P.neon_yellow },
    DiagnosticInfo = { fg = P.neon_cyan },
    DiagnosticHint = { fg = P.neon_purple },

    -- UI NvChad
    St_Normal = { fg = P.text, bg = "NONE" },
    St_Insert = { fg = P.neon_green, bg = "NONE" },
    St_Visual = { fg = P.neon_purple, bg = "NONE" },
    St_Replace = { fg = P.neon_pink, bg = "NONE" },
    TbLineFill = { bg = "NONE" },
    TbLineSel = { fg = P.text, bg = "NONE" },
    NvimTreeNormal = { bg = "NONE" },
  },

  hl_add = {
    -- sintaxe com “neon”
    ["@comment"] = { fg = P.neon_purple, italic = true },
    ["@keyword"] = { fg = P.neon_pink, italic = true, bold = true },
    ["@keyword.function"] = { fg = P.neon_pink, italic = true },
    ["@string"] = { fg = P.neon_green, bold = true },
    ["@string.escape"] = { fg = P.neon_yellow, bold = true },
    ["@function"] = { fg = P.neon_cyan },
    ["@type"] = { fg = P.neon_yellow, italic = true },
  },
}

M.ui = {
  telescope = { style = "bordered" },
  statusline = { theme = "minimal" },
  tabufline = { lazyload = false },
}

return M
