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
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

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

-- nvimtree
keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

-- Transfer keymaps from the -- New Keymaps -- section
keymap.set("n", "<leader>a", "<cmd>Alpha<cr>", { desc = "Alpha" })
keymap.set("n", "<leader>b", "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>", { desc = "Buffers" })
keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Explorer" })
keymap.set("n", "<leader>w", "<cmd>w!<CR>", { desc = "Save" })
keymap.set("n", "<leader>q", "<cmd>q!<CR>", { desc = "Quit" })
keymap.set("n", "<leader>c", "<cmd>Bdelete!<CR>", { desc = "Close Buffer" })
keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "No Highlight" })
keymap.set("n", "<leader>f", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>", { desc = "Find files" })
keymap.set("n", "<leader>F", "<cmd>Telescope live_grep theme=ivy<cr>", { desc = "Find Text" })
keymap.set("n", "<leader>P", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", { desc = "Projects" })

-- Git keymaps
keymap.set("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Lazygit" })
keymap.set("n", "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", { desc = "Next Hunk" })
keymap.set("n", "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", { desc = "Prev Hunk" })
keymap.set("n", "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", { desc = "Blame" })
keymap.set("n", "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", { desc = "Preview Hunk" })
keymap.set("n", "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", { desc = "Reset Hunk" })
keymap.set("n", "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", { desc = "Reset Buffer" })
keymap.set("n", "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", { desc = "Stage Hunk" })
keymap.set("n", "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", { desc = "Undo Stage Hunk" })
keymap.set("n", "<leader>go", "<cmd>Telescope git_status<cr>", { desc = "Open changed file" })
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Checkout branch" })
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Checkout commit" })
keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", { desc = "Diff" })

-- LSP keymaps
keymap.set("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code Action" })
keymap.set("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Document Diagnostics" })
keymap.set("n", "<leader>lw", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace Diagnostics" })
keymap.set("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>", { desc = "Format" })
keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "Info" })
keymap.set("n", "<leader>lI", "<cmd>LspInstallInfo<cr>", { desc = "Installer Info" })
keymap.set("n", "<leader>lj", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { desc = "Next Diagnostic" })
keymap.set("n", "<leader>lk", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", { desc = "Prev Diagnostic" })
keymap.set("n", "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", { desc = "CodeLens Action" })
keymap.set("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", { desc = "Quickfix" })
keymap.set("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
keymap.set("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
keymap.set("n", "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace Symbols" })

-- Search keymaps
keymap.set("n", "<leader>sb", "<cmd>Telescope git_branches<cr>", { desc = "Checkout branch" })
keymap.set("n", "<leader>sc", "<cmd>Telescope colorscheme<cr>", { desc = "Colorscheme" })
keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Find Help" })
keymap.set("n", "<leader>sM", "<cmd>Telescope man_pages<cr>", { desc = "Man Pages" })
keymap.set("n", "<leader>sr", "<cmd>Telescope oldfiles<cr>", { desc = "Open Recent File" })
keymap.set("n", "<leader>sR", "<cmd>Telescope registers<cr>", { desc = "Registers" })
keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
keymap.set("n", "<leader>sC", "<cmd>Telescope commands<cr>", { desc = "Commands" })

-- Terminal keymaps
keymap.set("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", { desc = "Node" })
keymap.set("n", "<leader>tu", "<cmd>lua _NCDU_TOGGLE()<cr>", { desc = "NCDU" })
keymap.set("n", "<leader>tt", "<cmd>lua _HTOP_TOGGLE()<cr>", { desc = "Htop" })
keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", { desc = "Python" })
keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float" })
keymap.set("n", "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", { desc = "Horizontal" })
keymap.set("n", "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", { desc = "Vertical" })
