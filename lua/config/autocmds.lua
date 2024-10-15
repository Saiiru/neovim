local api = vim.api

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function(_)
        vim.highlight.on_yank({ higroup = "DiagnosticWarn", timeout = 150 })
    end,
})

-- Remove trailing whitespace ao salvar
api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = "%s/\\s\\+$//e"
})

-- Ajustar indentação para arquivos JS/TS
api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript" },
    command = "setlocal shiftwidth=2 softtabstop=2 expandtab"
})

-- Salvar ao perder foco
api.nvim_create_autocmd("FocusLost", {
    pattern = "*",
    command = "silent! wa"
})

-- Formatação automática em Markdown
api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.md",
    command = "lua vim.lsp.buf.formatting_sync()"
})

-- Disable diagnostics in node_modules
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*/node_modules/*",
    command = "lua vim.diagnostic.disable(0)"
})

-- Enable spell checking for certain file types
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.txt", "*.md", "*.tex" },
    command = "setlocal spell"
})

-- Show `` in specific files
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.txt", "*.md", "*.json" },
    command = "setlocal conceallevel=0"
})

-- Attach specific keybindings in which-key for specific filetypes
local present, _ = pcall(require, "which-key")
if not present then return end
local _, pwk = pcall(require, "plugins.which-key.setup")

api.nvim_create_autocmd("BufEnter", { pattern = "*.md", callback = function() pwk.attach_markdown(0) end })
api.nvim_create_autocmd("BufEnter", { pattern = { "package.json" }, callback = function() pwk.attach_npm(0) end })
api.nvim_create_autocmd("FileType", { pattern = "*", callback = function() 
    if EcoVim.plugins.zen.enabled and vim.bo.filetype ~= "alpha" then 
        pwk.attach_zen(0) 
    end 
end })
api.nvim_create_autocmd("BufEnter", { pattern = { "*test.js", "*test.ts", "*test.tsx", "*spec.ts", "*spec.tsx" }, callback = function() pwk.attach_jest(0) end })
api.nvim_create_autocmd("FileType", { pattern = "spectre_panel", callback = function() pwk.attach_spectre(0) end })
api.nvim_create_autocmd("FileType", { pattern = "NvimTree", callback = function() pwk.attach_nvim_tree(0) end })

