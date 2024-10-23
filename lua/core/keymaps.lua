-- Definindo líder
local keymap_utils = require("utils")
local map = keymap_utils.map
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window and Navigation
map("n", "<leader>wv", ":vsplit<CR>", "[W]indow split [V]ertical")
map("n", "<leader>wh", ":split<CR>", "[W]indow split [H]orizontal")
map("n", "<leader>se", "<C-w>=", "[M]ake splits [E]qual size")
map("n", "<leader>sx", "<cmd>close<CR>", "[C]lose current split window")
map("n", "<C-h>", "<C-w>h", "[M]ove focus left")
map("n", "<C-l>", "<C-w>l", "[M]ove focus right")
map("n", "<C-j>", "<C-w>j", "[M]ove focus down")
map("n", "<C-k>", "<C-w>k", "[M]ove focus up")

-- Tabs
map("n", "<leader>to", "<cmd>tabnew<CR>", "[O]pen new tab")
map("n", "<leader>tx", "<cmd>tabclose<CR>", "[C]lose current tab")
map("n", "<leader>tn", "<cmd>tabn<CR>", "[G]o to next tab")
map("n", "<leader>tp", "<cmd>tabp<CR>", "[G]o to previous tab")
map("n", "<leader>tf", "<cmd>tabnew %<CR>", "[O]pen current buffer in new tab")

-- Buffers
map("n", "<A-l>", "<cmd>bnext<CR>", "[G]o to next buffer")
map("n", "<A-h>", "<cmd>bprevious<CR>", "[G]o to previous buffer")
map("n", "<leader>q", "<cmd>bd<CR>", "[C]lose buffer")
map("n", "<leader>w", "<cmd>bp|bd #<CR>", "[C]lose buffer but keep split")

-- Editing and Navigation
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "[R]eplace word under cursor")
map("n", "<leader>xx", "<cmd>!chmod +x %<CR>", "[M]ake file executable", { silent = true })
map("n", "Y", "y$", "[M]ake Y yank until end of line")
map("n", "==", "gg<S-v>G", "[S]elect all")
map("n", "<leader>y", '"+y', "[C]opy to system clipboard")
map("v", "<leader>y", '"+y', "[C]opy selection to clipboard")
map("n", "<leader>d", '"_d', "[D]elete without copying")
map("v", "<leader>d", '"_d', "[D]elete selection without copying")

-- Terminal and Modes
map("t", "<Esc><Esc>", "<C-\\><C-n>", "[E]xit terminal mode")
map("i", "jk", "<ESC>", "[E]xit insert mode with jk")
map("i", "jj", "<Esc>", "[E]sc")

-- Visual Mode Movement
map("v", "J", ":m '>+1<CR>gv=gv", "[M]ove Line Down")
map("v", "K", ":m '<-2<CR>gv=gv", "[M]ove Line Up")

-- Pastes and Yanks
map("v", "<leader>p", '"_dP', "[P]aste without overwriting register")

-- Quickfix and Location List Management
map("n", "<leader>n", "<cmd>cnext<CR>zz", "[F]orward qfixlist")
map("n", "<leader>;", "<cmd>cprev<CR>zz", "[B]ackward qfixlist")
map("n", "<leader>k", "<cmd>lnext<CR>zz", "[F]orward location list")
map("n", "<leader>j", "<cmd>lprev<CR>zz", "[B]ackward location list")

-- Tests
map("n", "<leader>t", "<cmd>lua require('neotest').run.run()<CR>", "[R]un test")
map("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", "[R]un test file")
map("n", "<leader>td", "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<CR>", "[R]un test directory")
map("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<CR>", "[S]how test summary")

-- neotree
map("n", "<A-t>", "<cmd>Neotree toggle<CR>", "[N]eoTree toggle")

-- oil
map("n", "-", "<cmd>Oil --float<CR>", "[O]pen parent directory")
