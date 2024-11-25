-- General settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'
vim.g.elite_mode = false
vim.g.window_q_mapping = true
vim.g.diffprg = 'bcompare'
vim.g.autoformat = false
vim.g.lazyvim_picker = 'auto'
vim.g.ai_cmp = true
vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }
vim.g.root_lsp_ignore = { 'copilot' }
vim.g.deprecation_warnings = false
vim.g.trouble_lualine = false

-- Disable unnecessary providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- General options
local opt = vim.opt
opt.title = true
opt.titlestring = '%<%F%=%l/%L - nvim'
opt.mouse = 'nv'  -- Enable mouse in normal and visual modes only
opt.virtualedit = 'block'
opt.conceallevel = 2
opt.confirm = true
opt.signcolumn = 'yes'
opt.spelloptions:append('camel')
opt.updatetime = 200

-- Clipboard options
opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'

-- Completion options
opt.completeopt = 'menu,menuone,noselect'
opt.wildmode = 'longest:full,full'
opt.diffopt:append({ 'indent-heuristic', 'algorithm:patience' })

-- Text formatting options
opt.textwidth = 80
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.shiftround = true
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
opt.undofile = true
opt.undolevels = 10000
opt.writebackup = false

-- Searching options
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = false

-- Editor UI options
opt.termguicolors = true
opt.shortmess:append({ W = true, I = true, c = true })
opt.showcmd = false
opt.showmode = false
opt.laststatus = 3
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.numberwidth = 2
opt.ruler = false
opt.list = true
opt.foldlevel = 99
opt.cursorline = true
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = 'screen'
opt.cmdheight = 0
opt.colorcolumn = '+0'
opt.showtabline = 2
opt.helpheight = 0
opt.winwidth = 30
opt.winminwidth = 1
opt.winheight = 1
opt.winminheight = 1
opt.pumblend = 10
opt.pumheight = 10
opt.showbreak = '⤷  '
opt.listchars = { tab = '  ', extends = '⟫', precedes = '⟪', conceal = '', nbsp = '␣', trail = '·' }
opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
}
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.smoothscroll = vim.fn.has('nvim-0.10') == 1 or vim.fn.has('nvim-0.11') == 1
opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
opt.foldmethod = 'expr'
opt.foldtext = ''

-- Filetype detection
vim.filetype.add({
  filename = {
    Brewfile = 'ruby',
    justfile = 'just',
    Justfile = 'just',
    ['.buckconfig'] = 'toml',
    ['.flowconfig'] = 'ini',
    ['.jsbeautifyrc'] = 'json',
    ['.jscsrc'] = 'json',
    ['.watchmanconfig'] = 'json',
    ['helmfile.yaml'] = 'yaml',
    ['todo.txt'] = 'todotxt',
    ['yarn.lock'] = 'yaml',
  },
  pattern = {
    ['%.config/git/users/.*'] = 'gitconfig',
    ['%.kube/config'] = 'yaml',
    ['.*%.js%.map'] = 'json',
    ['.*%.postman_collection'] = 'json',
    ['Jenkinsfile.*'] = 'groovy',
  },
})

-- Codificação
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Interface
opt.nu = true
opt.relativenumber = true
opt.cursorlineopt = "number"
opt.colorcolumn = "80"

-- Tabs e Indentação
vim.bo.softtabstop = 2

-- Divisões e Janelas
opt.splitbelow = true
opt.splitright = true

-- Linha de Status
opt.laststatus = 3

-- Aparência
vim.diagnostic.config({ float = { border = "rounded" } })

-- Configuração do Cursor
opt.guicursor = {
  "n-v-c:block",
  "i-ci:ver25-blinkwait300-blinkoff150-blinkon150",
  "r-cr:hor20-blinkwait300-blinkoff150-blinkon150",
}

-- Mouse e Teclado
opt.whichwrap:append("<>[]hl")

-- Undo e Backup
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("config") .. "/undodir"

-- Tempo e Atualização
opt.timeoutlen = 300

-- Line Wrapping
opt.wrap = false

-- Folding
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Consideração de Palavras
opt.iskeyword:append("-")

-- Comandos Específicos para Arquivos
vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])

-- Líderes de Atalhos
vim.g.mapleader = " "
vim.g.maplocalleader = ";"

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Enable spell check by default unless in vscode
if not vim.g.vscode then
  vim.o.spell = true
end

-- Misc settings
vim.g.no_gitrebase_maps = 1
vim.g.no_man_maps = 1

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
vim.g.yaml_indent_multiline_scalar = 1
