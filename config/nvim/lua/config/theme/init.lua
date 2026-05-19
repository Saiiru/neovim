local M = {}

local palette = require "config.theme.palette"
local highlights = require "config.theme.highlights"

local function set_terminal_colors(c)
  vim.g.terminal_color_0 = c.black
  vim.g.terminal_color_1 = c.red
  vim.g.terminal_color_2 = c.green
  vim.g.terminal_color_3 = c.yellow
  vim.g.terminal_color_4 = c.blue
  vim.g.terminal_color_5 = c.magenta
  vim.g.terminal_color_6 = c.cyan
  vim.g.terminal_color_7 = c.fg_dark
  vim.g.terminal_color_8 = c.fg_gutter
  vim.g.terminal_color_9 = c.red
  vim.g.terminal_color_10 = c.green
  vim.g.terminal_color_11 = c.yellow
  vim.g.terminal_color_12 = c.blue
  vim.g.terminal_color_13 = c.magenta
  vim.g.terminal_color_14 = c.cyan
  vim.g.terminal_color_15 = c.fg
end

function M.load(opts)
  local t = palette.get(opts)
  local c = t.colors
  local cfg = t.config
  local groups = highlights.get(c, cfg)

  vim.o.termguicolors = true
  vim.g.colors_name = "noircircuit"

  if cfg.terminal_colors then
    set_terminal_colors(c)
  end

  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

return M
