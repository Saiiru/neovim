-- Left Column and Cursor Settings
vim.opt.number = true            -- display line numbers
vim.opt.relativenumber = true     -- display relative line numbers
vim.opt.numberwidth = 2           -- set width of line number column
vim.opt.signcolumn = "yes"        -- always show sign column
vim.opt.wrap = false              -- display lines as single line
vim.opt.scrolloff = 8             -- number of lines to keep above/below cursor
vim.opt.sidescrolloff = 8         -- number of columns to keep to the left/right of cursor
vim.opt.cursorline = true         -- highlight current line
vim.opt.guicursor = {             -- customize cursor appearance
  "n-v-c:block",                  -- normal, visual, command-line: block cursor
  "i-ci-ve:ver25",                -- insert, command-line insert, visual-exclude: vertical bar cursor (25% width)
  "r-cr:hor20",                   -- replace, command-line replace: horizontal bar cursor (20% height)
  "o:hor50",                      -- operator-pending: horizontal bar cursor (50% height)
  "a:blinkwait700-blinkoff400-blinkon250", -- all modes: blinking settings
  "sm:block-blinkwait175-blinkoff150-blinkon175" -- showmatch: block cursor with specific blinking settings
}

-- Tab Spacing and Indentation
vim.opt.expandtab = true          -- convert tabs to spaces
vim.opt.shiftwidth = 4            -- number of spaces inserted for each indentation level
vim.opt.tabstop = 4               -- number of spaces inserted for tab character
vim.opt.softtabstop = 4           -- number of spaces inserted for <Tab> key
vim.opt.smartindent = true        -- enable smart indentation
vim.opt.breakindent = true        -- enable line breaking indentation

-- General Behavior
vim.opt.mouse = "a"               -- enable mouse support
vim.opt.showmode = true          -- hide mode display
vim.opt.splitbelow = true         -- force horizontal splits below current window
vim.opt.splitright = true         -- force vertical splits right of current window
vim.opt.termguicolors = true      -- enable terminal GUI colors
vim.opt.clipboard = "unnamedplus" -- enable system clipboard access
vim.opt.undofile = true           -- enable persistent undo
vim.opt.updatetime = 250          -- set faster completion update time
vim.opt.timeoutlen = 1000         -- set timeout for mapped sequences
vim.opt.backup = false            -- disable backup file creation
vim.opt.writebackup = false       -- prevent editing of files being edited elsewhere
vim.opt.swapfile = false          -- disable swapfile creation
vim.opt.foldlevel = 99            -- set folding level
vim.opt.foldlevelstart = 99       -- start with all folds open
vim.opt.foldenable = true         -- enable folding
vim.opt.foldcolumn = "0"          -- fold column width
vim.opt.foldnestmax = 5           -- maximum nesting of folds
vim.opt.foldtext = ""             -- customize fold text display
vim.opt.conceallevel = 0

-- Searching Behavior
vim.opt.hlsearch = true           -- highlight all search matches
vim.opt.ignorecase = true         -- ignore case in search
vim.opt.smartcase = true          -- match case if explicitly stated
vim.opt.incsearch = true          -- enable incremental search

-- Visual Enhancements
vim.opt.colorcolumn = "80"        -- place a column line at character 80
vim.opt.termguicolors = true      -- enable 24-bit colors

-- Highlighting for Italics and Bold
vim.cmd([[
  highlight Comment cterm=italic gui=italic
  highlight Keyword cterm=bold gui=bold
  highlight Function cterm=bold,italic gui=bold,italic
]])

 vim.g.netrw_liststyle = 3

-- System Config
vim.g.mapleader = " "             -- set leader key to space
vim.g.maplocalleader = " "

