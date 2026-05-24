-- lua/config/options.lua

local cmd = vim.cmd
local opt = vim.opt

cmd("let g:netrw_liststyle = 3")
cmd("filetype plugin indent on")

-- Basic Settings
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.wrap = false
opt.cmdheight = 1
opt.spelllang = { "en_us", "pt_br" }

-- Tabbing / Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- Search Settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true
opt.inccommand = "split"
opt.wrapscan = false

-- Visual Settings
opt.termguicolors = true
opt.signcolumn = "yes"
opt.colorcolumn = "100"
opt.showmatch = true
opt.matchtime = 2
opt.completeopt = "menuone,noinsert,noselect"
opt.showmode = false
opt.pumheight = 10
opt.pumblend = 10
opt.winblend = 0
opt.conceallevel = 2
opt.concealcursor = ""
opt.redrawtime = 10000
opt.maxmempattern = 20000
opt.synmaxcol = 300
opt.laststatus = 3
opt.showtabline = 0
opt.winborder = "bold"
opt.cursorcolumn = false
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "" }

-- File Handling
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 300
opt.timeoutlen = 500
opt.ttimeoutlen = 0
opt.autoread = true
opt.autowrite = false
opt.diffopt:append("vertical")
opt.diffopt:append("algorithm:patience")
opt.diffopt:append("linematch:60")

local undodir = "~/.local/share/nvim/undodir"
opt.undodir = vim.fn.expand(undodir)
local undodir_path = vim.fn.expand(undodir)
if vim.fn.isdirectory(undodir_path) == 0 then
  pcall(vim.fn.mkdir, undodir_path, "p")
end

-- Behavior Settings
opt.fileencoding = "utf-8"
opt.errorbells = false
opt.backspace = "indent,eol,start"
opt.autochdir = false
opt.hidden = true
opt.whichwrap = "b,s,<,>,[,],h,l"
opt.virtualedit = "block"
opt.iskeyword:append("-,_")
opt.path:append("**")
opt.selection = "inclusive"
opt.mouse = "a"
opt.clipboard:append("unnamedplus")
-- `modifiable` já é true por padrão; manter a linha só aumentava ruído.
opt.encoding = "UTF-8"
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildignorecase = true
opt.wildignore:append({
  ".git",
  ".hg",
  ".svn",
  ".DS_Store",
  "*.aux",
  "*.class",
  "*.dll",
  "*.exe",
  "*.o",
  "*.obj",
  "*.orig",
  "*.out",
  "*.pyc",
  "*.pyd",
  "*.pyo",
  "*.so",
  "*.swp",
  "*.swo",
  "*.toc",
  "build",
  "dist",
  "node_modules",
  "target",
})
opt.suffixesadd:append({
  ".c",
  ".cpp",
  ".h",
  ".hpp",
  ".java",
  ".lua",
  ".md",
  ".py",
  ".rs",
  ".ts",
  ".tsx",
})

-- Cursor Settings
opt.guicursor = {
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
  "sm:block-blinkwait175-blinkoff150-blinkon175",
}

-- Folding Settings
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

-- Split Behavior
opt.splitbelow = true
opt.splitright = true
