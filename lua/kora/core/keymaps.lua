-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                       KORA CONTROL MATRIX                               ║
-- ║                    NEURAL INTERFACE PROTOCOLS                           ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ═════════════════════════════════════════════════════════════════════════
--  CORE NAVIGATION PROTOCOLS
-- ═════════════════════════════════════════════════════════════════════════

-- Enhanced scrolling with center alignment
map("n", "<C-d>", "<C-d>zz", vim.tbl_extend("force", opts, { desc = "Scroll down center" }))
map("n", "<C-u>", "<C-u>zz", vim.tbl_extend("force", opts, { desc = "Scroll up center" }))
map("n", "n", "nzzzv", vim.tbl_extend("force", opts, { desc = "Next search centered" }))
map("n", "N", "Nzzzv", vim.tbl_extend("force", opts, { desc = "Prev search centered" }))

-- Window navigation (tmux compatible)
map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Move left pane" }))
map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Move down pane" }))
map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Move up pane" }))
map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Move right pane" }))

-- ═════════════════════════════════════════════════════════════════════════
--  VISUAL MODE OPERATIONS
-- ═════════════════════════════════════════════════════════════════════════

-- Block manipulation with visual feedback
map("v", "J", ":m '>+1<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection down" }))
map("v", "K", ":m '<-2<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection up" }))

-- ═════════════════════════════════════════════════════════════════════════
--  SPLIT MANAGEMENT PROTOCOLS
-- ═════════════════════════════════════════════════════════════════════════

map("n", "<leader>sv", "<C-w>v", vim.tbl_extend("force", opts, { desc = " Split vertical" }))
map("n", "<leader>sh", "<C-w>s", vim.tbl_extend("force", opts, { desc = " Split horizontal" }))
map("n", "<leader>se", "<C-w>=", vim.tbl_extend("force", opts, { desc = " Equal splits" }))
map("n", "<leader>sx", "<cmd>close<CR>", vim.tbl_extend("force", opts, { desc = " Close split" }))

-- ═════════════════════════════════════════════════════════════════════════
--  TAB MANAGEMENT PROTOCOLS
-- ═════════════════════════════════════════════════════════════════════════

map("n", "<leader>to", "<cmd>tabnew<CR>", vim.tbl_extend("force", opts, { desc = " New tab" }))
map("n", "<leader>tx", "<cmd>tabclose<CR>", vim.tbl_extend("force", opts, { desc = " Close tab" }))
map("n", "<leader>tn", "<cmd>tabn<CR>", vim.tbl_extend("force", opts, { desc = " Next tab" }))
map("n", "<leader>tp", "<cmd>tabp<CR>", vim.tbl_extend("force", opts, { desc = " Prev tab" }))

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>", vim.tbl_extend("force", opts, { desc = "Prev Buffer" }))
map("n", "<S-l>", "<cmd>bnext<cr>", vim.tbl_extend("force", opts, { desc = "Next Buffer" }))
map("n", "[b", "<cmd>bprevious<cr>", vim.tbl_extend("force", opts, { desc = "Prev Buffer" }))
map("n", "]b", "<cmd>bnext<cr>", vim.tbl_extend("force", opts, { desc = "Next Buffer" }))

-- ═════════════════════════════════════════════════════════════════════════
--  REGISTER PROTECTION SYSTEM
-- ═════════════════════════════════════════════════════════════════════════

map("n", "<leader>y", '"+y', vim.tbl_extend("force", opts, { desc = " Yank to clipboard" }))
map("v", "<leader>y", '"+y', vim.tbl_extend("force", opts, { desc = " Yank selection" }))
map("n", "<leader>d", '"_d', vim.tbl_extend("force", opts, { desc = " Delete to void" }))
map("v", "<leader>d", '"_d', vim.tbl_extend("force", opts, { desc = " Delete to void" }))
map("x", "<leader>p", [["_dP]], vim.tbl_extend("force", opts, { desc = " Paste preserve" }))

-- ═════════════════════════════════════════════════════════════════════════
--  FILE OPERATIONS MATRIX
-- ═════════════════════════════════════════════════════════════════════════

map("n", "<leader>w", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = " Save file" }))
map("n", "<leader>q", "<cmd>confirm q<CR>", vim.tbl_extend("force", opts, { desc = " Quit buffer" }))
map("n", "<leader>Q", "<cmd>confirm qall<CR>", vim.tbl_extend("force", opts, { desc = " Quit all" }))

-- ═════════════════════════════════════════════════════════════════════════
--  SEARCH AND REPLACE PROTOCOLS
-- ═════════════════════════════════════════════════════════════════════════

map("n", "<Esc>", "<cmd>nohlsearch<CR>", vim.tbl_extend("force", opts, { desc = "Clear highlights" }))
map("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = " Replace word" })

-- ═════════════════════════════════════════════════════════════════════════
--  QUICK ACTIONS PROTOCOL
-- ═════════════════════════════════════════════════════════════════════════

-- Line manipulation
map("n", "J", "mzJ`z", vim.tbl_extend("force", opts, { desc = "Join lines keep cursor" }))

-- Source current file
map("n", "<leader><leader>", function()
	vim.cmd("so")
end, vim.tbl_extend("force", opts, { desc = " Source file" }))

-- ═════════════════════════════════════════════════════════════════════════
--  FILE PATH OPERATIONS
-- ═════════════════════════════════════════════════════════════════════════

map("n", "<leader>fp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify(" Path copied: " .. path, vim.log.levels.INFO)
end, vim.tbl_extend("force", opts, { desc = " Copy file path" }))

map("n", "<leader>fn", function()
	local name = vim.fn.expand("%:t")
	vim.fn.setreg("+", name)
	vim.notify(" Filename copied: " .. name, vim.log.levels.INFO)
end, vim.tbl_extend("force", opts, { desc = " Copy filename" }))

-- ═════════════════════════════════════════════════════════════════════════
--  DIAGNOSTIC PROTOCOLS
-- ═════════════════════════════════════════════════════════════════════════

map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = " Prev diagnostic" }))
map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = " Next diagnostic" }))
map("n", "<leader>ld", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = " Line diagnostics" }))
map("n", "<leader>lq", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = " Diagnostics list" }))

