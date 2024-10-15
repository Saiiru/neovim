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

-- Close nvim-tree when closing the last buffer
api.nvim_create_autocmd("BufWinLeave", {
    pattern = "*",
    callback = function()
        if #vim.fn.getbufinfo({buflisted = 1}) == 1 then
            require("nvim-tree.api").tree.close()
        end
    end,
})
vim.cmd([[
augroup NvimTreeCloseBuffer
    autocmd!
    autocmd BufDelete * if &ft == 'nvimtree' | quit | endif
augroup END
]])
-- Autocomando para fechar o NvimTree quando o buffer for fechado
vim.cmd([[
augroup NvimTreeClose
    autocmd!
    autocmd BufDelete * if bufname('%') == 'NvimTree' | quit | endif
augroup END
]])
-- Make :bd and :q behave as usual when tree is visible
api.nvim_create_autocmd({'BufEnter', 'QuitPre'}, {
  nested = false,
  callback = function(e)
    local tree = require('nvim-tree.api').tree

    -- Nothing to do if tree is not opened
    if not tree.is_visible() then
      return
    end

    -- How many focusable windows do we have? (excluding e.g. incline status window)
    local winCount = 0
    for _,winId in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(winId).focusable then
        winCount = winCount + 1
      end
    end

    -- We want to quit and only one window besides tree is left
    if e.event == 'QuitPre' and winCount == 2 then
      vim.api.nvim_cmd({cmd = 'qall'}, {})
    end

    -- :bd was probably issued an only tree window is left
    -- Behave as if tree was closed (see `:h :bd`)
    if e.event == 'BufEnter' and winCount == 1 then
      -- Required to avoid "Vim:E444: Cannot close last window"
      vim.defer_fn(function()
        -- close nvim-tree: will go to the last buffer used before closing
        tree.toggle({find_file = true, focus = true})
        -- re-open nivm-tree
        tree.toggle({find_file = true, focus = false})
      end, 10)
    end
  end
})
