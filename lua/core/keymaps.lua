local map = vim.keymap.set
local opts = { silent = true }

-- Core
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<cr>", { desc = "Write file" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Prev search centered" })

-- Windows / buffers / tabs
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader><tab>", "<cmd>b#<cr>", { desc = "Alternate buffer" })
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })

-- Move selected lines
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Clipboard / safer delete
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yank" })
map("x", "<leader>p", '"_dP', { desc = "Paste without replacing register" })

-- Quickfix / location
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix" })
map("n", "[l", "<cmd>lprevious<cr>", { desc = "Previous loclist" })
map("n", "]l", "<cmd>lnext<cr>", { desc = "Next loclist" })

-- Diagnostics / LSP
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>cl", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, { desc = "Format buffer" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

-- Finder
map("n", "<leader>ff", function() require("mini.pick").builtin.files() end, { desc = "Find files" })
map("n", "<leader>fg", function() require("mini.pick").builtin.grep_live() end, { desc = "Grep live" })
map("n", "<leader>fb", function() require("mini.pick").builtin.buffers() end, { desc = "Buffers" })
map("n", "<leader>fh", function() require("mini.pick").builtin.help() end, { desc = "Help" })
map("n", "<leader>fr", function() require("mini.pick").builtin.resume() end, { desc = "Resume picker" })

-- Snippets
-- <Tab>/<S-Tab> ficam com blink.cmp para completion + snippet quando o menu está ativo.
-- <C-j>/<C-k> são salto manual entre placeholders do vim.snippet.
map({ "i", "s" }, "<C-j>", function()
  if vim.snippet.active({ direction = 1 }) then vim.snippet.jump(1) end
end, { desc = "Snippet jump forward" })
map({ "i", "s" }, "<C-k>", function()
  if vim.snippet.active({ direction = -1 }) then vim.snippet.jump(-1) end
end, { desc = "Snippet jump backward" })
map("n", "<leader>si", function() require("pde.snippets").pick() end, { desc = "Insert snippet" })
map("n", "<leader>sl", function() require("pde.snippets").list() end, { desc = "List snippets" })
map("n", "<leader>sm", function() require("pde.snippets").insert("main") end, { desc = "Snippet main" })

-- Git/diff via mini.diff + shell fallback
map("n", "<leader>go", function() require("mini.diff").toggle_overlay() end, { desc = "Toggle diff overlay" })
map("n", "<leader>gs", function()
  vim.cmd("botright split | terminal git status --short && git branch --show-current")
end, { desc = "Git status" })

-- PDE
map("n", "<leader>ps", "<cmd>PDEStatus<cr>", { desc = "PDE status" })
map("n", "<leader>pd", "<cmd>PDEDoctor<cr>", { desc = "PDE doctor" })
map("n", "<leader>pv", "<cmd>PDEVersion<cr>", { desc = "PDE version" })
map("n", "<leader>pb", "<cmd>PDEBuild<cr>", { desc = "PDE build" })
map("n", "<leader>pt", "<cmd>PDETest<cr>", { desc = "PDE test" })
map("n", "<leader>pl", "<cmd>PDELint<cr>", { desc = "PDE lint" })
map("n", "<leader>pf", "<cmd>PDEFormat<cr>", { desc = "PDE format" })
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
