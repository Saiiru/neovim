local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local M = {}

-- Função que mapeia teclas específicas para o LSP
M.on_attach = function(client, bufnr)
	-- Opções comuns para todos os keymaps
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- Mapeamentos de teclas para LSP
	vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation", buffer = bufnr })
	vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode Goto [D]efinition", buffer = bufnr })
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions", buffer = bufnr })
	vim.keymap.set(
		"n",
		"<leader>cr",
		require("telescope.builtin").lsp_references,
		{ desc = "[C]ode Goto [R]eferences", buffer = bufnr }
	)
	vim.keymap.set(
		"n",
		"<leader>ci",
		require("telescope.builtin").lsp_implementations,
		{ desc = "[C]ode Goto [I]mplementations", buffer = bufnr }
	)
	vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename", buffer = bufnr })
	vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Goto [D]eclaration", buffer = bufnr })

	-- Mais keymaps podem ser adicionados aqui conforme necessário
end

M.capabilities = capabilities

return M
