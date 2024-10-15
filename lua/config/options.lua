local cmd = vim.cmd
local opt = vim.opt

-- General Options
opt.number = true
opt.relativenumber = false
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.expandtab = true
opt.wrap = true
opt.smartindent = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cmdheight = 2
opt.laststatus = 3
opt.showtabline = 2
opt.guifont = "FiraCode Nerd Font:h17, Maple Mono NF:h17"
opt.clipboard = "unnamedplus"
opt.fileencoding = "utf-8"
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.splitbelow = true
opt.splitright = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.updatetime = 300
opt.mouse = "a"
opt.linebreak = true
opt.pumheight = 10
opt.showmode = false
opt.timeoutlen = 300
opt.undofile = true
opt.numberwidth = 4
opt.whichwrap = "bs<>[]hl"
opt.completeopt = { "menuone", "noselect" }
opt.conceallevel = 0
opt.list = true
opt.listchars = { tab = "→ ", eol = "¬", trail = "⋅", extends = "❯", precedes = "❮" }
opt.showbreak = "↪"

-- Auto Commands
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        opt.wrap = true
        opt.linebreak = true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "r", "o" })
    end,
})

cmd("autocmd BufNewFile,BufRead *.go set filetype=go")
cmd("autocmd FileType html,ruby,javascript,xml setlocal sw=2 ts=2 sts=2")
cmd("autocmd FileType python,go setlocal sw=4 ts=4 sts=4")

-- Highlight Settings
vim.cmd [[
    highlight Comment gui=italic
    highlight Keyword gui=italic
    highlight StorageModifier gui=italic
    highlight StorageType gui=italic
    highlight EntityNameType gui=bold
    highlight EntityNameSection gui=italic,bold
]]

vim.cmd [[
    autocmd Syntax * syntax clear Invalid
    autocmd Syntax * syntax clear KeywordOperator
    autocmd Syntax * syntax clear ConstantNumeric
    autocmd Syntax * syntax clear CommentBlock
]]

-- Additional Options
vim.opt.shortmess:append "c"
vim.opt.iskeyword:append "-"
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")
