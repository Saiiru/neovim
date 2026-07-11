local map = vim.keymap.set
local opts = { silent = true }

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix" })

map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

map("n", "<leader>ff", function() require("mini.pick").builtin.files() end, { desc = "Find files" })
map("n", "<leader>fg", function() require("mini.pick").builtin.grep_live() end, { desc = "Grep live" })
map("n", "<leader>fb", function() require("mini.pick").builtin.buffers() end, { desc = "Buffers" })
map("n", "<leader>fr", function() require("mini.pick").builtin.resume() end, { desc = "Resume picker" })

map("n", "<leader>ps", "<cmd>PDEStatus<cr>", { desc = "PDE status" })
map("n", "<leader>pd", "<cmd>PDEDoctor<cr>", { desc = "PDE doctor" })
map("n", "<leader>pv", "<cmd>PDEVersion<cr>", { desc = "PDE version" })
map("n", "<leader>pb", "<cmd>PDEBuild<cr>", { desc = "PDE build" })
map("n", "<leader>pt", "<cmd>PDETest<cr>", { desc = "PDE test" })
map("n", "<leader>pl", "<cmd>PDELint<cr>", { desc = "PDE lint" })
map("n", "<leader>pf", "<cmd>PDEFormat<cr>", { desc = "PDE format" })
map("n", "<leader>pm", "<cmd>PDEOpenMise<cr>", { desc = "Open .mise.toml" })
map("n", "<leader>pc", "<cmd>PDEOpenProjectConfig<cr>", { desc = "Open pde.toml" })

map("n", "<leader>ab", "<cmd>PDEBoards<cr>", { desc = "Arduino boards" })
map("n", "<leader>ap", "<cmd>PDEArduinoProfile<cr>", { desc = "Arduino profile" })
map("n", "<leader>ac", "<cmd>PDEArduinoCompile<cr>", { desc = "Arduino compile" })
map("n", "<leader>aC", "<cmd>PDEArduinoCompileDB<cr>", { desc = "Arduino compile DB" })
map("n", "<leader>au", "<cmd>PDEArduinoUpload<cr>", { desc = "Arduino upload" })
map("n", "<leader>af", "<cmd>PDEArduinoFlash<cr>", { desc = "Arduino flash" })
map("n", "<leader>am", "<cmd>PDEArduinoMonitor<cr>", { desc = "Arduino monitor" })

map("t", "<esc><esc>", "<C-\\><C-n>", opts)
