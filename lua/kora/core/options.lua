-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                        KORA SYSTEM PARAMETERS                          ║
-- ║                      NEURAL CONFIGURATION MATRIX                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local opt = vim.opt

-- ═════════════════ VISUAL ENHANCEMENT PROTOCOLS ═════════════════
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.pumheight = 15
opt.pumblend = 10
opt.winblend = 0
opt.conceallevel = 0
opt.concealcursor = "nc"
opt.laststatus = 3
opt.showtabline = 2
opt.showmode = false
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorcolumn = false

-- ═════════════════ SCROLLING & WRAP BEHAVIOR ════════════════════
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smoothscroll = true
opt.wrap = false
opt.linebreak = true
opt.showbreak = "↪ "
opt.whichwrap = "bs<>[]hl"
opt.virtualedit = "block"

-- ═════════════════ INDENTATION PROTOCOLS ════════════════════════
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true

-- ═════════════════ SEARCH ENHANCEMENT ═══════════════════════════
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- ═════════════════ PERFORMANCE OPTIMIZATION ═════════════════════
opt.updatetime = 200
opt.timeoutlen = 300
opt.redrawtime = 10000
opt.maxmempattern = 20000
opt.synmaxcol = 240
opt.lazyredraw = false

-- ═════════════════ FILE OPERATIONS & SESSIONS ═══════════════════
opt.undofile = true
opt.undolevels = 10000
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.autoread = true
opt.autowrite = true
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- ═════════════════ SPLITS & WINDOWS ════════════════════════════
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"
opt.equalalways = false
opt.winminheight = 0
opt.winminwidth = 0

-- ═════════════════ MOUSE & INPUT ═══════════════════════════════
opt.mouse = "a"
opt.mousemodel = "popup"
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full"
opt.wildoptions = "pum"

-- ═════════════════ SPECIAL CHARS & FILLCHARS ══════════════════
opt.list = false
opt.listchars = { tab = "→ ", eol = "↲", nbsp = "␣", trail = "•", extends = "⟩", precedes = "⟨" }
opt.fillchars =
	{ eob = " ", fold = " ", foldopen = " ", foldsep = " ", foldclose = " ", diff = "╱", vert = "│", horiz = "─" }

-- ═════════════════ FOLDING ════════════════════════════════════
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- ═════════════════ FORMAT OPTIONS ═════════════════════════════
opt.formatoptions:remove({ "c", "r", "o" })
opt.formatoptions:append({ "j", "n" })

-- ═════════════════ SPELL & DIFF ══════════════════════════════
opt.spell = false
opt.spelllang = { "en_us", "pt_br" }
opt.spelloptions = "camel"
opt.diffopt:append("linematch:60")

-- ═════════════════ BACKUP & RECOVERY (CACHE) ═════════════════
local cache_dir = os.getenv("HOME") .. "/.cache/nvim"
opt.undodir = cache_dir .. "/undo"
opt.directory = cache_dir .. "/swap"
opt.backupdir = cache_dir .. "/backup"
opt.viewdir = cache_dir .. "/view"
for _, dir in pairs({ opt.undodir:get()[1], opt.directory:get()[1], opt.backupdir:get()[1], opt.viewdir:get()[1] }) do
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end
end

-- ═════════════════ GLOBAL VARIABLES & PROVIDERS ══════════════
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.python3_host_prog = vim.fn.exepath("python3") or vim.fn.exepath("python") or "python3"

-- ═════════════════ SHELL CONFIGURATION ═══════════════════════
if vim.fn.executable("fish") == 1 then
	opt.shell = "fish"
elseif vim.fn.executable("zsh") == 1 then
	opt.shell = "zsh"
end

-- ═════════════════ DISABLE NETRW (use nvim-tree) ════════════
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ═════════════════ USAGE EXAMPLES ════════════════════════════
-- :set number?        -- Verifica se números estão habilitados
-- :set all            -- Mostra todas as configurações
-- :options            -- Abre painel de opções
