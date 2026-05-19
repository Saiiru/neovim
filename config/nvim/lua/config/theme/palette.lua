local M = {}

M.defaults = {
  transparent = false,
  terminal_colors = true,
  dim_inactive = false,
  italics = {
    comments = true,
    keywords = true,
    strings = false,
    functions = false,
    variables = false,
    types = false,
  },
}

M.colors = {
  bg = "#0A0E14",
  black = "#000000",

  bg_dark = "#111826",
  bg_float = "#182132",
  border = "#22304A",
  line = "#1A2333",
  selection = "#22304A",

  fg = "#F2F7FF",
  fg_dark = "#98A9C2",
  fg_gutter = "#6B7C93",

  blue = "#2AC3FF",
  cyan = "#56D4DD",
  magenta = "#A77DFF",
  yellow = "#FFD000",
  red = "#FF3B5C",
  orange = "#FF8F40",
  green = "#39FF14",

  info = "#56D4DD",
  hint = "#A77DFF",
  warn = "#FFD000",
  error = "#FF3B5C",
  ok = "#39FF14",
}

function M.get(opts)
  local cfg = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
  local colors = vim.deepcopy(M.colors)

  if cfg.transparent then
    colors.bg = "NONE"
    colors.bg_dark = "NONE"
    colors.bg_float = "NONE"
  end

  return {
    colors = colors,
    config = cfg,
  }
end

return M
