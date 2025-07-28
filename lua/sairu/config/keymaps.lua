-- Keymap Configuration - BATMAN VEGA Control Matrix
-- =================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader Key Assignment - Command Center Access
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Visual Mode Operations - Block Manipulation Protocol
map("v", "J", ":m '>+1<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection down" }))
map("v", "K", ":m '<-2<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection up" }))

-- Normal Mode Navigation - Enhanced Scroll Matrix
map("n", "<C-d>", "<C-d>zz", vim.tbl_extend("force", opts, { desc = "Scroll down and center" }))
map("n", "<C-u>", "<C-u>zz", vim.tbl_extend("force", opts, { desc = "Scroll up and center" }))
map("n", "n", "nzzzv", vim.tbl_extend("force", opts, { desc = "Next search result centered" }))
map("n", "N", "Nzzzv", vim.tbl_extend("force", opts, { desc = "Previous search result centered" }))

-- Pane Navigation Protocol - Window Management System
map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Move to left pane" }))
map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Move to lower pane" }))
map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Move to upper pane" }))
map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Move to right pane" }))

-- Split Management Matrix - Window Control Protocol
map("n", "<leader>sv", "<C-w>v", vim.tbl_extend("force", opts, { desc = "Split window vertically" }))
map("n", "<leader>sh", "<C-w>s", vim.tbl_extend("force", opts, { desc = "Split window horizontally" }))
map("n", "<leader>se", "<C-w>=", vim.tbl_extend("force", opts, { desc = "Make splits equal size" }))
map("n", "<leader>sx", "<cmd>close<CR>", vim.tbl_extend("force", opts, { desc = "Close current split" }))

-- Tab Management Protocol - Interface Segmentation
map("n", "<leader>tc", "<cmd>tabnew<CR>", vim.tbl_extend("force", opts, { desc = "Open new tab" }))
map("n", "<leader>tn", "<cmd>tabn<CR>", vim.tbl_extend("force", opts, { desc = "Go to next tab" }))
map("n", "<leader>tp", "<cmd>tabp<CR>", vim.tbl_extend("force", opts, { desc = "Go to previous tab" }))

-- Register Protection System - Memory Safe Operations
map("n", "<leader>y", '"+y', vim.tbl_extend("force", opts, { desc = "Yank to system clipboard" }))
map("v", "<leader>y", '"+y', vim.tbl_extend("force", opts, { desc = "Yank selection to clipboard" }))
map("n", "<leader>d", '"_d', vim.tbl_extend("force", opts, { desc = "Delete without affecting registers" }))
map("v", "<leader>d", '"_d', vim.tbl_extend("force", opts, { desc = "Delete selection without register" }))
map("x", "<leader>p", '"_dP', vim.tbl_extend("force", opts, { desc = "Paste without affecting registers" }))

-- File Operations Matrix - Document Management
map("n", "<leader>w", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "Save file" }))
map("n", "<leader>q", "<cmd>q<CR>", vim.tbl_extend("force", opts, { desc = "Quit current buffer" }))
map("n", "<leader>Q", "<cmd>qa<CR>", vim.tbl_extend("force", opts, { desc = "Quit all buffers" }))

-- File Path Operations - Location Intelligence
map("n", "<leader>fp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Path copied: " .. path, vim.log.levels.INFO)
end, vim.tbl_extend("force", opts, { desc = "Copy file path to clipboard" }))

-- LSP Diagnostics Toggle - Error Detection Control
map("n", "<leader>lx", function()
  local current_value = vim.diagnostic.config().virtual_text
  if current_value then
    vim.diagnostic.config({ virtual_text = false })
    vim.notify("LSP diagnostics disabled", vim.log.levels.INFO)
  else
    vim.diagnostic.config({ virtual_text = true })
    vim.notify("LSP diagnostics enabled", vim.log.levels.INFO)
  end
end, vim.tbl_extend("force", opts, { desc = "Toggle LSP diagnostics" }))

-- Go Development Snippets - Language Enhancement Protocol
map("n", "<leader>er", function()
  vim.api.nvim_put({ "if err != nil {", "\treturn err", "}" }, "l", true, true)
end, vim.tbl_extend("force", opts, { desc = "Insert Go error return" }))

map("n", "<leader>ea", function()
  vim.api.nvim_put({ "if err != nil {", "\tlog.Fatal(err)", "}" }, "l", true, true)
end, vim.tbl_extend("force", opts, { desc = "Insert Go error abort" }))

map("n", "<leader>ef", function()
  vim.api.nvim_put({ "if err != nil {", "\tfmt.Printf(\"Error: %v\\n\", err)", "\treturn", "}" }, "l", true, true)
end, vim.tbl_extend("force", opts, { desc = "Insert Go error format" }))

map("n", "<leader>el", function()
  vim.api.nvim_put({ "if err != nil {", "\tlog.Printf(\"Error: %v\", err)", "\treturn", "}" }, "l", true, true)
end, vim.tbl_extend("force", opts, { desc = "Insert Go error log" }))

-- Run-on-Save Protocol - Execution Matrix
map("n", "<leader>R", function()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand("%")
  local commands = {
    c = "gcc " .. filename .. " -o " .. vim.fn.expand("%:r") .. " && ./" .. vim.fn.expand("%:r"),
    cpp = "g++ " .. filename .. " -o " .. vim.fn.expand("%:r") .. " && ./" .. vim.fn.expand("%:r"),
    java = "javac " .. filename .. " && java " .. vim.fn.expand("%:r"),
    go = "go run " .. filename,
    python = "python3 " .. filename,
    lua = "lua " .. filename,
  }
  
  local cmd = commands[filetype]
  if cmd then
    vim.cmd("split")
    vim.cmd("terminal " .. cmd)
    vim.cmd("resize 10")
  else
    vim.notify("No run command configured for filetype: " .. filetype, vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts, { desc = "Run current file" }))

-- Quick Operations - System Shortcuts
map("n", "J", "mzJ`z", vim.tbl_extend("force", opts, { desc = "Join lines keeping cursor position" }))
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", vim.tbl_extend("force", opts, { desc = "Open tmux sessionizer" }))
map("n", "<leader><leader>", function() vim.cmd("so") end, vim.tbl_extend("force", opts, { desc = "Source current file" }))

-- Clear Search Highlighting
map("n", "<Esc>", "<cmd>nohlsearch<CR>", vim.tbl_extend("force", opts, { desc = "Clear search highlighting" }))
