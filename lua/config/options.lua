local cmd = vim.cmd
local opt = vim.opt
local g = vim.g

-- General Options
opt.number = true                    -- Show line numbers
opt.relativenumber = true            -- Show absolute line numbers
opt.shiftwidth = 2                   -- Size of an indentation
opt.softtabstop = 2                  -- Size of a soft tab
opt.tabstop = 2                      -- Size of a tab
opt.expandtab = true                 -- Convert tabs to spaces
opt.wrap = false                     -- Disable line wrapping
opt.smartindent = true               -- Enable smart indentation
opt.scrolloff = 8                    -- Lines to keep above and below cursor
opt.cursorline = true                -- Highlight the current line
opt.termguicolors = true             -- Enable true colors support
opt.signcolumn = "yes"               -- Always show the sign column

-- Folds Settings
opt.foldmethod = "indent"            -- Fold based on indentation
opt.foldlevelstart = 99              -- Start with all folds open

-- Appearance
opt.cmdheight = 2                    -- Height of command line
opt.laststatus = 3                    -- Show status line always
opt.showtabline = 2                   -- Always show tabs
opt.guifont = "FiraCode Nerd Font:h17, Maple Mono NF:h17" -- Font for GUI Neovim

-- Clipboard and File Encoding
opt.clipboard = "unnamedplus"        -- Use system clipboard
opt.fileencoding = "utf-8"           -- File encoding

-- Search Settings
opt.hlsearch = true                   -- Highlight all matches on previous search pattern
opt.ignorecase = true                 -- Ignore case in search patterns
opt.smartcase = true                  -- Smart case for search
opt.incsearch = true                  -- Incremental search

-- Split Windows
opt.splitbelow = true                 -- Split horizontal windows below
opt.splitright = true                 -- Split vertical windows to the right

-- Update and Backups
opt.backup = false                    -- Disable backup file
opt.writebackup = false               -- Disable write backup
opt.swapfile = false                  -- Disable swapfile
opt.updatetime = 300                  -- Faster completion

-- Mouse Support
opt.mouse = "a"                       -- Enable mouse support

-- List Characters
opt.list = true
opt.listchars = {
    tab = "→ ",
    eol = "¬",
    trail = "⋅",
    extends = "❯",
    precedes = "❮",
}
opt.showbreak = "↪"

-- Auto Commands
-- Enable wrap for markdown files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        opt.wrap = true                -- Enable wrap for markdown files
        opt.linebreak = true           -- Break lines at word boundaries
    end,
})

-- Disable auto-commenting on new lines
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "r", "o" })
    end,
})

-- File Types and Indentation Settings
cmd("autocmd BufNewFile,BufRead *.go set filetype=go")

-- Specific Filetype Indentation
cmd("autocmd FileType html setlocal sw=2 ts=2 sts=2")
cmd("autocmd FileType ruby setlocal sw=2 ts=2 sts=2")
cmd("autocmd FileType javascript setlocal sw=2 ts=2 sts=2")
cmd("autocmd FileType xml setlocal sw=2 ts=2 sts=2")
cmd("autocmd FileType python setlocal sw=4 ts=4 sts=4")
cmd("autocmd FileType go setlocal sw=4 ts=4 sts=4")

-- Highlight Settings
vim.cmd [[
    highlight Comment gui=italic
    highlight Keyword gui=italic
    highlight StorageModifier gui=italic
    highlight StorageType gui=italic
    highlight EntityNameType gui=bold
    highlight EntityNameSection gui=italic,bold
]]

-- Desativar itálico para certos escopos
vim.cmd [[
    autocmd Syntax * syntax clear Invalid
    autocmd Syntax * syntax clear KeywordOperator
    autocmd Syntax * syntax clear ConstantNumeric
    autocmd Syntax * syntax clear CommentBlock
]]
-- let g:nvim_tree_auto_close=1
-- Workaround for deprecated nvim_tree_auto_close option
g.nvim_tree_auto_close = 1
