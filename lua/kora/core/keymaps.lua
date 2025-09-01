-- lua/kora/core/keymaps.lua
-- Consolidated keymaps. Keep mappings small and memorable.
-- Intent: no removals, only dedupe and organization.
local map_opts = { noremap = true, silent = true }

-- tiny helper to attach desc cleanly
local function mset(mode, lhs, rhs, desc)
  local o = vim.tbl_extend("force", map_opts, (desc and { desc = desc } or {}))
  vim.keymap.set(mode, lhs, rhs, o)
end

-- Leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Basic remaps
mset("v", "J", ":m '>+1<CR>gv=gv", "Move selected lines down")
mset("v", "K", ":m '<-2<CR>gv=gv", "Move selected lines up")
mset("n", "J", "mzJ`z", "Join line, keep cursor position")

mset("n", "<C-d>", "<C-d>zz", "Scroll half page down, center cursor")
mset("n", "<C-u>", "<C-u>zz", "Scroll half page up, center cursor")
mset("n", "n", "nzzzv", "Next search result, center cursor")
mset("n", "N", "Nzzzv", "Prev search result, center cursor")

mset("v", "<", "<gv", "Unindent selection and keep visual")
mset("v", ">", ">gv", "Indent selection and keep visual")

-- Paste without clobbering unnamed register
mset("x", "<leader>p", [["_dP]], "Paste without yanking selection")
mset("v", "p", '"_dp', "Replace selection without yanking")

-- Clipboard
mset({ "n", "v" }, "<leader>y", [["+y]], "Yank to system clipboard")
mset("n", "<leader>Y", [["+Y]], "Yank line to system clipboard")

-- Delete without yanking
mset({ "n", "v" }, "<leader>d", [["_d]], "Delete without yanking")

-- Convenience
mset("i", "<C-c>", "<Esc>", "Exit Insert mode (Ctrl-C)")
mset("n", "<C-c>", ":nohlsearch<CR>", "Clear search highlights")
mset("n", "Q", "<nop>", "Disable Ex mode")
mset("n", "<leader><leader>", function() vim.cmd("so") end, "Source current file")
mset("n", "<leader>x", "<cmd>!chmod +x %<CR>", "Make file executable")

-- Search/replace current word under cursor
mset("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  "Search & replace word under cursor")

-- Format / LSP helpers
mset("n", "<leader>f", function()
  if vim.fn.exists(":ConformFormat") == 2 or pcall(require, "conform") then
    require("conform").format({ bufnr = 0 })
  else
    vim.lsp.buf.format()
  end
end, "Format buffer (Conform or LSP)")

mset("n", "<leader>zig", "<cmd>LspRestart<cr>", "Restart LSP")

-- Quickfix / Location list navigation
mset("n", "<C-k>", "<cmd>cnext<CR>zz", "Next Quickfix item")
mset("n", "<C-j>", "<cmd>cprev<CR>zz", "Prev Quickfix item")
mset("n", "<leader>k", "<cmd>lnext<CR>zz", "Next Location-list item")
mset("n", "<leader>j", "<cmd>lprev<CR>zz", "Prev Location-list item")

-- Tmux Pane/Window Navigation: Integrates with vim-tmux-navigator for seamless movement.
-- Requires 'christoomey/vim-tmux-navigator' plugin in Neovim and corresponding Tmux configuration.
mset("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", "Navigate left (tmux/vim)")
mset("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", "Navigate down (tmux/vim)")
mset("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", "Navigate up (tmux/vim)")
mset("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", "Navigate right (tmux/vim)")
mset("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", "Navigate previous (tmux/vim)")

-- File explorer
mset("n", "<leader>pv", vim.cmd.Ex, "Open file explorer (netrw)")

-- Paragraph auto-indent
mset("n", "=ap", "ma=ap'a", "Auto-indent paragraph")

-- Start new tmux session or attach to existing one using sesh.
mset("n", "<C-f>", "<cmd>silent !tmux neww sesh connect --choose<CR>", "Start/Attach tmux session (sesh)")

-- Prevent x register from clobbering when deleting single char
mset("n", "x", '"_x', "Delete char without yanking")

-- Tab management
mset("n", "<leader>to", "<cmd>tabnew<CR>", "Open new tab")
mset("n", "<leader>tx", "<cmd>tabclose<CR>", "Close current tab")
mset("n", "<leader>tn", "<cmd>tabn<CR>", "Next tab")
mset("n", "<leader>tp", "<cmd>tabp<CR>", "Previous tab")
mset("n", "<leader>tf", "<cmd>tabnew %<CR>", "Open current buffer in new tab")

-- Split management
mset("n", "<leader>sv", "<C-w>v", "Split vertically")
mset("n", "<leader>sh", "<C-w>s", "Split horizontally")
mset("n", "<leader>se", "<C-w>=", "Make splits equal")
mset("n", "<leader>sx", "<cmd>close<CR>", "Close current split")

-- Copy file path to clipboard
mset("n", "<leader>fp", function()
  local path = vim.fn.expand("%:~")
  vim.fn.setreg("+", path)
  vim.notify("File path copied: " .. path, vim.log.levels.INFO)
end, "Copy file path to clipboard")

-- Toggle LSP diagnostics
do
  local diagnostics_shown = true
  mset("n", "<leader>lx", function()
    diagnostics_shown = not diagnostics_shown
    vim.diagnostic.config({ virtual_text = diagnostics_shown, underline = diagnostics_shown })
  end, "Toggle LSP diagnostics")
end

-- Plugin-specific mappings (kept, but dependent on plugin availability)
-- Plenary test (uses Plug mapping)
mset("n", "<leader>tF", "<Plug>PlenaryTestFile", "Run Plenary test file")
-- VimWithMe plugin
mset("n", "<leader>vwm", function()
  if pcall(require, "vim-with-me") then require("vim-with-me").StartVimWithMe() end
end, "Start VimWithMe session")
mset("n", "<leader>svwm", function()
  if pcall(require, "vim-with-me") then require("vim-with-me").StopVimWithMe() end
end, "Stop VimWithMe session")

-- Cellular Automaton
mset("n", "<leader>ca", function()
  if pcall(require, "cellular-automaton") then
    require("cellular-automaton").start_animation("make_it_rain")
  end
end, "Start cellular-automaton animation")

-- Hightlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("kora-highlight-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- Keep compatibility: if user wants more terse or different leader keys, change at top.
-- End of file.

