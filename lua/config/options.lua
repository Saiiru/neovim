-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

-- Leader and local leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- General settings
vim.g.deprecation_warnings = false
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Clipboard setup: disable clipboard on SSH
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

-- Completion and search settings
opt.completeopt = "menu,menuone,noselect"
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit" -- Preview incremental substitute
opt.hlsearch = true
opt.incsearch = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Interface settings
opt.cursorline = true -- Highlight current line
opt.termguicolors = true -- Enable true color support
opt.number = true -- Show line numbers
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4 -- Lines of context around cursor
opt.sidescrolloff = 8 -- Columns of context around cursor
opt.signcolumn = "yes" -- Always show sign column
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- File handling and backup settings
opt.autowrite = true -- Enable auto-write
opt.undofile = true -- Enable undo file
opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"
opt.swapfile = false
opt.backup = false

-- Indentation settings
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.shiftround = true

-- Folding settings
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldtext = "v:lua.require'utils.ui'.foldtext()"

-- Mouse and input settings
opt.mouse = "a" -- Enable mouse support
opt.timeoutlen = 300 -- Faster timeout for key mappings
opt.updatetime = 200 -- Trigger CursorHold quicker
opt.virtualedit = "block" -- Allow block cursor movement in empty spaces

-- Neovide settings (if using Neovide)
if vim.g.neovide then
  vim.o.guifont = "OperatorMonoLig Nerd Font:h20"
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_cursor_antialiasing = false
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"
  vim.g.neovide_input_ime = true
end

-- Spell check settings
vim.o.spell = false
vim.o.spelllang = "en_us,pt_br"

-- Visual and UI settings
opt.showmode = false -- Don't show mode in the statusline
opt.laststatus = 3 -- Global statusline
opt.winblend = 0 -- No transparency for the window
opt.wrap = false -- Disable line wrapping
opt.linebreak = true -- Wrap lines at word boundaries

-- Ex line and status line options
vim.o.ls = 0
vim.o.ch = 0
vim.o.ruler = false -- Disable default ruler
vim.opt.splitkeep = "screen" -- Keep splits in the same position on resize

-- Miscellaneous settings
opt.showtabline = 0 -- Hide tabline
opt.splitbelow = true -- Open splits below the current window
opt.splitright = true -- Open splits to the right of the current window
-- opt.guicursor = "" -- Disable cursor shape overrides

-- Leader and clipboard setup
vim.g.mapleader = " "
vim.g.maplocalleader = " "
