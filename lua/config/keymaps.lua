-- Definição da tecla líder como espaço
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set -- Atalho para simplificar o mapeamento
local opts = { noremap = true, silent = true } -- Opções padrão

-- Mapeamentos Gerais -------------------

-- Sair do modo insert usando 'jk'
keymap("i", "jk", "<Esc>", { desc = "Sair do modo insert com jk" })

-- Limpar os destaques de busca
keymap("n", "nh", ":nohlsearch<CR>", { desc = "Limpar destaques da busca" })

-- Indentar mantendo a seleção no modo visual
keymap("v", "<", "<gv", { desc = "Indentar à esquerda no modo visual" })
keymap("v", ">", ">gv", { desc = "Indentar à direita no modo visual" })

-- Melhor navegação entre janelas
keymap("n", "<C-h>", "<C-w>h", { desc = "Mover foco para a janela à esquerda" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Mover foco para a janela à direita" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Mover foco para a janela abaixo" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Mover foco para a janela acima" })

-- Dividir janelas facilmente
keymap("n", "sv", ":vsplit<CR>", { desc = "Dividir janela verticalmente" })
keymap("n", "sh", ":split<CR>", { desc = "Dividir janela horizontalmente" })

-- Remover realces de busca
keymap("n", "<leader>h", ":nohlsearch<CR>", { desc = "Remover realces de busca" })

-- Tecla para 'source' do arquivo atual (recarregar configurações)
keymap("n", "<leader>s", ":source %<CR>", { desc = "Recarregar arquivo atual (source)" })

-- Acessar o explorador de arquivos (Ex)
keymap("n", "<leader>pv", ":Ex<CR>", { desc = "Abrir explorador de arquivos (Ex)" })

-- Formatar o arquivo atual
keymap("n", "<leader>f", vim.lsp.buf.format, { desc = "Formatar o arquivo atual" })

-- Função Go Error (melhorada)
keymap("n", "<leader>ge", "oif err != nil {<CR>}<Esc>Oreturn err<CR>", { desc = "Inserir tratamento de erro" })

-- Próximo e anterior com ajuste de visualização centralizada
keymap("n", "n", "nzzzv", { desc = "Próxima ocorrência com centralização" })
keymap("n", "N", "Nzzzv", { desc = "Ocorrência anterior com centralização" })

-- Cancelar o paste padrão e melhorar o comportamento de 'p'
keymap("x", "p", [["_dP]], { desc = "Colar sem substituir registro" })

