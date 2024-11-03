-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opts = { silent = true, noremap = true }
local keymap = vim.keymap.set

-- Definindo o líder
vim.g.mapleader = " "

-- ------------------------------
-- Splits e Navegação de Janelas
-- ------------------------------
keymap("n", "ss", ":split<CR>", { desc = "[S]plit Horizontal" })
keymap("n", "sv", ":vsplit<CR>", { desc = "[S]plit Vertical" })
keymap("n", "sh", "<C-w>h", { desc = "[S]witch left split" })
keymap("n", "sj", "<C-w>j", { desc = "[S]witch bottom split" })
keymap("n", "sk", "<C-w>k", { desc = "[S]witch top split" })
keymap("n", "sl", "<C-w>l", { desc = "[S]witch right split" })
keymap("n", "sq", "<C-w>q", { desc = "[S]plit [Q]uit" })
-- Better window navigation
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Easily split windows
keymap("n", "<leader>wv", ":vsplit<cr>", { desc = "[W]indow Split [V]ertical" })
keymap("n", "<leader>wh", ":split<cr>", { desc = "[W]indow Split [H]orizontal" })

-- Stay in indent mode
keymap("v", "<", "<gv", { desc = "Indent left in visual mode" })
keymap("v", ">", ">gv", { desc = "Indent right in visual mode" })
-- ------------------------------
-- Navegação de Abas e Buffers
-- ------------------------------
keymap("n", "<leader>tn", ":tabnext<CR>", { desc = "[T]ab [N]ext" })
keymap("n", "<leader>tp", ":tabprev<CR>", { desc = "[T]ab [P]revious" })
keymap("n", "<leader>tc", ":tabclose<CR>", { desc = "[T]ab [C]lose" })
keymap("n", "<leader>to", ":tabnew<CR>", { desc = "[T]ab [O]pen New" })

-- Navegação de Buffers
keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Próximo buffer" })
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Buffer anterior" })
keymap("n", "gn", ":bn<CR>", { desc = "Próximo buffer" })
keymap("n", "gp", ":bp<CR>", { desc = "Buffer anterior" })
keymap("n", "<S-q>", ":lua require('mini.bufremove').delete(0, false)<CR>", { desc = "Fechar buffer" })
keymap("n", "<A-l>", ":bn<CR>", { desc = "Alt + L: Próximo buffer" })
keymap("n", "<A-h>", ":bp<CR>", { desc = "Alt + H: Buffer anterior" })

-- ------------------------------
-- Miscellaneous
-- ------------------------------
keymap("n", "<C-t>", "<C-^>", { desc = "Troca entre os dois últimos buffers" })
keymap("n", "<leader>vv", ":e $MYVIMRC<CR>", { desc = "[V]im [V]RC: Editar config" })
keymap("n", "<leader>a", "ggVG", { desc = "[A]ll: Selecionar arquivo inteiro" })
keymap("n", "*", ":keepjumps normal! mi*`i<CR>", { desc = "Buscar palavra sem saltar" })
keymap("v", "<leader>y", '"+y', { desc = "[Y]ank para clipboard" })
keymap("n", "y", '"+y', { desc = "[Y]ank para clipboard" })
keymap("n", "H", "^", { desc = "Início da linha" })
keymap("i", "<C-h>", "<Left>", { desc = "Mover cursor para a esquerda (modo insert)" })
keymap("i", "<C-l>", "<Right>", { desc = "Mover cursor para a direita (modo insert)" })
keymap("x", "<leader>p", '"_dP', { desc = "Colar sem substituir registrador" })

-- ------------------------------
-- Mapeamentos LSP (descomente se necessário)
-- ------------------------------
-- keymap("n", "gd", vim.lsp.buf.definition, { desc = "[G]o to [D]efinition" })
-- keymap("n", "gr", function() vim.lsp.buf.references({ includeDeclaration = false }) end, { desc = "[G]o to [R]eferences" })
-- keymap("n", "gy", vim.lsp.buf.type_definition, { desc = "[G]o to Type Definition" })
-- keymap("n", "<C-Space>", vim.lsp.buf.code_action, { desc = "Ação de código" })
-- keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
-- keymap("v", "<leader>ca", ":'<,'>lua vim.lsp.buf.code_action()<CR>", { desc = "[C]ode [A]ction (Visual)" })
-- keymap("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
-- keymap("n", "<leader>cf", "<cmd>lua require('config.lsp.functions').format()<CR>", { desc = "[C]ode [F]ormat" })
-- keymap("n", "<leader>cl", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>", { desc = "[C]ode Diagnostics [L]ine" })
-- keymap("n", "L", vim.lsp.buf.signature_help, { desc = "Assistência assinatura função" })
-- keymap("n", "]g", vim.diagnostic.goto_next, { desc = "Próximo diagnóstico" })

-- ------------------------------
-- Mapeamento de Pesquisa Visual
-- ------------------------------
vim.cmd([[
  function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
  endfunction
  vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
]])

-- ------------------------------
-- Abrir links no sistema
-- ------------------------------
local open_cmd = vim.fn.has("macunix") == 1 and "open" or "xdg-open"
keymap("n", "gx", "<cmd>silent execute '! " .. open_cmd .. " ' . shellescape('<cWORD>')<CR>", { desc = "Abrir link" })

-- ------------------------------
-- Mapeamentos Extras
-- ------------------------------
keymap("n", "<leader>vpp", ":e ~/.dotfiles/nvim/.config/nvim/init.lua<CR>", { desc = "[V]im [P]acker [P]rofile" })
keymap("n", "<leader>mr", ":CellularAutomaton make_it_rain<CR>", { desc = "[M]ake it [R]ain" })
keymap("n", "<leader><leader>", function()
  vim.cmd("so")
end, { desc = "Recarregar config" })
keymap("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "[Z]ig: Reiniciar LSP" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Abrir lista de [Q]uickfix diagnósticos" })

-- ------------------------------
-- Sair do modo terminal
-- ------------------------------
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Sair do modo terminal" })

-- ------------------------------
-- Funções do Sairu
-- ------------------------------
-- local discipline = require("sairu.discipline")
-- discipline.cowboy()
--
-- ------------------------------
-- Navegação e Manipulação
-- ------------------------------
keymap("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
keymap("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Executar comando tmux" })

-- Incrementar/decrementar
keymap("n", "+", "<C-a>")
keymap("n", "-", "<C-x>")
-- Deletar uma palavra para trás
--
keymap("n", "dw", 'vb"_d')
-- Selecionar tudo
keymap("n", "<C-a>", "gg<S-v>G")
-- Desabilitar continuações
keymap("n", "<Leader>o", "o<Esc>^Da", opts)
keymap("n", "<Leader>O", "O<Esc>^Da", opts)

-- ------------------------------
-- Redimensionar janelas
-- ------------------------------
keymap("n", "<C-w><left>", "<C-w><")
keymap("n", "<C-w><right>", "<C-w>>")
keymap("n", "<C-w><up>", "<C-w>+")
keymap("n", "<C-w><down>", "<C-w>-")

-- ------------------------------
-- Comandos para gerenciar e abrir
-- ------------------------------
-- keymap(
--   "n",
--   "<leader>gg",
--   ":lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
--   { desc = "Gerenciar Worktrees" }
-- )
keymap(
  "n",
  "<leader>gG",
  ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
  { desc = "Criar Worktree" }
)

-- ------------------------------
-- Adicionar mapeamentos globais conforme necessário
-- ------------------------------
vim.keymap.set(
  "n",
  "<leader>sx",
  require("telescope.builtin").resume,
  { noremap = true, silent = true, desc = "Resume" }
)
