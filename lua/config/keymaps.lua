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

-- General mappings
map("n", "-", "<CMD>Oil --float<CR>", "Open parent directory")
map("n", "<C-s>", "<cmd>w<CR>", "Save file")
map("i", "jk", "<ESC>", "Escape insert mode")
map("n", "<C-c>", "<cmd>%y+<CR>", "Copy whole file content")

-- Basic navigation improvements
map("n", "J", "mzJ`z", "Join lines and retain cursor position")
map("n", "<C-d>", "<C-d>zz", "Scroll down while keeping the cursor centered")
map("n", "<C-u>", "<C-u>zz", "Scroll up while keeping the cursor centered")

-- Split Creation
map("n", "<leader>sh", ":split<CR>", "Open horizontal split")
map("n", "<leader>sv", ":vsplit<CR>", "Open vertical split")

-- Centered Search Results
map("n", "n", "nzzzv", "Next search match and center")
map("n", "N", "Nzzzv", "Previous search match and center")

-- File management
map("n", "<leader>w", ":w<CR>", "Save the current file")
map("n", "<leader>q", ":q<CR>", "Quit the current window")

-- Split Buffers Navigation
map("n", "<C-h>", "<C-w>h", "Move focus to the left split")
map("n", "<C-j>", "<C-w>j", "Move focus to the bottom split")
map("n", "<C-k>", "<C-w>k", "Move focus to the top split")
map("n", "<C-l>", "<C-w>l", "Move focus to the right split")

-- Split resizing
map("n", "<C-S-Down>", ":resize +2<CR>", "Resize split horizontally down")
map("n", "<C-S-Up>", ":resize -2<CR>", "Resize split horizontally up")
map("n", "<C-Left>", ":vertical resize -2<CR>", "Resize split vertically left")
map("n", "<C-Right>", ":vertical resize +2<CR>", "Resize split vertically right")

-- Create new splits
map("n", "<leader>ss", ":split<CR>", "Split window horizontally")
map("n", "<leader>sv", ":vsplit<CR>", "Split window vertically")

-- Close splits
map("n", "<leader>sc", ":close<CR>", "Close current split")
map("n", "<leader>sa", ":only<CR>", "Close all splits except current one")

-- Switch between buffers in splits
map("n", "<leader>bn", ":bnext<CR>", "Go to next buffer")
map("n", "<leader>bp", ":bprev<CR>", "Go to previous buffer")
map("n", "<leader><leader>", ":b#<CR>", "Switch to the alternate buffer")

-- Tab management
map("n", "<leader>tt", ":tabnew<CR>", "Open a new tab")
map("n", "<leader>tn", ":tabnext<CR>", "Switch to the next tab")
map("n", "<leader>tp", ":tabprevious<CR>", "Switch to the previous tab")

-- NvimTree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", "Toggle NvimTree")
map("n", "<C-h>", "<cmd>NvimTreeFocus<CR>", "Focus NvimTree")

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", "Find files")
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", "Find recently opened files")
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", "Live grep")
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", "Git status")

-- Bufferline
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", "Cycle to next buffer")
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", "Cycle to previous buffer")
map("n", "<C-q>", "<cmd>bd<CR>", "Close buffer")

-- Comment.nvim
map("n", "<leader>/", "gcc", "Toggle comment (line)")
map("v", "<leader>/", "gc", "Toggle comment (selection)")

-- Format
map("n", "<leader>fm", function()
  require("conform").format()
end, "Format code")
