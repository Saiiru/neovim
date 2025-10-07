-- lua/core/options.lua
local o, g = vim.opt, vim.g

-- Líder
g.mapleader = " "
g.maplocalleader = " "

-- Desabilita netrw (use NvimTree/Oil/etc.)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
vim.cmd("let g:netrw_banner = 0")

-- UI / Aparência
o.termguicolors = true
o.background = "dark"
o.number = true
o.relativenumber = true
o.numberwidth = 2
o.cursorline = true
o.signcolumn = "yes"
o.colorcolumn = "80"
o.pumheight = 12
o.showmode = false
o.cmdheight = 0

-- Janelas e rolagem
o.splitright = true
o.splitbelow = true
o.scrolloff = 10
o.sidescrolloff = 8

-- Busca
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true
o.inccommand = "split"
o.wrapscan = false

-- Clipboard / Mouse
o.clipboard = "unnamedplus"
o.mouse = "a"

-- Edição (4 espaços)
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.smartindent = true
o.breakindent = true
o.wrap = false

-- Arquivos / Undo
o.swapfile = false
o.backup = false
o.writebackup = false
o.undofile = true
o.undodir = vim.fn.stdpath("state") .. "/undo"

-- Performance
o.updatetime = 100
o.timeoutlen = 500

-- Listas / preenchimentos
o.list = true
o.listchars = { tab = "→ ", trail = "·", extends = "…", precedes = "…", nbsp = "␣" }
o.fillchars = { eob = " ", fold = " ", foldopen = "", foldclose = "", foldsep = " " }

-- Folding (ufo-friendly)
o.foldenable = true
o.foldmethod = "manual"
o.foldlevel = 99
o.foldcolumn = "0"

-- Miscelânea
o.isfname:append("@-@")
o.iskeyword:append("-,_")
o.virtualedit = "block"
o.whichwrap = "b,s,<,>,[,],h,l"
