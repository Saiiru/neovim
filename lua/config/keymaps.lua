-- Define the leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- Exit insert mode with jk
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

---------------------
-- Window Management -------------------

-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

---------------------
-- Tab Management -------------------

-- Tab navigation
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

---------------------
-- Miscellaneous -------------------

-- Black hole paste with delay
keymap.set("x", "<leader>p", function()
    vim.defer_fn(function()
        vim.cmd([[silent! put!]])
    end, 100) -- Delay de 100 ms
end, { desc = "Paste without losing yanked content" })

-- Move line up and down
keymap.set("n", "<A-j>", ":move .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<A-k>", ":move .-2<CR>==", { desc = "Move line up" })

-- Move visual selection up and down
keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", { desc = "Move selection down" })
keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", { desc = "Move selection up" })

---------------------
-- Navigation -------------------

-- Sane split navigation
keymap.set("n", "<C-j>", "<C-W><C-J>", { desc = "Move to the split below" })
keymap.set("n", "<C-k>", "<C-W><C-K>", { desc = "Move to the split above" })
keymap.set("n", "<C-l>", "<C-W><C-L>", { desc = "Move to the split right" })
keymap.set("n", "<C-h>", "<C-W><C-H>", { desc = "Move to the split left" })

-- File browser
keymap.set("n", "<leader>o", "<cmd>Oil<CR>", { desc = "Open file browser" })

-- Trim whitespace
keymap.set("n", "<leader>wt", ":lua MiniTrailspace.trim()<CR>", { desc = "Trim whitespace" })

---------------------
-- Copilot and Telescope -------------------

-- Copilot key binding
keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', { expr = true, script = true, desc = "Accept Copilot suggestion" })

-- Telescope bindings
keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find files (telescope) [Ctrl-p]" })
keymap.set("n", "<C-e>", "<cmd>Telescope live_grep<CR>", { desc = "Search with grep (telescope) [Ctrl-e]" })
keymap.set("n", "<C-b>", "<cmd>Telescope buffers<CR>", { desc = "Find buffers (telescope)" })
keymap.set("n", "<leader>bf", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Fuzzy find in current buffer" })
keymap.set("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols (telescope)" })
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find help tags (telescope)" })
keymap.set("n", "<leader>ft", "<cmd>Telescope git_files<CR>", { desc = "Find git files (telescope)" })
keymap.set("n", "<leader>ts", "<cmd>Telescope tagstack<CR>", { desc = "View tag stack (telescope)" })
keymap.set("n", "<leader>mk", "<cmd>Telescope marks<CR>", { desc = "Find marks (telescope)" })

---------------------
-- Undo Management -------------------

-- Undotree
keymap.set("n", "<leader>ut", "<cmd>UndotreeToggle<CR>", { desc = "Toggle undotree" })

---------------------
-- Scrolling and Searching -------------------

-- Better vertical movements
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Better search jumps
keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

---------------------
-- Todo Comments -------------------

keymap.set("n", "<leader>td", "<cmd>TodoQuickFix<CR>", { desc = "Quick fix for todo comments" })

---------------------
-- Additional Keymaps -------------------

-- Open netrw file explorer
keymap.set("n", "<leader>pv", vim.cmd.Ex) 

-- Move selected text
keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Move selected lines down
keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- Move selected lines up

-- Keep cursor position after joining lines
keymap.set("n", "J", "mzJ`z")

-- Restart LSP
keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- Vim With Me functionality
keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end, { desc = "Start Vim With Me" })

keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end, { desc = "Stop Vim With Me" })

---------------------
-- Make Current File Executable -------------------

-- Chmod keymap
keymap.set("n", "<leader>ch", ":!chmod +x %<CR>", { desc = "Make current file executable" })

