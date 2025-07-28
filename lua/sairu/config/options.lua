-- Configuration Options - BATMAN VEGA System Parameters
-- =====================================================

local opt = vim.opt

-- Interface Configuration Matrix
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false
opt.linebreak = true
opt.showbreak = "↪ "
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.laststatus = 3
opt.showtabline = 2
opt.cmdheight = 1
opt.showcmd = true
opt.showmode = false
opt.ruler = true

-- Visual Enhancement Protocols
opt.termguicolors = true
opt.background = "dark"
opt.winblend = 0
opt.pumblend = 5
opt.pumheight = 15

-- Indentation Matrix
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search Enhancement Systems
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = true

-- Split Behavior Protocols
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"

-- Performance Optimization Matrix
opt.updatetime = 300
opt.timeoutlen = 500
opt.redrawtime = 10000
opt.maxmempattern = 20000
opt.synmaxcol = 240
opt.lazyredraw = false

-- File Management Systems
opt.undofile = true
opt.undolevels = 10000
opt.undoreload = 10000
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Mouse and Input Configuration
opt.mouse = "a"
opt.mousemodel = "popup"
opt.selection = "exclusive"
opt.selectmode = "mouse,key"

-- Special Character Display Matrix
opt.list = false
opt.listchars = {
  tab = "→ ",
  eol = "↲",
  nbsp = "␣",
  trail = "•",
  extends = "⟩",
  precedes = "⟨",
}

opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = " ",
  foldsep = " ",
  foldclose = " ",
  diff = "╱",
  vert = "│",
  horiz = "─",
}

-- Folding Configuration
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = false

-- Wildmenu Enhancement
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildoptions = "pum"

-- Format Options Control
opt.formatoptions:remove({ "c", "r", "o" })
opt.formatoptions:append({ "j" })

-- Miscellaneous Enhancement Protocols
opt.conceallevel = 0
opt.concealcursor = "nc"
opt.virtualedit = "block"
opt.whichwrap = "bs<>[]hl"
opt.backspace = "indent,eol,start"
opt.iskeyword:append("-")

-- Session Management
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- Spell Checking (Disabled by default)
opt.spell = false
opt.spelllang = { "en_us", "pt_br" }
