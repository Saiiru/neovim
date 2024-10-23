-- ----------------------------------------
-- Neovim Configuration
-- ----------------------------------------

-- Globals --------------------------------------------------------------------
vim.g.mapleader = " " -- Set leader key.
vim.g.maplocalleader = "," -- Set local leader key.
-- vim.g.default_colorscheme = "tokyonight-night"  -- Default colorscheme
vim.g.have_nerd_font = true -- Set to true if you have a Nerd Font installed

-- Theme & Font settings ------------------------------------------------------
vim.opt.guifont = "FiraCode Nerd Font:h12,Maple Mono NF:h12" -- Combine fonts for GUI.

-- Options --------------------------------------------------------------------
vim.opt.breakindent = true -- Wrap indent to match line start.
vim.opt.clipboard = "unnamedplus" -- Connection to the system clipboard.
vim.opt.cmdheight = 0 -- Hide command line unless needed.
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Completion options.
vim.opt.cursorline = true -- Highlight the cursor line.
vim.opt.expandtab = true -- Convert tabs to spaces.
vim.opt.fileencoding = "utf-8" -- File content encoding.
vim.opt.fillchars = { eob = " " } -- Hide `~` on empty lines.
vim.opt.foldenable = true -- Enable folding (with nvim-ufo).
vim.opt.foldlevel = 99 -- Start with all code unfolded.
vim.opt.foldcolumn = "1" -- Show fold column.
vim.opt.ignorecase = true -- Case insensitive searching.
vim.opt.smartcase = true -- Enable smart case searching.
vim.opt.infercase = true -- Infer cases in keyword completion.
vim.opt.laststatus = 3 -- Global statusline.
vim.opt.number = true -- Show line numbers.
vim.opt.relativenumber = true -- Relative line numbers.
vim.opt.pumheight = 10 -- Pop-up menu height.
vim.opt.shiftwidth = 2 -- Indentation amount for < and >.
vim.opt.signcolumn = "yes" -- Always show the sign column.
vim.opt.splitbelow = true -- Open new windows below.
vim.opt.splitright = true -- Open new windows to the right.
vim.opt.tabstop = 2 -- Number of spaces a tab counts for.
vim.opt.termguicolors = true -- Enable 24-bit colors.
vim.opt.undofile = true -- Persistent undo.
vim.opt.wrap = false -- Disable line wrapping.

-- Scroll Options -------------------------------------------------------------
vim.opt.scrolloff = 10 -- Minimal number of lines above/below cursor.
vim.opt.sidescrolloff = 8 -- Same for side scrolling.
vim.opt.mousescroll = "ver:1,hor:0" -- Disable horizontal scroll.

-- Display Whitespace Characters ---------------------------------------------
vim.opt.list = true -- Show whitespace characters.
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Case Insensitive Search and Incremental Search -----------------------------
vim.opt.hlsearch = false -- Disable search highlighting.
vim.opt.incsearch = true -- Enable incremental search.

-- Filetype-specific Tab Settings --------------------------------------------
vim.cmd([[
  autocmd FileType java,go,c setlocal tabstop=4 shiftwidth=4 expandtab
  autocmd FileType lua,javascript setlocal tabstop=2 shiftwidth=2 expandtab
]])

-- Undo Directory -------------------------------------------------------------
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Miscellaneous --------------------------------------------------------------
vim.opt.swapfile = false -- Disable swap files.
vim.opt.updatetime = 250 -- Faster completion.
vim.opt.timeoutlen = 300 -- Shorten mapped sequence wait time.
vim.opt.cursorline = true -- Highlight cursor line.

-- Schedule clipboard sync to avoid startup delays ---------------------------
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
