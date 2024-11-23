-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Definições de opções do Neovim
local opt = vim.opt
local go = vim.g

-- Definir o líder das teclas
go.mapleader = " "
go.maplocalleader = "\\"

-- Opções gerais
opt.encoding = "UTF-8" -- Codificação de caracteres
opt.termguicolors = true -- Suporte para cores verdadeiras
opt.mouse = "a" -- Habilitar o uso do mouse
opt.clipboard = "unnamedplus" -- Usar a área de transferência do sistema
opt.title = true -- Exibir título da janela
opt.showcmd = true -- Exibir comandos em execução
opt.showmatch = true -- Destacar parênteses e colchetes
opt.number = true -- Exibir número da linha
opt.relativenumber = false -- Número absoluto de linha
opt.cursorline = true -- Destacar a linha do cursor
opt.splitright = true -- Divisões de tela à direita
opt.splitbelow = true -- Divisões de tela abaixo
opt.wrapscan = true -- Busca circular
opt.smartcase = true -- Busca inteligente (respeita maiúsculas/minúsculas)
opt.ignorecase = true -- Ignorar maiúsculas/minúsculas na busca
opt.hlsearch = true -- Destacar resultados da busca
opt.errorbells = false -- Desabilitar sons de erro
opt.joinspaces = false -- Não adicionar espaços extras ao juntar linhas
opt.scrolloff = 4 -- Linhas de contexto ao rolar
opt.sidescrolloff = 8 -- Colunas de contexto ao rolar lateralmente
opt.foldmethod = "expr" -- Método de dobra de código baseado em expressão
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Usar Treesitter para dobrar código
opt.foldlevelstart = 99 -- Começar com todas as dobras abertas
opt.fillchars = { -- Caracteres de preenchimento
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Opções para autoformatação
go.autoformat = true
go.editorconfig = true -- Integração com EditorConfig

-- Configuração do dicionário de ortografia
opt.spell = true
opt.spelllang = { "pt", "es" } -- Adicionar português e espanhol
vim.cmd([[set spellfile=~/.config/nvim/spell/en.utf-8.add]]) -- Arquivo de palavras personalizadas
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if not vim.fn.isdirectory(vim.fn.stdpath("data") .. "/site/spell") then
      vim.fn.system({ "mkdir", "-p", vim.fn.stdpath("data") .. "/site/spell" })
    end
    if not vim.fn.filereadable(vim.fn.stdpath("data") .. "/site/spell/pt.utf-8.add") then
      vim.fn.system({
        "curl",
        "-Lo",
        vim.fn.stdpath("data") .. "/site/spell/pt.utf-8.add",
        "https://raw.githubusercontent.com/neovim/neovim/master/runtime/spell/pt.utf-8.add",
      })
    end
  end,
})

-- Fontes
go.gui_font_face = "FiraCode Nerd Font" -- Fonte FiraCode Nerd Font
go.gui_font_size = 12 -- Tamanho da fonte
go.gui_font_default_size = go.gui_font_size
go.gui_font_face = "Maple Mono NF" -- Fonte Maple Mono NF

-- Configuração de autocompletamento e sugestões
opt.completeopt = { "menu", "menuone", "noselect" }
opt.inccommand = "nosplit" -- Pré-visualizar substituições incrementais

-- Configurações de backup
opt.backup = false -- Desabilitar backup de arquivos
opt.writebackup = false -- Desabilitar backup ao escrever
opt.swapfile = false -- Desabilitar arquivos de troca
opt.undofile = false -- Desabilitar arquivos de undo

-- Opções de preenchimento de tela
opt.scrolloff = 4 -- Linhas de contexto ao rolar
opt.sidescrolloff = 8 -- Colunas de contexto ao rolar lateralmente

-- Autoformatar ao salvar
opt.autowrite = true -- Salvar automaticamente ao sair
opt.smartindent = true -- Habilitar indentação inteligente
opt.expandtab = true -- Usar espaços ao invés de tabulação
opt.shiftwidth = 2 -- Tamanho do recuo para indentação
opt.softtabstop = 2 -- Espaços para cada tabulação
opt.tabstop = 2 -- Tamanho da tabulação

-- Ativar preenchimento de lista de caracteres
opt.listchars = {
  tab = ">>>", -- Exibição de tabulação
  trail = "·", -- Exibição de espaços à direita
  precedes = "←", -- Exibição de caracteres precedentes
  extends = "→", -- Exibição de caracteres de extensão
  eol = "↲", -- Exibição de final de linha
  nbsp = "␣", -- Exibição de espaços não quebra
}

-- Opções de interface
opt.laststatus = 3 -- Exibir status na parte inferior
opt.showmode = false -- Desabilitar a exibição do modo no status
opt.splitkeep = "screen" -- Manter a tela ao dividir
opt.timeoutlen = 500 -- Tempo para aguardar teclas
opt.virtualedit = "block" -- Permitir mover o cursor onde não há texto
opt.foldcolumn = "1" -- Número de colunas de dobra
opt.foldnestmax = 4 -- Número máximo de dobras
opt.foldenable = true -- Ativar dobras
opt.formatoptions = "jcroqlnt" -- Opções de formatação

-- Linha de status
opt.laststatus = 3 -- Exibir sempre uma linha de status

-- Definir configuração de sessão
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Ajustes de desempenho e visualização
opt.updatetime = 200 -- Tempo para salvar arquivos de troca e disparar CursorHold
opt.pumblend = 10 -- Opacidade do menu de preenchimento
opt.pumheight = 10 -- Máximo de itens a serem exibidos no menu de preenchimento

-- Autocomandos
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local last_pos = vim.fn.line("'\"")
    if last_pos > 0 and last_pos <= vim.fn.line("$") then
      vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Autocomando para abrir pré-visualização de arquivos no Oil
vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",
  callback = vim.schedule_wrap(function(args)
    local oil = require("plugins.editor.oil")
    if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
      oil.open_preview()
    end
  end),
})

-- Finalizando com otimização do carregamento
vim.loader.enable()
