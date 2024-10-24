-- Leader keys
vim.g.mapleader = ' '                -- Global leader key
vim.g.maplocalleader = ','           -- Local leader key

-- Nerd Font settings
vim.g.have_nerd_font = true           -- Enable Nerd Font usage

-- Theme & Font settings
vim.opt.guifont = "FiraCode Nerd Font:h12,Maple Mono NF:h12" -- GUI font combination

-- General Neovim options
vim.opt.breakindent = true            -- Break indent matching line start
vim.opt.clipboard = "unnamedplus"     -- System clipboard integration
vim.opt.cmdheight = 0                 -- Hide command line unless used
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Completion behavior
vim.opt.cursorline = true             -- Highlight current cursor line
vim.opt.expandtab = true              -- Convert tabs to spaces
vim.opt.fileencoding = "utf-8"        -- File encoding set to UTF-8
vim.opt.fillchars = { eob = " " }     -- Remove `~` from empty lines
vim.opt.foldenable = true             -- Enable folding (for plugins like nvim-ufo)
vim.opt.foldlevel = 99                -- Start with code unfolded
vim.opt.foldcolumn = "1"              -- Enable fold column
vim.opt.ignorecase = true             -- Case-insensitive searching
vim.opt.smartcase = true              -- Case-sensitive if uppercase present
vim.opt.infercase = true              -- Infer case during completion
vim.opt.laststatus = 3                -- Global statusline
vim.opt.number = true                 -- Show absolute line numbers
vim.opt.relativenumber = true         -- Relative line numbers
vim.opt.pumheight = 10                -- Popup menu height
vim.opt.shiftwidth = 2                -- Indentation amount
vim.opt.signcolumn = "yes"            -- Always show sign column
vim.opt.splitbelow = true             -- Splits open below
vim.opt.splitright = true             -- Splits open on the right
vim.opt.tabstop = 2                   -- Tab size of 2 spaces
vim.opt.termguicolors = true          -- Enable 24-bit colors
vim.opt.undofile = true               -- Enable persistent undo
vim.opt.wrap = false                  -- Disable line wrapping
vim.opt.swapfile = false

-- Scroll Options
vim.opt.scrolloff = 10                -- Vertical scroll offset
vim.opt.sidescrolloff = 8             -- Horizontal scroll offset

-- Display whitespace characters
vim.opt.list = true                   -- Show whitespace
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Undo Directory
vim.opt.undodir = vim.fn.stdpath("config") .. "/.undo"

-- Mouse and Clipboard
vim.opt.mouse = 'a'                   -- Enable mouse support
vim.opt.hidden = true                 -- Keep unsaved buffers hidden
vim.opt.timeoutlen = 300              -- Decrease mapping timeout
vim.opt.updatetime = 250              -- Faster completion response

-- Search
vim.opt.hlsearch = false              -- Disable search highlighting
vim.opt.incsearch = true              -- Enable incremental search

-- Filetype-specific settings
vim.cmd [[
  autocmd FileType java,go,c setlocal tabstop=4 shiftwidth=4 expandtab
  autocmd FileType lua,javascript setlocal tabstop=2 shiftwidth=2 expandtab
]]

-- Substitute/replace always using global flag
vim.opt.gdefault = true

-- Configure splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Diff settings (vertical, no whitespace)
vim.opt.diffopt = "vertical,iwhite"

-- Reduce status and command line visibility
vim.opt.laststatus = 0
vim.opt.cmdheight = 0

-- Enhance Neovim experience
vim.opt.inccommand = 'split'          -- Live substitution preview
vim.opt.signcolumn = 'yes'            -- Keep sign column visible

-- Set Nerd Font status globally
vim.g.have_nerd_font = true

