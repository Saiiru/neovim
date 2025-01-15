-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Neovim Basic Settings
vim.o.hlsearch = true -- Enable search highlighting
vim.o.number = true -- Show line numbers
vim.o.relativenumber = true -- Show relative line numbers
-- vim.o.mouse = "" -- Disable mouse mode
vim.o.breakindent = true -- Enable break indent
vim.o.undofile = true -- Enable undo history
vim.o.ignorecase = true -- Case insensitive searching
vim.o.smartcase = true -- Case sensitive if uppercase letter used
vim.o.updatetime = 250 -- Reduce update time for faster UI updates
vim.wo.signcolumn = "yes" -- Always show sign column
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- Colorscheme & UI
-- vim.cmd.colorscheme("catppuccin") -- Set colorscheme
vim.o.termguicolors = true -- Enable 24-bit color support
vim.o.cursorline = true -- Highlight the current line
-- vim.o.fillchars = { eob = " ", fold = " ", foldopen = "", foldclose = "", lastline = " " } -- Hide end-of-buffer characters
vim.opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- File & Buffer Management
vim.o.hidden = true -- Allow unsaved buffers to stay open
vim.o.swapfile = false -- Disable swap files
vim.o.backup = false -- Disable backups
vim.o.writebackup = false -- Disable write backup
vim.o.autowrite = true -- Auto-write before switching buffers
vim.o.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo" -- Persistent undo directory

-- Completion & Search
vim.o.completeopt = "menuone,noselect" -- Better completion experience
vim.o.incsearch = true -- Incremental search
vim.o.inccommand = "nosplit" -- Preview substitutions
vim.o.grepformat = "%f:%l:%c:%m" -- Grep output format
vim.o.grepprg = "rg --vimgrep" -- Use ripgrep for grep

-- Indentation & Formatting
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.shiftwidth = 2 -- Indentation width
vim.o.tabstop = 2 -- Tab width
vim.o.softtabstop = 2 -- Soft tab width
vim.o.smartindent = true -- Enable smart indenting
vim.o.shiftround = true -- Round indent to multiple of shiftwidth

-- Folding
vim.o.foldmethod = "expr" -- Use expression-based folding
vim.o.foldlevel = 99 -- Show all folds by default
vim.o.foldtext = "v:lua.require'utils.ui'.foldtext()" -- Custom fold text function

-- Window Splits & Layouts
vim.o.splitbelow = true -- Open splits below the current window
vim.o.splitright = true -- Open splits to the right of the current window
vim.o.scrolloff = 8 -- Lines to scroll before reaching top/bottom
vim.o.sidescrolloff = 8 -- Columns to scroll before reaching left/right

-- Keymaps
vim.g.mapleader = " " -- Set leader key to space
vim.g.maplocalleader = "\\" -- Set local leader key

-- Enable or Disable Providers
vim.g.loaded_ruby_provider = 0 -- Disable Ruby provider
vim.g.loaded_perl_provider = 0 -- Disable Perl provider

-- General Performance Settings
vim.o.timeoutlen = 300 -- Faster timeout for key mappings
vim.o.updatetime = 200 -- Quicker CursorHold updates

-- Visual & UI Tweaks
vim.o.showmode = false -- Disable mode show in the statusline
vim.o.laststatus = 3 -- Use global statusline
vim.o.showtabline = 0 -- Hide tabline
vim.o.winblend = 0 -- No transparency
vim.o.cmdheight = 0 -- Minimal command line height
vim.o.linebreak = true -- Wrap lines at word boundaries
vim.o.ruler = false -- Disable default ruler
vim.o.splitkeep = "screen" -- Keep splits in the same position on resize

-- Neovide settings (if using Neovide)
if vim.g.neovide then
  vim.o.guifont = "OperatorMonoLig Nerd Font:h20"
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_cursor_antialiasing = false
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"
  vim.g.neovide_input_ime = true
end

-- Setup for clipboard (disable clipboard on SSH)
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

-- Improve startup performance
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.syntax = "enable"
-- Add binaries installed by mason.nvim to PATH
-- vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, vim.g.path_separator)
--   .. vim.g.path_delimiter
--   .. vim.env.PATH
