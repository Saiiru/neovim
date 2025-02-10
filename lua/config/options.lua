-- Definindo o codificador de script
vim.scriptencoding = "utf-8"

--------------------------------------------------
-- Configurações Gerais e de Interface
--------------------------------------------------
vim.opt.encoding = "utf-8"            -- Codificação padrão
vim.opt.fileencoding = "utf-8"        -- Codificação de arquivos
vim.opt.number = true                 -- Exibir números de linha
vim.opt.relativenumber = true         -- Números de linha relativos
vim.opt.title = true                  -- Exibir título da janela
vim.opt.autoindent = true             -- Indentação automática
vim.opt.smartindent = true            -- Indentação inteligente
vim.opt.hlsearch = true               -- Destacar resultados de busca
vim.opt.backup = false                -- Desativar backup de arquivos
vim.opt.showcmd = true                -- Mostrar comandos na barra de status
vim.opt.cmdheight = 0                 -- Altura mínima da linha de comando
vim.opt.laststatus = 3                -- Statusline global (experiência mais limpa)
vim.opt.expandtab = true              -- Converter tabulações em espaços
vim.opt.scrolloff = 8                 -- Linhas de margem ao rolar
vim.opt.inccommand = "split"          -- Visualizar substituições em tempo real
vim.opt.ignorecase = true             -- Busca sem diferenciar maiúsculas/minúsculas
vim.opt.smartcase = true              -- Diferenciar se houver letras maiúsculas na busca
vim.opt.smarttab = true               -- Tabulação inteligente
vim.opt.breakindent = true            -- Manter indentação em quebras de linha
vim.opt.shiftwidth = 2                -- Tamanho da indentação
vim.opt.tabstop = 2                   -- Tamanho da tabulação
vim.opt.wrap = false                  -- Desativar quebra de linha
vim.opt.backspace = { "start", "eol", "indent" } -- Configurações de backspace
vim.opt.path:append("**")             -- Incluir subdiretórios na busca de arquivos
vim.opt.wildignore:append("*/node_modules/*") -- Ignorar node_modules nas buscas
vim.opt.splitbelow = true             -- Abrir novas divisões abaixo
vim.opt.splitright = true             -- Abrir novas divisões à direita
vim.opt.splitkeep = "cursor"          -- Manter posição do cursor ao dividir
vim.opt.mouse = "a"                   -- Habilitar uso do mouse
vim.opt.termguicolors = true          -- Habilitar cores verdadeiras no terminal
vim.opt.cursorline = true             -- Destacar linha do cursor
vim.opt.signcolumn = "yes"            -- Sempre mostrar coluna de sinais
vim.opt.updatetime = 300              -- Tempo de atualização
vim.opt.timeoutlen = 300              -- Tempo de espera para mapeamentos
vim.opt.clipboard = "unnamedplus"     -- Usar área de transferência do sistema
vim.opt.undofile = true              -- Habilitar histórico persistente de undo

-- Configurações visuais extras
vim.opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Gerenciamento de arquivos e buffers
vim.o.hidden = true                  -- Permitir buffers não salvos
vim.o.swapfile = false               -- Desativar arquivos de swap
vim.o.writebackup = false            -- Desativar backup de escrita
vim.o.autowrite = true               -- Auto salvar antes de trocar de buffer
vim.o.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"

-- Configurações de busca e completions
vim.opt.completeopt = "menuone,noselect"  -- Melhor experiência de autocompletar
vim.o.incsearch = true               -- Busca incremental
vim.o.grepformat = "%f:%l:%c:%m"      -- Formato para saída do grep
vim.o.grepprg = "rg --vimgrep"         -- Utilizar ripgrep para grep

-- Indentação e formatação
vim.opt.softtabstop = 2
vim.opt.shiftround = true

-- Folding (dobramento)
vim.o.foldmethod = "expr"
vim.o.foldlevel = 99                -- Mostrar todos os folds por padrão
vim.opt.foldtext = "v:lua.require'utils.ui'.foldtext()" -- Função custom para texto de folds

-- Layout das janelas
vim.o.sidescrolloff = 8

-- Mapeamento de teclas
vim.g.mapleader = " "                -- Definir líder como espaço
vim.g.maplocalleader = "\\"          -- Definir líder local

-- Desabilitar provedores desnecessários
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Configurações de desempenho
vim.o.timeoutlen = 300
vim.o.updatetime = 200

-- Interface e experiência do usuário
vim.o.showmode = false              -- Não mostrar o modo na linha de status
vim.o.showtabline = 0               -- Ocultar a linha de abas
vim.o.winblend = 0                  -- Sem transparência extra
vim.o.linebreak = true             -- Quebra de linha inteligente
vim.o.ruler = false                -- Desativar o 'ruler'
vim.o.splitkeep = "screen"         -- Manter divisões na mesma posição

-- Configurações para Neovide (se aplicável)
if vim.g.neovide then
  vim.o.guifont = "OperatorMonoLig Nerd Font:h20"
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_cursor_antialiasing = false
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"
  vim.g.neovide_input_ime = true
end

-- Configurar clipboard: desativa se estiver em SSH
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

-- Otimização de startup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.syntax = "enable"

--------------------------------------------------
-- Personalizações do Cursor (guicursor)
--------------------------------------------------
-- Exemplo de configuração para alterar o cursor em diferentes modos:
vim.opt.guicursor = table.concat({
  "n-v-c:block",            -- Normal, Visual e Command: bloco sólido
  "i-ci:ver25",             -- Insert e Command-line Insert: barra vertical de 25%
  "r-cr:hor20",             -- Replace e Command-line Replace: cursor horizontal de 20%
  "o:hor50",                -- Operator-pending: barra horizontal de 50%\n"
}, ",")

--------------------------------------------------
-- Outras configurações e opções adicionais podem ser incluídas abaixo...
--------------------------------------------------

