-- lua/core/keymaps.lua :: Keymaps essenciais e independentes de plugins.

-- Garante que o leader seja espaço, mas não sobrescreve se já definido.
vim.g.mapleader = vim.g.mapleader or " "
vim.g.maplocalleader = vim.g.maplocalleader or ","

-- Função utilitária para criar keymaps com opções padrão.
local map = function(mode, lhs, rhs, desc, opts)
	local o = { noremap = true, silent = true, desc = desc }
	if opts then
		o = vim.tbl_extend("force", o, opts)
	end
	vim.keymap.set(mode, lhs, rhs, o)
end

-- =============================================================================
--  MODO NORMAL (n)
-- =============================================================================

-- Movimentação e Edição
map("n", "<C-d>", "<C-d>zz", "Scroll down (center)")
map("n", "<C-u>", "<C-u>zz", "Scroll up (center)")
map("n", "n", "nzzzv", "Next search (center)")
map("n", "N", "Nzzzv", "Prev search (center)")
map("n", "J", "mzJ`z", "Join lines (keep cursor)")
map("n", "x", '"_x', "Delete char (blackhole)")

-- Sair do modo insert com Ctrl-c
map("i", "<C-c>", "<Esc>", "Leave insert")

-- Limpar highlight de busca
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")
map("n", "<C-c>", "<cmd>nohlsearch<CR>", "Clear search highlight")

-- Salvar
map({ "n", "i", "v", "x" }, "<C-s>", "<cmd>update<CR>", "Save buffer")

-- =============================================================================
--  MODO VISUAL (v)
-- =============================================================================

-- Mover linhas selecionadas
map("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")

-- Indentação
map("v", "<", "<gv", "Indent left (keep selection)")
map("v", ">", ">gv", "Indent right (keep selection)")

-- Colar sem perder o que está no registro
map("v", "p", '"_dp', "Paste (keep default register)")

-- =============================================================================
--  LEADER KEYMAPS
-- =============================================================================

-- Buffers
map("n", "<leader>bn", "<cmd>bnext<CR>", "Buffer next")
map("n", "<leader>bp", "<cmd>bprevious<CR>", "Buffer prev")
map("n", "<leader>bd", "<cmd>bdelete<CR>", "Buffer delete (close)")
map("n", "<leader>bD", "<cmd>bufdo bdelete<CR>", "Buffer delete all")

-- Tabs
map("n", "<leader>to", "<cmd>tabnew<CR>", "Tab new")
map("n", "<leader>tx", "<cmd>tabclose<CR>", "Tab close")
map("n", "<leader>tn", "<cmd>tabnext<CR>", "Tab next")
map("n", "<leader>tp", "<cmd>tabprevious<CR>", "Tab prev")
map("n", "<leader>tf", "<cmd>tabnew %<CR>", "Tab from current file")

-- Splits
map("n", "<leader>wv", "<C-w>v", "Split vertical")
map("n", "<leader>wh", "<C-w>s", "Split horizontal")
map("n", "<leader>we", "<C-w>=", "Make splits equal")
map("n", "<leader>wc", "<cmd>close<CR>", "Close split")
map("n", "<leader>wo", "<C-w>o", "Only this window")

-- Movimentação entre splits
map("n", "<C-h>", "<C-w>h", "Go to left split")
map("n", "<C-j>", "<C-w>j", "Go to below split")
map("n", "<C-k>", "<C-w>k", "Go to above split")
map("n", "<C-l>", "<C-w>l", "Go to right split")

-- Redimensionar splits
map("n", "<A-h>", "<cmd>vertical resize -5<CR>", "Resize ←")
map("n", "<A-l>", "<cmd>vertical resize +5<CR>", "Resize →")
map("n", "<A-k>", "<cmd>resize -3<CR>", "Resize ↑")
map("n", "<A-j>", "<cmd>resize +3<CR>", "Resize ↓")

-- Clipboard
map({ "n", "v" }, "<leader>y", '"+y', "Yank to system clipboard")
map("n", "<leader>Y", '"+Y', "Yank line to system clipboard")
map({ "n", "v" }, "<leader>d", '"_d', "Delete (blackhole)")

-- Arquivos
map("n", "<leader>fp", function()
	local path = vim.fn.expand("%:p")
	if path == "" then
		vim.notify("Sem arquivo associado ao buffer", vim.log.levels.WARN)
		return
	end
	vim.fn.setreg("+", path)
	vim.notify("Copiado para clipboard: " .. path)
end, "Copy file path")
map("n", "<leader>mx", "<cmd>!chmod +x %<CR>", "Make file executable")

-- Config
map("n", "<leader>ve", ":e $MYVIMRC<CR>", "Edit init.lua")
map("n", "<leader>vs", ":source $MYVIMRC<CR>", "Source init.lua")

-- Diagnostics
map("n", "<leader>xe", vim.diagnostic.open_float, "Diagnostics: line float")
map("n", "<leader>xq", function() vim.diagnostic.setqflist({ open = true }) end, "Diagnostics: quickfix")
map("n", "<leader>xl", function() vim.diagnostic.setloclist({ open = true }) end, "Diagnostics: loclist")
map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
map("n", "[D", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, "Prev ERROR")
map("n", "]D", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, "Next ERROR")

-- Toggle diagnostics
local _diag_state = { vt = true, signs = true }
map("n", "<leader>lx", function()
	_diag_state.vt = not _diag_state.vt
	_diag_state.signs = not _diag_state.signs
	vim.diagnostic.config({ virtual_text = _diag_state.vt, signs = _diag_state.signs })
	vim.notify("Diagnostics: virtual_text=" .. tostring(_diag_state.vt) .. ", signs=" .. tostring(_diag_state.signs))
end, "Toggle diagnostics (vt/signs)")

-- Formatação (Conform/LSP)
local function smart_format(range)
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({
			lsp_fallback = true,
			async = false,
			timeout_ms = 1500,
			range = range,
		})
	else
		vim.lsp.buf.format({ async = false })
	end
end
map({ "n", "v" }, "<leader>cf", function() smart_format(nil) end, "Format (Conform/LSP)")
map("v", "<leader>cF", function()
	local srow, scol = unpack(vim.api.nvim_buf_get_mark(0, "<"))
	local erow, ecol = unpack(vim.api.nvim_buf_get_mark(0, ">"))
	smart_format({ start = { srow, scol }, ["end"] = { erow, ecol } })
end, "Format range (Conform/LSP)")

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Terminal → Normal")

-- Desabilitar Ex-mode
map("n", "Q", "<nop>", "Disable Ex-mode")

-- Toggles
map("n", "<leader>us", function() vim.wo.spell = not vim.wo.spell end, "Toggle spell")
map("n", "<leader>uw", function() vim.wo.wrap = not vim.wo.wrap end, "Toggle wrap")
map("n", "<leader>ur", function() vim.wo.relativenumber = not vim.wo.relativenumber end, "Toggle relativenumber")
map("n", "<leader>uc", function() vim.o.cursorline = not vim.o.cursorline end, "Toggle cursorline")
map("n", "<leader>un", function() vim.wo.number = not vim.wo.number end, "Toggle number")




