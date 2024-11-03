-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- ========================
-- Basic Neovim Configuration
-- ========================

local opt = vim.opt
local g = vim.g
local fn = vim.fn

-- General Neovim options
opt.number = true -- Show absolute line numbers
opt.relativenumber = true -- Show relative line numbers
opt.scrolloff = 10 -- Vertical scroll offset
opt.sidescrolloff = 8 -- Horizontal scroll offset
opt.splitright = true -- Open new vertical split to the right
opt.splitbelow = true -- Open new horizontal split below
opt.signcolumn = "yes" -- Always show sign column
opt.termguicolors = true -- Enable 24-bit colors
opt.laststatus = 0 -- Hide status line globally
opt.cmdheight = 0 -- Hide command line unless used
opt.updatetime = 250 -- Faster completion response
opt.timeoutlen = 1000 -- Set leader key delay to 1 second
opt.cursorline = true -- Highlight current cursor line
opt.cursorlineopt = "number" -- Highlight line number for cursor
opt.mouse = "a" -- Enable mouse support
opt.mousemoveevent = true -- Track mouse movement events
opt.wrap = false -- Disable line wrapping
opt.hidden = true -- Allow unsaved buffers in background
opt.clipboard = "unnamedplus" -- System clipboard integration
opt.fillchars = { eob = " " } -- Remove ~ from empty lines
opt.pumheight = 10 -- Limit popup menu height

-- Indentation settings
opt.shiftwidth = 2 -- Indentation for >, < commands
opt.tabstop = 2 -- Tab size of 2 spaces
opt.softtabstop = 2 -- Tab key behaves as 2 spaces
opt.expandtab = true -- Convert tabs to spaces

-- Search settings
opt.ignorecase = true -- Case-insensitive search
opt.smartcase = true -- Case-sensitive if uppercase is present
opt.hlsearch = false -- Disable search highlighting
opt.incsearch = true -- Enable incremental search
opt.gdefault = true -- Use `g` flag by default for :substitute

-- File Handling
opt.swapfile = false -- Disable swap files
opt.undofile = true -- Enable persistent undo
opt.undodir = fn.stdpath("config") .. "/.undo"

-- Whitespace and lists
opt.list = true -- Show whitespace characters
opt.listchars = {
  space = ".",
  eol = "↲",
  nbsp = "␣",
  trail = "·",
  precedes = "←",
  extends = "→",
  tab = "¬ ",
  conceal = "※",
}

-- Folding settings
opt.foldmethod = "expr" -- Define folding method as expr
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Treesitter fold expression
opt.foldlevel = 20 -- Initial fold level
opt.foldenable = false -- Disable automatic folding on file open

-- Enhanced display and command line options
opt.completeopt = { "menu", "menuone", "noselect" }
opt.inccommand = "split" -- Live substitution preview

-- Leader keys
g.mapleader = " " -- Global leader key
g.maplocalleader = "," -- Local leader key

-- Nerd Font settings
g.have_nerd_font = true -- Global Nerd Font usage flag
opt.guifont = "FiraCode Nerd Font:h12,Maple Mono NF:h12" -- GUI font combination

-- Diff settings
opt.diffopt = "vertical,iwhite" -- Vertical diff with no whitespace

-- Filetype-specific indentation settings
vim.cmd([[
  autocmd FileType java,go,c setlocal tabstop=4 shiftwidth=4 expandtab
  autocmd FileType lua,javascript setlocal tabstop=2 shiftwidth=2 expandtab
]])
