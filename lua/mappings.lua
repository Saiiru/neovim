local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Defaults
map("n", "N", "Nzz", opts)
map("n", "n", "nzz", opts)
map("n", "<leader>,", "<cmd>noh<cr>", { desc = "Clear search" })
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save" })

-- Windows and buffers
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader><tab>", "<cmd>b#<cr>", { desc = "Alternate buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })

-- Diagnostics / LSP
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>cl", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

-- Quickfix
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix" })

-- Completion / snippets. nvim-cmp owns <Tab>/<S-Tab> in insert mode.
map({ "i", "s" }, "<C-j>", function()
  local ok, ls = pcall(require, "luasnip")
  if ok and ls.expand_or_jumpable() then ls.expand_or_jump() end
end, { desc = "Snippet expand/jump forward" })
map({ "i", "s" }, "<C-k>", function()
  local ok, ls = pcall(require, "luasnip")
  if ok and ls.jumpable(-1) then ls.jump(-1) end
end, { desc = "Snippet jump backward" })
map("n", "<leader>sl", "<cmd>LuaSnipListAvailable<cr>", { desc = "List snippets" })

-- PDE / mise-first tasks
map("n", "<leader>ps", "<cmd>PDEStatus<cr>", { desc = "PDE status" })
map("n", "<leader>po", "<cmd>PDEOverview<cr>", { desc = "PDE overview" })
map("n", "<leader>pd", "<cmd>PDEDoctor<cr>", { desc = "PDE doctor" })
map("n", "<leader>pv", "<cmd>PDEVersion<cr>", { desc = "PDE version" })
map("n", "<leader>pC", "<cmd>PDECompile<cr>", { desc = "PDE compile" })
map("n", "<leader>pb", "<cmd>PDEBuild<cr>", { desc = "PDE build" })
map("n", "<leader>pt", "<cmd>PDETest<cr>", { desc = "PDE test" })
map("n", "<leader>pl", "<cmd>PDELint<cr>", { desc = "PDE lint" })
map("n", "<leader>pf", "<cmd>PDEFormat<cr>", { desc = "PDE format" })
map("n", "<leader>pr", "<cmd>PDERun<cr>", { desc = "PDE run" })
map("n", "<leader>pS", "<cmd>PDEServe<cr>", { desc = "PDE serve" })
map("n", "<leader>pm", "<cmd>PDEOpenMise<cr>", { desc = "Open .mise.toml" })
map("n", "<leader>pc", "<cmd>PDEOpenProjectConfig<cr>", { desc = "Open pde.toml" })

-- Arduino / embedded
map("n", "<leader>ab", "<cmd>PDEBoards<cr>", { desc = "Arduino boards" })
map("n", "<leader>ap", "<cmd>PDEArduinoProfile<cr>", { desc = "Arduino profile" })
map("n", "<leader>ac", "<cmd>PDEArduinoCompile<cr>", { desc = "Arduino compile" })
map("n", "<leader>aC", "<cmd>PDEArduinoCompileDB<cr>", { desc = "Arduino compile DB" })
map("n", "<leader>au", "<cmd>PDEArduinoUpload<cr>", { desc = "Arduino upload" })
map("n", "<leader>af", "<cmd>PDEArduinoFlash<cr>", { desc = "Arduino flash" })
map("n", "<leader>am", "<cmd>PDEArduinoMonitor<cr>", { desc = "Arduino monitor" })

map("t", "<esc><esc>", "<C-\\><C-n>", opts)
