-- lua/config/keymaps.lua

vim.g.mapleader = " "
vim.g.maplocalleader = " "
local map = vim.keymap.set
local utils = require("config.utils")

-- ── Custom Functions ─────────────────────────────────────────────────────────
map("n", "gf", function()
  OpenFile()
end, { desc = "Open or create file under cursor", noremap = true, silent = true })

-- ── Navigation ───────────────────────────────────────────────────────────────

-- Disable double click mouse
vim.api.nvim_set_keymap("n", "<2-LeftMouse>", "", { noremap = true, silent = true })

-- j/k respeitam linhas quebradas visualmente, mas preservam contagens como `10j`.
map("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { desc = "Down (wrap-aware)", expr = true, noremap = true, silent = true })
map("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { desc = "Up (wrap-aware)", expr = true, noremap = true, silent = true })

-- Mantém H/M/L, J e K nativos para aprender Vim de verdade.
-- Movimento acelerado fica em Alt+h/j/k/l.
map({ "n", "v" }, "<A-h>", "5h", { desc = "Move Left x5", noremap = true, silent = false })
map({ "n", "v" }, "<A-j>", "5j", { desc = "Move Down x5", noremap = true, silent = false })
map({ "n", "v" }, "<A-k>", "5k", { desc = "Move Up x5", noremap = true, silent = false })
map({ "n", "v" }, "<A-l>", "5l", { desc = "Move Right x5", noremap = true, silent = false })
map("n", "J", "mzJ`z", { desc = "Join Lines Keep Cursor", noremap = true, silent = true })

-- Busca e scroll centralizados deixam navegação longa menos cansativa.
map("n", "n", "nzzzv", { desc = "Next Search Result Centered", noremap = true, silent = true })
map("n", "N", "Nzzzv", { desc = "Previous Search Result Centered", noremap = true, silent = true })
map("n", "<C-d>", "<C-d>zz", { desc = "Half Page Down Centered", noremap = true, silent = true })
map("n", "<C-u>", "<C-u>zz", { desc = "Half Page Up Centered", noremap = true, silent = true })

-- Remapping escape key
map({ "i", "v" }, "kj", "<Esc>", { desc = "Escape", noremap = true, silent = true })
map("t", "<Esc><Esc>", "<C-\\><C-N>", { desc = "Escape Term Mode", noremap = true, silent = true })

-- ── Editing ──────────────────────────────────────────────────────────────────

-- Indenting
map("v", "<", "<gv", { desc = "Indent Left", noremap = true, silent = false })
map("v", ">", ">gv", { desc = "Indent Right", noremap = true, silent = false })

-- Copy-Pasting
map("v", "<C-c>", "\"+y", { desc = "Copy To Clipboard", noremap = true, silent = false })
map("n", "<C-s>", "\"+P", { desc = "Paste From Clipboard", noremap = true, silent = false })

-- Add semicolon at the end of the line
map("i", "<C-;>", "<esc>A;<esc>i", { desc = "Semicolon at end", noremap = true, silent = true })
map("n", "<leader>3", function()
  vim.cmd("retab")
  vim.cmd("FixWhitespace")
end, { desc = "Retab + Fix Whitespace", noremap = true, silent = true })

-- ── Window Management ────────────────────────────────────────────────────────

-- Focus between windows
map("n", "<C-h>", "<C-w>h", { desc = "Focus Left", noremap = true, silent = false })
map("n", "<C-j>", "<C-w>j", { desc = "Focus Down", noremap = true, silent = false })
map("n", "<C-k>", "<C-w>k", { desc = "Focus Up", noremap = true, silent = false })
map("n", "<C-l>", "<C-w>l", { desc = "Focus Right", noremap = true, silent = false })

-- Resize windows
map("n", "<C-S-H>", "3<C-w>>", { desc = "Resize Width +", noremap = true, silent = false })
map("n", "<C-S-J>", "3<C-w>-", { desc = "Resize Height -", noremap = true, silent = false })
map("n", "<C-S-K>", "3<C-w>+", { desc = "Resize Height +", noremap = true, silent = false })
map("n", "<C-S-L>", "3<C-w><", { desc = "Resize Width -", noremap = true, silent = false })

-- Splits
map("n", "<leader>pv", "<C-w>v", { desc = "Split Vertically", noremap = true, silent = false })
map("n", "<leader>ph", "<C-w>s", { desc = "Split Horizontally", noremap = true, silent = false })
map("n", "<leader>pe", "<C-w>=", { desc = "Equal Split", noremap = true, silent = false })
map("n", "<leader>px", ":close<CR>", { desc = "Close Split", noremap = true, silent = false })
map("n", "<leader>po", ":only<CR>", { desc = "Single Pane", noremap = true, silent = false })

-- ── Buffers ──────────────────────────────────────────────────────────────────
map("n", "<Tab>", ":bnext<cr>", { desc = "Next Buffer", noremap = true, silent = true })
map("n", "<S-Tab>", ":bprevious<cr>", { desc = "Previous Buffer", noremap = true, silent = true })
map("n", "<leader>bn", ":enew<cr>", { desc = "New Empty Buffer", noremap = true, silent = true })
map("n", "<leader>bl", ":blast<cr>", { desc = "Last Buffer", noremap = true, silent = true })
map("n", "<leader>ba", ":%bdelete!<cr>", { desc = "Delete All Buffers", noremap = true, silent = true })
map("n", "<leader>bs", ":source %<cr>", { desc = "Source Buffer", noremap = true, silent = true })


-- ── File Operations ──────────────────────────────────────────────────────────
map("n", "<leader>q", ":q<cr>", { desc = "Quit File", noremap = true, silent = true })
map("n", "<leader>Q", ":qa<cr>", { desc = "Quit All", noremap = true, silent = true })
map("n", "<leader>w", ":w<cr>", { desc = "Write File", noremap = true, silent = true })
map("n", "<leader>W", ":wa<cr>", { desc = "Write All", noremap = true, silent = true })
map("n", "<leader>M", ":messages<cr>", { desc = "Show Messages", noremap = true, silent = true })

-- ── Options & UI ─────────────────────────────────────────────────────────────
map("n", "<leader>ow", ":set wrap!<cr>", { desc = "Toggle Wrap", noremap = true, silent = true })
map("n", "<leader>ol", ":set linebreak!<cr>", { desc = "Toggle Linebreak", noremap = true, silent = true })
map("n", "<leader>os", ":set spell!<cr>", { desc = "Toggle Spell Check", noremap = true, silent = true })
map("n", "<leader>oS", function()
  SpellToggle("en_us,pt_br")
end, { desc = "Toggle Spell EN/PT", noremap = true, silent = true })

map("n", "<leader>z", "[s1z=``", { desc = "Fix Previous Spelling", noremap = true, silent = true })
map("n", "<leader>oe", "<cmd>LtexEnglish<cr>", { desc = "LTeX English", noremap = true, silent = true })
map("n", "<leader>op", "<cmd>LtexPortuguese<cr>", { desc = "LTeX Portuguese", noremap = true, silent = true })
map("n", "<leader>oa", "<cmd>LtexAuto<cr>", { desc = "LTeX Auto Language", noremap = true, silent = true })
map("n", "<leader>oh", ":set hlsearch!<cr>", { desc = "Toggle Search Highlight", noremap = true, silent = false })
map("n", "<leader>od", ":pwd<cr>", { desc = "Show CWD", noremap = true, silent = false })
map(
  "n",
  "<leader>oc",
  ":lua ToggleConcealLevel()<cr>",
  { desc = "Toggle Conceallevel", noremap = true, silent = false }
)
map("n", "<leader>on", function()
  utils.launch_notepad()
end, { desc = "Toggle Notepad", noremap = true, silent = true })
map("n", "<leader>oN", function()
  utils.save_notepad()
end, { desc = "Save Notepad", noremap = true, silent = true })
map("n", "<leader>?m", function()
  require("config.cheatsheets").open("motions")
end, { desc = "Help: Vim Motions", noremap = true, silent = true })
map("n", "<leader>?s", function()
  require("config.cheatsheets").open("surround")
end, { desc = "Help: Surround", noremap = true, silent = true })
map("n", "<leader>?v", function()
  require("config.cheatsheets").open("multicursor")
end, { desc = "Help: Visual Multi", noremap = true, silent = true })
map("n", "<leader>?t", function()
  require("config.cheatsheets").open("tasks")
end, { desc = "Help: Project Tasks", noremap = true, silent = true })

-- ── Quickfix ─────────────────────────────────────────────────────────────────
map("n", "<C-n>", ":cnext<cr>", { desc = "Quickfix Next", noremap = true, silent = true })
map("n", "<C-p>", ":cprev<cr>", { desc = "Quickfix Prev", noremap = true, silent = true })
map("n", "<C-q>", ":cclose<cr>", { desc = "Quickfix Close", noremap = true, silent = false })
map(
  "n",
  "<leader>cq",
  "<cmd>DiagnosticsQuickfix<cr>",
  { desc = "Diagnostics To Quickfix", noremap = true, silent = true }
)
map(
  "n",
  "<leader>cQ",
  "<cmd>DiagnosticsQuickfix!<cr>",
  { desc = "Buffer Diagnostics To Quickfix", noremap = true, silent = true }
)
map("n", "<leader>cn", ":cnext<cr>", { desc = "Quickfix Next", noremap = true, silent = true })
map("n", "<leader>cp", ":cprevious<cr>", { desc = "Quickfix Previous", noremap = true, silent = true })
map("n", "<leader>cO", ":copen<cr>", { desc = "Quickfix Open", noremap = true, silent = true })
map("n", "<leader>cc", ":cclose<cr>", { desc = "Quickfix Close", noremap = true, silent = true })

-- ── Terminal ─────────────────────────────────────────────────────────────────
map("n", "<leader>t", ":sp<bar>term<cr>:resize 10<cr>", { desc = "Split Terminal", noremap = true, silent = true })

-- ── LSP (Legacy/Fallback) ────────────────────────────────────────────────────
map("n", "<leader>lk", ":lua vim.lsp.buf.hover()<cr>", { desc = "LSP Hover", noremap = true, silent = true })
map("n", "<leader>ld", ":lua vim.lsp.buf.definition()<cr>", { desc = "LSP Definition", noremap = true, silent = true })
map(
  "n",
  "<leader>lt",
  ":lua vim.lsp.buf.type_definition()<cr>",
  { desc = "Type Definition", noremap = true, silent = true }
)
map(
  "n",
  "<leader>ln",
  ":lua vim.diagnostic.goto_next()<cr>",
  { desc = "Diagnostic Next", noremap = true, silent = true }
)
map(
  "n",
  "<leader>lN",
  ":lua vim.diagnostic.goto_prev()<cr>",
  { desc = "Diagnostic Previous", noremap = true, silent = true }
)
map("n", "<leader>lr", ":lua vim.lsp.buf.references()<cr>", { desc = "LSP References", noremap = true, silent = true })
map("n", "<leader>lR", ":lua vim.lsp.buf.rename()<cr>", { desc = "LSP Rename", noremap = true, silent = true })
