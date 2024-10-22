-- Definindo líder
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Função auxiliar para mapear teclas com descrições
local function map(mode, keys, action, opts)
  opts = opts or {}
  opts.desc = opts.desc or action
  vim.keymap.set(mode, keys, action, opts)
end

-- Janela e Navegação
map("n", "<leader>wv", ":vsplit<cr>", { desc = '[W]indow split [V]ertical' })
map("n", "<leader>wh", ":split<cr>", { desc = '[W]indow split [H]orizontal' })
map("n", "<leader>se", "<C-w>=", { desc = '[M]ake splits [E]qual size' })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = '[C]lose current split window' })
map("n", "<C-h>", "<C-w>h", { desc = '[M]ove focus left' })
map("n", "<C-l>", "<C-w>l", { desc = '[M]ove focus right' })
map("n", "<C-j>", "<C-w>j", { desc = '[M]ove focus down' })
map("n", "<C-k>", "<C-w>k", { desc = '[M]ove focus up' })

-- Gerenciamento de Tabs
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = '[O]pen new tab' })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = '[C]lose current tab' })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = '[G]o to next tab' })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = '[G]o to previous tab' })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = '[O]pen current buffer in new tab' })

-- Buffers
map("n", "<A-l>", "<cmd>bnext<CR>", { desc = '[G]o to next buffer' })
map("n", "<A-h>", "<cmd>bprevious<CR>", { desc = '[G]o to previous buffer' })
map("n", "<leader>q", "<cmd>bd<CR>", { desc = '[C]lose buffer' })
map("n", "<leader>w", "<cmd>bp|bd #<CR>", { desc = '[C]lose buffer but keep split' })

-- Operações de Edição e Navegação
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[R]eplace word under cursor' })
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = '[M]ake file executable' })
map("n", "Y", "y$", { desc = '[M]ake Y yank until end of line' })
map("n", "==", "gg<S-v>G", { desc = '[S]elect all' })
map("n", "<leader>y", '"+y', { desc = '[C]opy to system clipboard' })
map("v", "<leader>y", '"+y', { desc = '[C]opy selection to clipboard' })
map("n", "<leader>d", '"_d', { desc = '[D]elete without copying' })
map("v", "<leader>d", '"_d', { desc = '[D]elete selection without copying' })

-- Terminais e Modos
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = '[E]xit terminal mode' })
map("i", "jk", "<ESC>", { desc = '[E]xit insert mode with jk' })
map("i", "jj", "<Esc>", { desc = '[E]sc' })

-- Movimentação em Visual Mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = '[M]ove Line Down' })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = '[M]ove Line Up' })

-- Pastes e Yanks
map("v", "<leader>p", '"_dP', { desc = '[P]aste without overwriting register' })

-- Gerenciamento de Quickfix e Location List
map("n", "<leader>h", "<cmd>cnext<CR>zz", { desc = '[F]orward qfixlist' })
map("n", "<leader>;", "<cmd>cprev<CR>zz", { desc = '[B]ackward qfixlist' })
map("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = '[F]orward location list' })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = '[B]ackward location list' })

-- Testes
map("n", "<leader>t", "<cmd>lua require('neotest').run.run()<CR>", { desc = '[R]un test' })
map("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = '[R]un test file' })
map("n", "<leader>td", "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<CR>", { desc = '[R]un test directory' })
map("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<CR>", { desc = '[S]how test summary' })

-- neotree
map("n", "<C-e>", "<cmd>Neotree toggle<CR>", { desc = "[N]eoTree toggle" })

-- ooil 
map("n", "-", "<cmd>Oil --float<CR>", { desc = "[O]pen parent directory" })
