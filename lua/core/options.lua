-- lua/core/options.lua :: Opções fundamentais do Neovim
local opt = vim.opt

--  interfaz e UI
opt.termguicolors = true -- cores 24-bit
opt.number = true -- numero de linhas
opt.relativenumber = true -- numero relativo de linhas
opt.numberwidth = 2 -- espaço para os numeros
opt.signcolumn = "yes" -- coluna de sinais sempre visivel
opt.cursorline = true -- destaca a linha atual
opt.wrap = false -- sem quebra de linha
opt.scrolloff = 10 -- margem para scroll
opt.sidescrolloff = 8 -- margem para scroll lateral
opt.splitright = true -- split vertical a direita
opt.splitbelow = true -- split horizontal abaixo
opt.pumheight = 10 -- altura do popup de complete
opt.showmode = false -- nao mostrar o modo atual
opt.inccommand = "split" -- preview de comandos
opt.clipboard = "unnamedplus" -- clipboard com o sistema
opt.mouse = "a" -- suporte ao mouse
opt.colorcolumn = "80" -- coluna de 80 caracteres
opt.fillchars = { eob = " " } -- sem "~" no fim do buffer
opt.updatetime = 200 -- tempo para swap/cursorhold
opt.timeoutlen = 500 -- tempo para mapeamentos
opt.confirm = true -- confirmar antes de sair

-- Pesquisa
opt.hlsearch = true -- destacar resultados
opt.ignorecase = true -- ignorar case
opt.smartcase = true -- case-sensitive se tiver maiuscula

-- Arquivos e persistencia
opt.swapfile = false -- sem swap file
opt.backup = false -- sem backup file
opt.undofile = true -- persistencia de undo
opt.fileencoding = "utf-8" -- encoding padrao
opt.hidden = true -- esconder buffers ao inves de fechar

-- Indentação
opt.expandtab = true -- usar espaços ao inves de tabs
opt.shiftwidth = 4 -- tamanho do shift
opt.tabstop = 4 -- tamanho do tab
opt.softtabstop = 4 -- tamanho do soft tab
opt.smartindent = true -- indentação inteligente
opt.breakindent = true -- manter indentação em quebras de linha

-- Folding (compatível com nvim-ufo)
vim.o.foldenable = true
vim.o.foldmethod = "manual" -- ufo gerencia o fold
vim.o.foldlevel = 99 -- previne auto-folding
vim.o.foldcolumn = "0" -- sem coluna de fold

-- Grep (usando ripgrep)
opt.grepprg = "rg --vimgrep --hidden --glob !**/.git/*"
opt.grepformat = "%f:%l:%c:%m"

-- Completion (para nvim-cmp)
opt.completeopt = { "menu", "menuone", "noselect" } -- comportamento do complete
opt.shortmess:append("c") -- nao mostrar mensagens de complete

