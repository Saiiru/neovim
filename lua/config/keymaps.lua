-- Define the leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

---------------------
-- General Keymaps -------------------

-- Exit insert mode with jk
keymap.set("i", "jk", "<ESC>", opts)

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", opts)

-- Increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", opts)
keymap.set("n", "<leader>-", "<C-x>", opts)

---------------------
-- Window Management -------------------

-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v", opts)
keymap.set("n", "<leader>sh", "<C-w>s", opts)
keymap.set("n", "<leader>se", "<C-w>=", opts)
keymap.set("n", "<leader>sx", "<cmd>close<CR>", opts)

---------------------
-- Tab Management -------------------

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", opts)
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", opts)
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", opts)
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", opts)
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", opts)

---------------------
-- Miscellaneous -------------------

-- Black hole paste with delay
keymap.set("x", "<leader>p", function()
  vim.defer_fn(function()
    vim.cmd([[silent! put!]])
  end, 100)
end, opts)

-- Move line up/down
keymap.set("n", "<A-j>", ":move .+1<CR>==", opts)
keymap.set("n", "<A-k>", ":move .-2<CR>==", opts)
keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

---------------------
-- Navigation -------------------

-- Sane split navigation
keymap.set("n", "<C-j>", "<C-W><C-J>", opts)
keymap.set("n", "<C-k>", "<C-W><C-K>", opts)
keymap.set("n", "<C-l>", "<C-W><C-L>", opts)
keymap.set("n", "<C-h>", "<C-W><C-H>", opts)
-- Navigate buffers
keymap.set("n", "<S-l>", ":bnext<CR>", opts)
keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
-- Open file browser
keymap.set("n", "<leader>o", "<cmd>Oil<CR>", opts)

-- Trim whitespace
keymap.set("n", "<leader>wt", ":lua MiniTrailspace.trim()<CR>", opts)

---------------------
-- Copilot & Telescope -------------------

-- Copilot suggestion (remapped from <C-l> to <C-c>)
keymap.set("i", "<C-c>", 'copilot#Accept("<CR>")', { expr = true, script = true })
--
-- -- Telescope bindings
-- keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", opts)
-- keymap.set("n", "<C-e>", "<cmd>Telescope live_grep<CR>", opts)
-- keymap.set("n", "<C-b>", "<cmd>Telescope buffers<CR>", opts)
-- keymap.set("n", "<leader>bf>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts)
-- keymap.set("n", "<leader>ds>", "<cmd>Telescope lsp_document_symbols<CR>", opts)
-- keymap.set("n", "<leader>fh>", "<cmd>Telescope help_tags<CR>", opts)
-- keymap.set("n", "<leader>ft>", "<cmd>Telescope git_files<CR>", opts)
-- keymap.set("n", "<leader>ts>", "<cmd>Telescope tagstack<CR>", opts)
-- keymap.set("n", "<leader>mk>", "<cmd>Telescope marks<CR>", opts)
--

---------------------
-- Undo Management -------------------

-- Undotree toggle
keymap.set("n", "<leader>ut>", "<cmd>UndotreeToggle<CR>", opts)

---------------------
-- Scrolling & Searching -------------------

-- Better vertical movements
keymap.set("n", "<C-d>", "<C-d>zz>", opts)
keymap.set("n", "<C-u>", "<C-u>zz>", opts)

-- Centered search jumps
keymap.set("n", "n>", "nzzzv>", opts)
keymap.set("n", "N>", "Nzzzv>", opts)

---------------------
-- Todo Comments -------------------

keymap.set("n>", "<leader>td>", "<cmd>TodoQuickFix<CR>", opts)

---------------------
-- Additional Keymaps -------------------

-- Open netrw file explorer
keymap.set("n>", "<leader>pv>", vim.cmd.Ex, opts)

-- Move selected text
keymap.set("v>", "J>", ":m '>+1<CR>gv=gv>", opts)
keymap.set("v>", "K>", ":m '<-2<CR>gv=gv>", opts)

-- Keep cursor position after joining lines
keymap.set("n>", "J>", "mzJ`z>", opts)

-- Restart LSP
keymap.set("n>", "<leader>zig>", "<cmd>LspRestart<CR>", opts)

-- Vim With Me
keymap.set("n>", "<leader>vwm>", function()
  require("vim-with-me").StartVimWithMe()
end, opts)
keymap.set("n>", "<leader>svwm>", function()
  require("vim-with-me").StopVimWithMe()
end, opts)

---------------------
-- Make File Executable -------------------

keymap.set("n>", "<leader>ceh>", ":!chmod +x %<CR>", opts)
-- Alpha shortcut
keymap.set("n>", "<leader>a>", "<cmd>Alpha<CR>", opts)
