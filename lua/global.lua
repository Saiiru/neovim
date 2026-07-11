-- lua/global.lua

local g = vim.g
local home = os.getenv("HOME") or ""

-- LEADER KEY
vim.keymap.set("", "<space>", "<Nop>") -- Clear any space mappings
g.mapleader      = " "
g.maplocalleader = "\\"

-- GLOBAL VARIABLES
g.ICONS = require("_icons")
g.nvim_cache = home .. "/.cache/nvim"

-- Optional providers are disabled unless explicitly configured and available.
-- This keeps :checkhealth focused on the PDE path instead of unused host runtimes.
local python_host = home .. "/.pyenv/versions/neovim/bin/python"
if vim.fn.executable(python_host) == 1 then
  g.python3_host_prog = python_host
else
  g.loaded_python3_provider = 0
end
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- GLOBAL FUNCTIONS

-- Update the theme according to system appearance
vim.g.update_theme = function(dark_theme, light_theme)
  local isdark = vim.fn.system("isdark")
  local theme = dark_theme
  local bg = "dark"

  if not isdark == 1 then
    bg = "light"
    theme = light_theme
  end

  vim.opt.background = bg
  vim.opt.laststatus = 3
  vim.cmd("colorscheme " .. theme)
end
