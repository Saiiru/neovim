-- ----------------------------------------
-- Neovim Configuration
-- ----------------------------------------

-- Globals --------------------------------------------------------------------
vim.g.mapleader = ' '                -- Set leader key.
vim.g.maplocalleader = ','           -- Set default local leader key.
vim.g.default_colorscheme = "tokyonight-night"  -- Default colorscheme
vim.g.have_nerd_font = true           -- Set to true if you have a Nerd Font installed

-- Theme & Font settings
vim.opt.guifont = "FiraCode Nerd Font:h12" -- Set GUI font
vim.opt.guifont = "Maple Mono NF:h12"      -- Set italics font for GUI

-- Options --------------------------------------------------------------------
-- General settings
vim.opt.breakindent = true              -- Wrap indent to match line start.
vim.opt.clipboard = "unnamedplus"       -- Connection to the system clipboard.
vim.opt.cmdheight = 0                    -- Hide command line unless needed.
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Options for insert mode completion.
vim.opt.copyindent = true                -- Copy previous indentation on autoindenting.
vim.opt.cursorline = true                -- Highlight the text line of the cursor.
vim.opt.expandtab = true                 -- Enable the use of spaces instead of tabs.
vim.opt.fileencoding = "utf-8"          -- File content encoding for the buffer.
vim.opt.fillchars = { eob = " " }        -- Disable `~` on nonexistent lines.
vim.opt.foldenable = true                -- Enable fold for nvim-ufo.
vim.opt.foldlevel = 99                   -- Set highest foldlevel for nvim-ufo.
vim.opt.foldlevelstart = 99              -- Start with all code unfolded.
vim.opt.foldcolumn = "1"                 -- Show foldcolumn in nvim 0.9+.
vim.opt.ignorecase = true                -- Case insensitive searching.
vim.opt.infercase = true                 -- Infer cases in keyword completion.
vim.opt.laststatus = 3                    -- Global statusline.
vim.opt.linebreak = true                  -- Wrap lines at 'breakat'.
vim.opt.number = true                     -- Show numberline.
vim.opt.relativenumber = true             -- Show relative numberline.
vim.opt.preserveindent = true             -- Preserve indent structure as much as possible.
vim.opt.pumheight = 10                    -- Height of the pop up menu.
vim.opt.shiftwidth = 2                    -- Number of space inserted for indentation.
vim.opt.showmode = false                  -- Disable showing modes in command line.
vim.opt.signcolumn = "yes"                -- Always show the sign column.
vim.opt.smartcase = true                  -- Case-sensitive searching.
vim.opt.splitbelow = true                 -- Splitting a new window below the current one.
vim.opt.splitright = true                 -- Splitting a new window at the right of the current one.
vim.opt.tabstop = 2                       -- Number of spaces in a tab.
vim.opt.termguicolors = true              -- Enable 24-bit RGB color in the TUI.
vim.opt.undofile = true                   -- Enable persistent undo between sessions.
vim.opt.updatetime = 300                  -- Length of time to wait before triggering the plugin.
vim.opt.wrap = false                      -- Disable wrapping of lines longer than the width of the window.

-- Configure tabs based on file types
vim.cmd [[
  autocmd FileType java setlocal tabstop=4 shiftwidth=4 expandtab
  autocmd FileType lua setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd FileType c setlocal tabstop=4 shiftwidth=4 expandtab
  autocmd FileType go setlocal tabstop=4 shiftwidth=4 expandtab
]]

-- Mouse and Scroll options
vim.opt.mouse = 'a'                    -- Enable mouse mode
vim.opt.scrolloff = 20                  -- Number of lines to leave before/after the cursor when scrolling.
vim.opt.sidescrolloff = 8               -- Same for side scrolling.
vim.opt.mousescroll = "ver:1,hor:0"     -- Disables horizontal scroll in Neovim

-- Whitespace characters
vim.opt.list = true                     -- Show whitespace characters
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Additional options
vim.opt.hlsearch = false                 -- Disable highlight on search
vim.opt.incsearch = true                 -- Incremental search
vim.opt.termguicolors = true            -- Enable true color support

-- Save undo history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"  -- Undo directory
vim.opt.undofile = true                  -- Enable persistent undo

-- Enable line numbers
vim.opt.number = true                    -- Show line numbers
vim.opt.relativenumber = true            -- Show relative line numbers
vim.opt.cursorline = true                -- Highlight the line where the cursor is

-- Sync clipboard between OS and Neovim
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'      -- Sync clipboard
end)

-- Set auto indentation
vim.opt.autoindent = true                -- Enable auto indent
vim.opt.smartindent = true                -- Enable smart indent

-- Miscellaneous options
vim.opt.scrolloff = 10                   -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.signcolumn = 'yes'               -- Keep signcolumn on by default
vim.opt.updatetime = 250                  -- Decrease update time

-- Ensure that comments are treated well
vim.opt.formatoptions:append { "r" }     -- Add asterisks in block comments

