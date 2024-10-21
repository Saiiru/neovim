-- Função on_attach expandida com keymaps e lógica específica para diferentes LSPs
local M = {}

M.on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    -- Desativar formatação se for TSServer ou Lua LS, pois vamos usar outros formatadores
    if client.name == "ts_ls" or client.name == "lua_ls" then
        client.server_capabilities.document_formatting = false
    end

    -- Configurações específicas para o TypeScript
    if client.name == "ts_ls" then
        keymap(bufnr, "n", "gd", "<cmd>TypescriptGoToSourceDefinition<CR>", opts)
    else
        keymap(bufnr, "n", "gd", "<cmd>Trouble lsp_definitions<CR>", opts)
    end

    -- Keymaps gerais para todos os LSPs
    keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    keymap(bufnr, "n", "gt", "<cmd>Trouble lsp_type_definitions<CR>", opts)
    keymap(bufnr, "n", "gi", "<cmd>Trouble lsp_implementations<CR>", opts)
    keymap(bufnr, "n", "gr", "<cmd>Trouble lsp_references<CR>", opts)
    keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    keymap(bufnr, "n", "<leader>ca", "<cmd>CodeActionMenu<CR>", opts)
    keymap(bufnr, "n", "gf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
    keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    keymap(bufnr, "n", "d]", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

    -- Keymaps adicionais usando <Space> como prefixo, para integração com Telescope
    vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation", buffer = bufnr })
    vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode Goto [D]efinition", buffer = bufnr })
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions", buffer = bufnr })
    vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references, { desc = "[C]ode Goto [R]eferences", buffer = bufnr })
    vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations, { desc = "[C]ode Goto [I]mplementations", buffer = bufnr })
    vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename", buffer = bufnr })
    vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Goto [D]eclaration", buffer = bufnr })
end

return M

