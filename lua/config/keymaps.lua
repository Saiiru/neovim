-- Neovim Core Keymap Configuration
-- This configuration is automatically loaded on the VeryLazy event.
-- Plugin-specific keymaps have been removed for a lean, core experience.
-- Enjoy a robust, maintainable mapping setup—crafted with the precision of clean architecture.

local map = vim.keymap.set

-- ============================================================================
-- General Utilities & Navigation
-- ============================================================================

-- Basic indentation commands.
map("n", "<", "<<", { desc = "Deindent" })
map("n", ">", ">>", { desc = "Indent" })

-- Save without running auto-commands (and thus without formatting).
map("n", "<A-s>", "<cmd>noautocmd w<CR>", { desc = "Save without formatting" })

-- Replace all instances of the highlighted word.
map("v", "<leader>rr", '"hy:%s/<C-r>h//g<left><left>', { desc = "Replace highlighted words" })
map("n", "<leader>rr", '"hy:%s/<C-r>h//g<left><left>', { desc = "Replace highlighted words" })

-- Cursor movement in insert mode (using Alt-modifiers).
map("i", "<M-h>", "<left>", { desc = "Move cursor left" })
map("i", "<M-l>", "<right>", { desc = "Move cursor right" })
map("i", "<M-j>", "<down>", { desc = "Move cursor down" })
map("i", "<M-k>", "<up>", { desc = "Move cursor up" })

-- Navigate to the end of the previous word.
map("n", "E", "ge", { desc = "End of word backwards" })

-- Increment and decrement numbers.
map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Decrement number" })

-- ============================================================================
-- Tab and Buffer Management
-- ============================================================================

-- Tab navigation: next, previous, and jump to a specific tab.
map("n", "]<tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "[<tab>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<s-tab>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

for i = 1, 9 do
  map("n", "<leader><tab>" .. i, "<cmd>tabn " .. i .. "<CR>", { desc = "Go to tab " .. i })
end

-- Select a tab from a list with a custom prompt.
map("n", "<leader>f<tab>", function()
  vim.ui.select(vim.api.nvim_list_tabpages(), {
    prompt = "Select Tab:",
    format_item = function(tabid)
      local wins = vim.api.nvim_tabpage_list_wins(tabid)
      local not_floating = function(winid)
        return vim.api.nvim_win_get_config(winid).relative == ""
      end
      wins = vim.tbl_filter(not_floating, wins)
      local buffers = {}
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
        if buftype ~= "nofile" then
          local fname = vim.api.nvim_buf_get_name(buf)
          table.insert(buffers, vim.fn.fnamemodify(fname, ":t"))
        end
      end
      local tabnr = vim.api.nvim_tabpage_get_number(tabid)
      local cwd = string.format(" %8s: ", vim.fn.fnamemodify(vim.fn.getcwd(-1, tabnr), ":t"))
      local is_current = vim.api.nvim_tabpage_get_number(0) == tabnr and "✸" or " "
      return tabnr .. is_current .. cwd .. table.concat(buffers, ", ")
    end,
  }, function(tabid)
    if tabid then
      vim.cmd(tabid .. "tabnext")
      vim.notify("Switched to Tab " .. tabid, vim.log.levels.INFO)
    end
  end)
end, { desc = "Select Tab" })

-- Buffer management: first, last, and open current buffer in a new tab.
map("n", "<leader>bf", "<cmd>bfirst<CR>", { desc = "First buffer" })
map("n", "<leader>ba", "<cmd>blast<CR>", { desc = "Last buffer" })
map("n", "<leader>b<tab>", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- ============================================================================
-- Miscellaneous Navigation & Window Management
-- ============================================================================

-- Comment box navigation (assuming a design with box drawing characters).
map("n", "]/", "/\\S\\zs\\s*╭<CR>zt", { desc = "Next block comment" })
map("n", "[/", "?\\S\\zs\\s*╭<CR>zt", { desc = "Previous block comment" })

-- Redo operation (using U instead of the default).
map("n", "U", "<C-r>", { desc = "Redo" })

-- Copy the entire buffer to the system clipboard.
map("n", "<C-c>", ":%y+<CR>", { desc = "Copy whole text to clipboard", silent = true })

-- Enhanced motion: start and end of line navigation.
map("c", "<C-a>", "<C-b>", { desc = "Start of line" })
map("i", "<C-a>", "<Home>", { desc = "Start of line" })
map("i", "<C-e>", "<End>", { desc = "End of line" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })

-- Swap search navigation directions.
map("n", "gn", "gN", { desc = "Search next" })
map("n", "gN", "gn", { desc = "Search previous" })

-- Window and tab closing/saving commands.
map("n", "<leader>q", "<cmd>q!<CR>", { desc = "Quit current window" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save current file" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all windows" })
map("n", "<leader>W", "<cmd>wa<CR>", { desc = "Save all files" })
map("n", "<leader>c", "<cmd>close<CR>", { desc = "Close current window" })
map("n", "<leader>x", "<cmd>q<CR>", { desc = "Quit current window" })

-- Quickly insert a comment (positioning the cursor in insert mode).
map("n", "/*", "i/*", { desc = "Insert comment" })

-- Reload the current file (jump to file).
map("n", "<leader>tf", "<cmd>e %<CR>", { desc = "Edit current file" })

-- ============================================================================
-- Splits & Resizing
-- ============================================================================

vim.api.nvim_set_keymap("n", "<C-W>,", ":vertical resize -10<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-W>.", ":vertical resize +10<CR>", { noremap = true })
map("n", "<space><space>", "<cmd>set nohlsearch<CR>", { desc = "Disable search highlight" })
map("n", "<leader>qq", ":q<CR>", { silent = true, noremap = true, desc = "Quick close split" })

-- ============================================================================
-- Visual Mode & Clipboard
-- ============================================================================

-- Disable default Space behavior in normal and visual modes.
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Handle word wrap navigation gracefully.
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- In visual mode: paste without overwriting the default register.
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Yank to the system clipboard.
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })

-- Delete without yanking.
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d", { desc = "Delete without yank" })

-- ============================================================================
-- Insert Mode Enhancements & Miscellaneous Commands
-- ============================================================================

-- Map jj in insert mode to exit insert mode.
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })

