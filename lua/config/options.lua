-- ========================
-- Basic Neovim Configuration
-- ========================

-- Leader keys
vim.g.mapleader = ' '                    -- Global leader key
vim.g.maplocalleader = ','               -- Local leader key

-- Nerd Font settings
vim.g.have_nerd_font = true              -- Global Nerd Font usage flag

-- Theme & Font settings
vim.opt.guifont = "FiraCode Nerd Font:h12,Maple Mono NF:h12" -- GUI font combination

-- General Neovim options
vim.opt.number = true                    -- Show absolute line numbers
vim.opt.relativenumber = true            -- Show relative line numbers
vim.opt.scrolloff = 10                   -- Vertical scroll offset
vim.opt.sidescrolloff = 8                -- Horizontal scroll offset
vim.opt.splitright = true                -- Open new vertical split to the right
vim.opt.splitbelow = true                -- Open new horizontal split below
vim.opt.signcolumn = "yes"               -- Always show sign column
vim.opt.termguicolors = true             -- Enable 24-bit colors
vim.opt.laststatus = 0                   -- Hide status line globally
vim.opt.cmdheight = 0                    -- Hide command line unless used
vim.opt.updatetime = 250                 -- Faster completion response
vim.opt.timeoutlen = 1000                -- Set leader key delay to 1 second
vim.opt.cursorline = true                -- Highlight current cursor line
vim.opt.cursorlineopt = "number"         -- Highlight line number for cursor
vim.opt.mouse = "a"                      -- Enable mouse support
vim.opt.mousemoveevent = true            -- Track mouse movement events
vim.opt.wrap = false                     -- Disable line wrapping
vim.opt.hidden = true                    -- Allow unsaved buffers in background
vim.opt.clipboard = "unnamedplus"        -- System clipboard integration

-- Indentation
vim.opt.shiftwidth = 2                   -- Indentation for >, < commands
vim.opt.tabstop = 2                      -- Tab size of 2 spaces
vim.opt.softtabstop = 2                  -- Tab key behaves as 2 spaces
vim.opt.expandtab = true                 -- Convert tabs to spaces

-- Search
vim.opt.ignorecase = true                -- Case-insensitive search
vim.opt.smartcase = true                 -- Case-sensitive if uppercase is present
vim.opt.hlsearch = false                 -- Disable search highlighting
vim.opt.incsearch = true                 -- Enable incremental search
vim.opt.gdefault = true                  -- Use `g` flag by default for :substitute

-- Split and window options
vim.opt.splitkeep = "screen"             -- Keep split screens aligned

-- File Handling
vim.opt.swapfile = false                 -- Disable swap files
vim.opt.undofile = true                  -- Enable persistent undo
vim.opt.undodir = vim.fn.stdpath("config") .. "/.undo"

-- Whitespace and lists
vim.opt.list = true                      -- Show whitespace characters
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Enhanced display and command line options
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.inccommand = "split"             -- Live substitution preview
vim.opt.fillchars = { eob = " " }        -- Remove ~ from empty lines
vim.opt.pumheight = 10                   -- Limit popup menu height

-- Filetype-specific indentation settings
vim.cmd [[
  autocmd FileType java,go,c setlocal tabstop=4 shiftwidth=4 expandtab
  autocmd FileType lua,javascript setlocal tabstop=2 shiftwidth=2 expandtab
]]

-- Diff settings
vim.opt.diffopt = "vertical,iwhite"      -- Vertical diff with no whitespace

-- Folding settings
vim.opt.foldmethod = "manual"             -- Define o método de folding como manual
vim.opt.foldenable = false                 -- Desativa o folding automático ao abrir arquivos