-- ═════════════════════════════════════════════════════════════════════════
--  DEVELOPMENT SNIPPETS
-- ═════════════════════════════════════════════════════════════════════════

-- Go error handling
map("n", "<leader>ge", function()
	vim.api.nvim_put({ "if err != nil {", "\treturn err", "}" }, "l", true, true)
end, vim.tbl_extend("force", opts, { desc = " Go error return" }))

-- Console log
map("n", "<leader>cl", function()
	local word = vim.fn.expand("<cword>")
	vim.api.nvim_put({ "console.log('" .. word .. ":', " .. word .. ");" }, "l", true, true)
end, vim.tbl_extend("force", opts, { desc = " Console log" }))

-- ═════════════════════════════════════════════════════════════════════════
--  QUICK RUN PROTOCOLS
-- ═════════════════════════════════════════════════════════════════════════

map("n", "<leader>x", function()
	local ft = vim.bo.filetype
	local file = vim.fn.expand("%")
	local commands = {
		python = "python3 " .. file,
		javascript = "node " .. file,
		go = "go run " .. file,
		java = "javac " .. file .. " && java " .. vim.fn.expand("%:r"),
		c = "gcc " .. file .. " -o " .. vim.fn.expand("%:r") .. " && ./" .. vim.fn.expand("%:r"),
		cpp = "g++ " .. file .. " -o " .. vim.fn.expand("%:r") .. " && ./" .. vim.fn.expand("%:r"),
		lua = "lua " .. file,
		rust = "cargo run",
	}

	local cmd = commands[ft]
	if cmd then
		vim.cmd("split")
		vim.cmd("resize 15")
		vim.cmd("terminal " .. cmd)
		vim.cmd("startinsert")
	else
		vim.notify(" No run command for: " .. ft, vim.log.levels.WARN)
	end
end, vim.tbl_extend("force", opts, { desc = " Quick run file" }))

-- ═════════════════════════════════════════════════════════════════════════
--  QUICK TOGGLES
-- ═════════════════════════════════════════════════════════════════════════

-- Toggle relative numbers
map("n", "<leader>rn", function()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, vim.tbl_extend("force", opts, { desc = " Toggle relative numbers" }))

-- Toggle line wrap
map("n", "<leader>tw", function()
	vim.opt.wrap = not vim.opt.wrap:get()
end, vim.tbl_extend("force", opts, { desc = " Toggle wrap" }))

-- ══════════════════════════════════════════════════════════════════════════
-- EXEMPLOS DE USO - KEYMAPS.LUA
-- ══════════════════════════════════════════════════════════════════════════
-- Este arquivo define todos os atalhos principais do sistema:
--
-- NAVEGAÇÃO BÁSICA:
-- <C-h/j/k/l>              -- Navega entre painéis (Neovim + tmux)
-- <C-d>/<C-u>              -- Scroll com cursor centralizado
-- n/N                      -- Busca com cursor centralizado
--
-- SPLITS E ABAS:
-- <leader>sv               -- Split vertical
-- <leader>sh               -- Split horizontal
-- <leader>to               -- Nova aba
-- <S-h>/<S-l>              -- Navega entre buffers
--
-- CLIPBOARD:
-- <leader>y                -- Copia para clipboard do sistema
-- <leader>d                -- Deleta sem afetar registradores
-- <leader>p                -- Cola preservando registrador
--
-- ARQUIVOS:
-- <leader>w                -- Salva arquivo atual
-- <leader>fp               -- Copia caminho do arquivo
-- <leader>fn               -- Copia nome do arquivo
--
-- DESENVOLVIMENTO:
-- <leader>x                -- Executa arquivo atual
-- <leader>ge               -- Insere tratamento de erro Go
-- <leader>cl               -- Insere console.log da palavra sob cursor
--
-- DIAGNÓSTICOS:
-- [d / ]d                  -- Navega entre diagnósticos
-- <leader>ld               -- Mostra diagnósticos da linha
--
-- Para ver todos os atalhos disponíveis:
-- <leader>                 -- Abre Which-Key com todos os comandos