-- Remap <C-c> in insert mode to escape.
map("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

-- Disable the default Q key.
map("n", "Q", "<nop>", { desc = "Disable Q" })

-- Quick file permission change: make the file executable.
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make file executable", silent = true })

-- Insert code snippets for Go error handling.
map("n", "<leader>ee", "<cmd>GoIfErr<CR>", { silent = true, noremap = true, desc = "Insert Go error handling snippet" })
map("n", "<leader>ea", "oassert.NoError(err, \"\")<Esc>F\";a", { desc = "Insert no-error assertion" })
map("n", "<leader>ef", "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj", { desc = "Insert fatal error logging" })
map("n", "<leader>el", "oif err != nil {<CR>}<Esc>O.logger.Error(\"error\", \"error\", err)<Esc>F.;i", { desc = "Insert error logging" })

-- Quick access to edit a frequently used configuration file.
map("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>", { desc = "Edit packer config" })

-- Reload the configuration.
map("n", "<leader><leader>", function()
  vim.cmd("so")
end, { desc = "Reload configuration" })

-- ============================================================================
-- Built-in LSP Formatting
-- ============================================================================

-- Format the current document using Neovim's built-in LSP.
map("n", "<leader>f", vim.lsp.buf.format, { desc = "Format document" })

-- Quick navigation for quickfix and location lists.
map("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next in quickfix list" })
map("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous in quickfix list" })
map("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next in location list" })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous in location list" })

-- ============================================================================
-- Search & Replace
-- ============================================================================

-- Initiate a search and replace for the word under the cursor.
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace word" })

-- ============================================================================
-- Set Leader
-- ============================================================================

vim.g.mapleader = " "

-- ============================================================================
-- WezTerm Integration
-- ============================================================================

-- Open a new WezTerm window.
map("n", "<leader>wt", "<cmd>!wezterm start<CR>", { desc = "Open new WezTerm window", silent = true })

-- ============================================================================
-- Tmux Integration
-- ============================================================================

-- Split Tmux window horizontally.
map("n", "<leader>th", "<cmd>!tmux split-window -h<CR>", { desc = "Split Tmux window horizontally", silent = true })

-- Split Tmux window vertically.
map("n", "<leader>tv", "<cmd>!tmux split-window -v<CR>", { desc = "Split Tmux window vertically", silent = true })

-- Navigate Tmux panes.
map("n", "<leader>tn", "<cmd>!tmux select-pane -t :.next<CR>", { desc = "Next Tmux pane", silent = true })
map("n", "<leader>tp", "<cmd>!tmux select-pane -t :.prev<CR>", { desc = "Previous Tmux pane", silent = true })

-- End of configuration.
return {}