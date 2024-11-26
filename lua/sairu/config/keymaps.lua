-- File: lua/config/keymaps.lua
-- Keymaps for Neovim, tailored for ex-VSCode users and enhanced productivity.

-- Set the leader key
vim.g.mapleader = " " -- Space as leader
vim.g.maplocalleader = " "

-- General options for keymaps
local opts = { noremap = true, silent = true }

-- Utility function for adding keymaps with descriptions
local function map(mode, key, action, description)
  vim.keymap.set(mode, key, action, vim.tbl_extend("force", opts, { desc = description }))
end
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
--- General Keymaps ---
-- Basic navigation improvements
map("n", "J", "mzJ`z", "Join lines and retain cursor position")
map("n", "<C-d>", "<C-d>zz", "Scroll down while keeping the cursor centered")
map("n", "<C-u>", "<C-u>zz", "Scroll up while keeping the cursor centered")

--- Split Creation ---
map("n", "<leader>sh", ":split<CR>", "Open horizontal split")
map("n", "<leader>sv", ":vsplit<CR>", "Open vertical split")

--- Centered Search Results ---
map("n", "n", "nzzzv", "Next search match and center")
map("n", "N", "Nzzzv", "Previous search match and center")

-- File management
map("n", "<leader>w", ":w<CR>", "Save the current file")
map("n", "<leader>q", ":q<CR>", "Quit the current window")

-- Split Buffers Navigation
-- Use Ctrl + h/j/k/l to navigate between splits (left, down, up, right)
map("n", "<C-h>", "<C-w>h", "Move focus to the left split")
map("n", "<C-j>", "<C-w>j", "Move focus to the bottom split")
map("n", "<C-k>", "<C-w>k", "Move focus to the top split")
map("n", "<C-l>", "<C-w>l", "Move focus to the right split")

-- Split resizing
-- Resize splits using Ctrl + Alt + Arrow keys
map("n", "<C-S-Down>", ":resize +2<CR>", "Resize split horizontally down")
map("n", "<C-S-Up>", ":resize -2<CR>", "Resize split horizontally up")
map("n", "<C-Left>", ":vertical resize -2<CR>", "Resize split vertically left")
map("n", "<C-Right>", ":vertical resize +2<CR>", "Resize split vertically right")

-- Create new splits
map("n", "<leader>ss", ":split<CR>", "Split window horizontally")
map("n", "<leader>sv", ":vsplit<CR>", "Split window vertically")

-- Close current split
map("n", "<leader>sc", ":close<CR>", "Close current split")
-- Close all splits except current one
map("n", "<leader>sa", ":only<CR>", "Close all splits except current one")

-- Switch between buffers in splits
map("n", "<leader>bn", ":bnext<CR>", "Go to next buffer")
map("n", "<leader>bp", ":bprev<CR>", "Go to previous buffer")

-- Switch between buffers with alternate file
map("n", "<leader><leader>", ":b#<CR>", "Switch to the alternate buffer")

-- Move the current window to a new tab
map("n", "<leader>tt", ":tabnew<CR>", "Open a new tab")
map("n", "<leader>tn", ":tabnext<CR>", "Switch to the next tab")
map("n", "<leader>tp", ":tabprevious<CR>", "Switch to the previous tab")
 
