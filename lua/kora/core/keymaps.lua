local o = { noremap = true, silent = true }
local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", o, { desc = desc }))
end

-- Desativa mapeamentos automáticos do vim-tmux-navigator; usamos os nossos.
vim.g.tmux_navigator_no_mappings = 1

-- Leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local function has_tmux_nav()
	return vim.fn.exists(":TmuxNavigateLeft") == 2
end

local function to_normal_from_term()
	if vim.api.nvim_get_mode().mode:sub(1, 1) == "t" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
	end
end

local function nav(dir)
	to_normal_from_term()
	if has_tmux_nav() then
		local cmd = ({
			h = "TmuxNavigateLeft",
			j = "TmuxNavigateDown",
			k = "TmuxNavigateUp",
			l = "TmuxNavigateRight",
			p = "TmuxNavigatePrevious",
		})[dir]
		if cmd then
			vim.cmd(cmd)
		end
	else
		local cmd = ({ h = "h", j = "j", k = "k", l = "l" })[dir]
		if cmd then
			vim.cmd("wincmd " .. cmd)
		end
	end
end

-- Normal mode
map("n", "<C-h>", function()
	nav("h")
end, "Focus left window")
map("n", "<C-j>", function()
	nav("j")
end, "Focus down window")
map("n", "<C-k>", function()
	nav("k")
end, "Focus up window")
map("n", "<C-l>", function()
	nav("l")
end, "Focus right window")
map("n", "<C-\\>", function()
	nav("p")
end, "Focus previous window")

-- Insert/Terminal: mesmas teclas
map("i", "<C-h>", function()
	nav("h")
end, "Focus left window")
map("i", "<C-j>", function()
	nav("j")
end, "Focus down window")
map("i", "<C-k>", function()
	nav("k")
end, "Focus up window")
map("i", "<C-l>", function()
	nav("l")
end, "Focus right window")
map("t", "<C-h>", function()
	nav("h")
end, "Focus left window")
map("t", "<C-j>", function()
	nav("j")
end, "Focus down window")
map("t", "<C-k>", function()
	nav("k")
end, "Focus up window")
map("t", "<C-l>", function()
	nav("l")
end, "Focus right window")
map("t", "<C-\\>", function()
	nav("p")
end, "Focus previous window")

-- ========= Redimensionamento rápido =========
-- Alt+h/j/k/l ajusta 5 col/linhas (funciona em N/I/T).
local function resize(which)
	to_normal_from_term()
	local cmd = ({ h = "vertical resize -5", l = "vertical resize +5", j = "resize +5", k = "resize -5" })[which]
	if cmd then
		vim.cmd(cmd)
	end
end
for _, m in ipairs({ "n", "i", "t" }) do
	map(m, "<A-h>", function()
		resize("h")
	end, "Resize -5 cols")
	map(m, "<A-l>", function()
		resize("l")
	end, "Resize +5 cols")
	map(m, "<A-j>", function()
		resize("j")
	end, "Resize +5 rows")
	map(m, "<A-k>", function()
		resize("k")
	end, "Resize -5 rows")
end

-- ========= Organização de janelas =========
map("n", "<leader>sv", "<C-w>v", "Split vertical")
map("n", "<leader>sh>", "<C-w>s", "Split horizontal")
map("n", "<leader>se", "<C-w>=", "Splits equalize")
map("n", "<leader>sx", "<cmd>close<CR>", "Split close")
map("n", "<leader>sH", "<C-w>H", "Move pane far left")
map("n", "<leader>sJ", "<C-w>J", "Move pane far down")
map("n", "<leader>sK", "<C-w>K", "Move pane far up")
map("n", "<leader>sL", "<C-w>L", "Move pane far right")

-- ========= Movimento/edição suave =========
map("v", "J", ":m '>+1<CR>gv=gv", "Move sel ↓")
map("v", "K", ":m '<-2<CR>gv=gv", "Move sel ↑")
map("n", "J", "mzJ`z", "Join keep cursor")
map("n", "<C-d>", "<C-d>zz", "Half ↓ center")
map("n", "<C-u>", "<C-u>zz", "Half ↑ center")
map("n", "n", "nzzzv", "Next centered")
map("n", "N", "Nzzzv", "Prev centered")
map("v", "<", "<gv", "Unindent keep sel")
map("v", ">", ">gv", "Indent keep sel")

-- Clipboard / Paste seguro
map({ "n", "v" }, "<leader>y", [["+y]], "Yank → system")
map("n", "<leader>Y", [["+Y]], "Yank line → system")
map("x", "<leader>P", [["_dP]], "Paste no-yank") -- evita colisão com <leader>p de outros plugins
map("v", "p", '"_dp', "Replace sel no-yank")
map({ "n", "v" }, "<leader>_", [["_d]], "Delete no-yank")
map("n", "x", '"_x', "Del char no-yank")

-- Conveniência
map("i", "<C-c>", "<Esc>", "Exit Insert")
map("n", "<C-c>", ":nohlsearch<CR>", "Clear hl")
map("n", "Q", "<nop>", "Disable Ex")
map("n", "<leader><leader>", function()
	vim.cmd("so")
end, "Source file")
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", "Chmod +x")

-- Busca/Substituição
map("n", "<leader>fr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace word under cursor")

-- Format (Conform → LSP fallback)
map("n", "<leader>lf", function()
	if pcall(require, "conform") then
		require("conform").format({ bufnr = 0 })
	else
		vim.lsp.buf.format()
	end
end, "Format buffer")

-- LSP toggles
do
	local on = true
	map("n", "<leader>lx", function()
		on = not on
		vim.diagnostic.config({ virtual_text = on, underline = on })
	end, "Toggle diagnostics")
end

-- Quickfix / Location list (sem conflitar com <C-j>/<C-k>)
map("n", "]q", "<cmd>cnext<CR>zz", "Quickfix next")
map("n", "[q", "<cmd>cprev<CR>zz", "Quickfix prev")
map("n", "]l", "<cmd>lnext<CR>zz", "Loclist next")
map("n", "[l", "<cmd>lprev<CR>zz", "Loclist prev")
map("n", "<leader>qo", "<cmd>copen<CR>", "Quickfix open")
map("n", "<leader>qc", "<cmd>cclose<CR>", "Quickfix close")

-- Tabs
map("n", "<leader>to", "<cmd>tabnew<CR>", "Tab new")
map("n", "<leader>tx", "<cmd>tabclose<CR>", "Tab close")
map("n", "<leader>tn", "<cmd>tabn<CR>", "Tab next")
map("n", "<leader>tp", "<cmd>tabp<CR>", "Tab prev")
map("n", "<leader>tf", "<cmd>tabnew %<CR>", "Tab current file")

-- Path util
map("n", "<leader>fp", function()
	local p = vim.fn.expand("%:~")
	vim.fn.setreg("+", p)
	vim.notify("Path: " .. p)
end, "Copy file path")

-- Integração tmux extra (opcional)
map("n", "<C-f>", "<cmd>silent !tmux neww sesh connect --choose<CR>", "Tmux sesh picker")

-- Parágrafo auto-indent
map("n", "=ap", "ma=ap'a", "Reindent paragraph")

-- Highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("kora-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Highlight yank",
})
