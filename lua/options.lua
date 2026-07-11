-- settings.options
--

local o          = vim.o
local cache      = vim.g.nvim_cache

o.termguicolors  = true  -- True color support
o.spell          = false -- Spell check
o.errorbells     = false -- Shut up
o.timeoutlen     = 300   -- Timeout for keycodes
o.lazyredraw     = false -- Redraw only when necessary

-- Backups
o.backup         = true
o.backupdir      = cache .. "/backup"

-- Swap
o.swapfile       = false
o.directory      = cache .. "/swap"

-- Undo
o.undofile       = true
o.undodir        = cache .. "/undo"
o.undolevels     = 10000

-- Files
o.autowrite      = true -- Enable auto write
o.autoread       = true -- Read files changed outside of neovim
o.hidden         = true -- Allow switching buffers with unsaved changes

-- Input
o.backspace      = "indent,eol,start" -- Traditional backspace behavior
-- o.clipboard   = "unnamedplus"      -- Sync with system clipboard
o.mouse          = "a"                -- Enable mouse support for all modes

-- Status
o.laststatus     = 3     -- Last window status line: always and only
o.showcmd        = false -- show partial command in last line or screen
o.showmode       = false -- If in Insert, Replace or Visual mode put a message on the last line.
o.signcolumn     = "yes" -- Show gutter

-- Folding
o.foldenable     = true                         -- Enable folds
-- o.foldclose   = "all"
o.foldexpr       = 'nvim_treesitter#foldexpr()' -- Treesitter folding
o.foldmethod     = 'expr'                       -- Treesitter folding

-- Completion
o.completeopt    = "menu,menuone,noselect" -- Completion options

-- Search
o.hlsearch       = true      -- highlight search results
o.incsearch      = true      -- Show search matches as you type
o.ignorecase     = true      -- Needed for smartcase
o.smartcase      = true      -- Case is ignored unless a capital letter is used explicitly
o.infercase      = true      -- 'smartcase' for completion
o.inccommand     = "nosplit" -- preview incremental substitutes
o.showmatch      = true      -- Show matching brackets

-- Line numbers 
o.number         = true -- Show line numbers
o.relativenumber = true -- Use relative line numbers

-- Lines and columns
o.ruler          = true -- Show the line and column number of the cursor position, separated by a comma.
o.cursorline     = true -- Higlight line of cursor
o.cursorcolumn   = true -- Highlight column of cursor


-- Indentation
o.autoindent     = true -- Copy indent from current line when starting new
o.shiftround     = true -- Round indent
o.smartindent    = true -- Insert indents automatically

-- Tabs
o.expandtab      = true -- expand tabs into spaces
o.shiftwidth     = 2    -- Size of an indent
o.softtabstop    = 4    -- Number of spaces a tab counts for
o.tabstop        = 4    -- Number of spaces a tab counts for

-- Scrolling
o.scrolloff      = 20   -- Lines of context
o.sidescrolloff  = 20   -- Columns of context
o.sidescroll     = 1    -- Columns to scroll horizontally
o.smoothscroll   = true -- Smooth scrolling

-- Splits
o.splitbelow     = true -- Always open splits below the current windowop
o.splitright     = true -- Always open splits to the right of the current windowop

-- Windows
o.winminheight   = 0 -- Allow maximized windows
o.winminwidth    = 0 -- Allow maximized windows

-- Text
o.wrap           = false -- Do not wrap text
o.textwidth      = 0     -- Unlimited text width
o.startofline    = true  -- Place cursor at start of line for certain commands e.g. S-g, gg, Ctrl-U, Ctrl-D
o.wrapmargin     = 0

-- Syntax
o.conceallevel   = 3 -- Custom replacement charaters

-- Menu
o.wildignorecase = true
o.wildmenu       = true -- Enhanced command line completion
o.wildmode       = "longest,list,full"
o.wildignore     = ".git/**,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**"

-- Sessions
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
