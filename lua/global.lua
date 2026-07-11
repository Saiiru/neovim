-- lua/global.lua

local g = vim.g



-- LEADER KEY
vim.keymap.set("", "<space>", "<Nop>") -- Clear any space mappings
g.mapleader      = " "
g.maplocalleader = "\\"


-- GLOBAL VARIABLES
g.ICONS = require("_icons")

g.nvim_cache        = os.getenv("HOME") .. "/.cache/nvim"
g.python3_host_prog = os.getenv("HOME") .. '/.pyenv/versions/neovim/bin/python'



-- GLOBAL FUNCTIONS

-- Update the theme according to system appearance
vim.g.update_theme = function(dark_theme, light_theme)
  local isdark = vim.fn.system("isdark")
  local theme = dark_theme
  local bg = 'dark'

  if not isdark == 1 then
    bg = 'light'
    theme = light_theme
  end

  vim.opt.background = bg
  vim.opt.laststatus = 3
  vim.cmd("colorscheme " .. theme)
end


