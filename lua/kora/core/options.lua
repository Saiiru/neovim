-- lua/kora/core/options.lua
-- Core Neovim options. Minimal, idempotent, safe defaults.

local fn = vim.fn
local opt = vim.opt
local env = vim.env

-- Create and set undo directory (portable via stdpath)
local undodir = fn.stdpath("data") .. "/undo"
if fn.isdirectory(undodir) == 0 then fn.mkdir(undodir, "p") end
opt.undodir = undodir
opt.undofile = true

-- Detecta suporte a truecolor de forma segura antes de habilitar.
if fn.has("termguicolors") == 1 or (env.COLORTERM and env.COLORTERM:match("truecolor")) then
  opt.termguicolors = true
end
-- --- Core Options ---
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.spell = false
vim.opt.spelllang = { "en_us", "pt_br" }
vim.opt.clipboard = "unnamedplus"


-- UX & terminal
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.signcolumn = "yes"
opt.laststatus = 2
opt.ruler = true
opt.wildmenu = true
opt.cursorline = true
opt.cursorcolumn = true

-- Performance / responsiveness
opt.updatetime = 50
opt.timeout = true
opt.ttimeout = true
opt.ttimeoutlen = 100

-- Scrolling / view
opt.scrolloff = 8
opt.sidescroll = 1
opt.sidescrolloff = 2
opt.display:append({ "lastline", "truncate" })

-- Editing style (VSCode-like defaults where appropriate)
opt.backspace = { "indent", "eol", "start" }
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true
opt.autoindent = true
opt.smarttab = true

-- Numbers
opt.number = true
opt.relativenumber = true

-- Disable swap/backup files
opt.swapfile = false
opt.backup = false

-- Search
opt.hlsearch = false
opt.incsearch = true
opt.formatoptions:append("j")

-- Folding (keep open by default)
opt.foldmethod = "syntax"
opt.foldlevel = 99

-- File handling / history
opt.autoread = true
opt.history = 1000
opt.viminfo:append("!")

-- Session/view safety
opt.sessionoptions:remove("options")
opt.viewoptions:remove("options")

-- Listchars: must be exactly two display chars for 'tab'
opt.listchars = {
  tab = ">-",
  trail = "-",
  extends = ">",
  precedes = "<",
  nbsp = "+",
}
opt.list = true

-- Filename recognition tweak
opt.isfname:append("@-@")

-- Visual column guide
opt.colorcolumn = "80"

-- Small keymap niceties (undo granularity)
vim.keymap.set("i", "<C-U>", "<C-G>u<C-U>", { desc = "Undo (Ctrl-U)", noremap = true, silent = true })
vim.keymap.set("i", "<C-W>", "<C-G>u<C-W>", { desc = "Undo (Ctrl-W)", noremap = true, silent = true })

-- Custom commands / mappings
vim.cmd([[
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
]])
if fn.exists(":DiffOrig") ~= 2 then
  vim.cmd([[
    command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
  ]])
end



