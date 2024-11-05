-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local go = vim.g
local o = vim.opt

-- Optimizations on startup
vim.loader.enable()

-- Personal Config and LazyVim global options
go.lualine_info_extras = false
go.codeium_cmp_hide = false
go.lazyvim_statuscolumn.folds_open = true
go.lazyvim_statuscolumn.folds_githl = true
go.lazygit_config = false

-- Define leader key
go.mapleader = " "
go.maplocalleader = "\\"

-- Autoformat on save (Global)
go.autoformat = true

-- Font
go.gui_font_default_size = 10
go.gui_font_size = go.gui_font_default_size
go.gui_font_face = "JetBrainsMono Nerd Font"

-- Enable EditorConfig integration
go.editorconfig = true

-- Root dir detection
go.root_spec = {
  "lsp",
  { ".git", "lua", ".obsidian", "package.json", "Makefile", "go.mod", "cargo.toml", "pyproject.toml", "src" },
  "cwd",
}

-- Disable annoying cmd line stuff
o.showcmd = false
o.laststatus = 3
o.cmdheight = 0

-- Enable spell checking
o.spell = true
o.spelllang:append("es", "pt_br") -- Adicionando suporte ao português brasileiro

-- Backspacing and indentation when wrapping
o.backspace = { "start", "eol", "indent" }
o.breakindent = true

-- Smoothscroll
if vim.fn.has("nvim-0.10") == 1 then
  o.smoothscroll = true
end

o.conceallevel = 2

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
local undo_dir = os.getenv("HOME") .. "/.local/share/nvim/undo"
os.execute("mkdir -p " .. undo_dir)
opt.undodir = undo_dir

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
