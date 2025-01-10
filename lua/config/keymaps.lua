-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local o = vim.opt

local lazy = require("lazy")

-- Search current word with Brave and notify user
local searching_brave = function()
  vim.fn.system({ "xdg-open", "https://google.com/search?q=" .. vim.fn.expand("<cword>") })
  vim.notify("Searching for: " .. vim.fn.expand("<cword>"), vim.log.levels.INFO)
end
map("n", "<leader>?", searching_brave, { noremap = true, silent = true, desc = "Search Current Word on Brave Search" })

-- Lazy options with feedback
map("n", "<leader>l", "<Nop>")
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>ld", function()
  vim.fn.system({ "xdg-open", "https://lazyvim.org" })
  vim.notify("Opening LazyVim Docs", vim.log.levels.INFO)
end, { desc = "LazyVim Docs" })
map("n", "<leader>lr", function()
  vim.fn.system({ "xdg-open", "https://github.com/LazyVim/LazyVim" })
  vim.notify("Opening LazyVim Repo", vim.log.levels.INFO)
end, { desc = "LazyVim Repo" })
map("n", "<leader>lx", "<cmd>LazyExtras<cr>", { desc = "Extras" })
map("n", "<leader>lc", function()
  LazyVim.news.changelog()
  vim.notify("Opening LazyVim Changelog", vim.log.levels.INFO)
end, { desc = "LazyVim Changelog" })

map("n", "<leader>lu", function()
  lazy.update()
  vim.notify("Lazy Update initiated", vim.log.levels.INFO)
end, { desc = "Lazy Update" })
map("n", "<leader>lC", function()
  lazy.check()
  vim.notify("Lazy Check initiated", vim.log.levels.INFO)
end, { desc = "Lazy Check" })
map("n", "<leader>ls", function()
  lazy.sync()
  vim.notify("Lazy Sync initiated", vim.log.levels.INFO)
end, { desc = "Lazy Sync" })

-- Disable LazyVim bindings
map("n", "<leader>L", "<Nop>")
map("n", "<leader>fT", "<Nop>")

-- Identation
map("n", "<", "<<", { desc = "Deindent" })
map("n", ">", ">>", { desc = "Indent" })

-- Save without formatting
map("n", "<A-s>", "<cmd>noautocmd w<CR>", { desc = "Save Without Formatting" })
map("v", "<leader>rr", '"hy:%s/<C-r>h//g<left><left>', { desc = "Replace all instances of highlighted words" })
map("n", "<leader>rr", '"hy:%s/<C-r>h//g<left><left>', { desc = "Replace all instances of highlighted words" })
-- Cursor navigation on insert mode
map("i", "<M-h>", "<left>", { desc = "Move Cursor Left" })
map("i", "<M-l>", "<right>", { desc = "Move Cursor Left" })
map("i", "<M-j>", "<down>", { desc = "Move Cursor Left" })
map("i", "<M-k>", "<up>", { desc = "Move Cursor Left" })

-- End of the word backwards
map("n", "E", "ge")

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- Tabs
map("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<s-tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
for i = 1, 9 do
  map("n", "<leader><tab>" .. i, "<cmd>tabn " .. i .. "<cr>", { desc = "Tab " .. i })
end
map("n", "<leader>f<tab>", function()
  vim.ui.select(vim.api.nvim_list_tabpages(), {
    prompt = "Select Tab:",
    format_item = function(tabid)
      local wins = vim.api.nvim_tabpage_list_wins(tabid)
      local not_floating_win = function(winid)
        return vim.api.nvim_win_get_config(winid).relative == ""
      end
      wins = vim.tbl_filter(not_floating_win, wins)
      local bufs = {}
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
        if buftype ~= "nofile" then
          local fname = vim.api.nvim_buf_get_name(buf)
          table.insert(bufs, vim.fn.fnamemodify(fname, ":t"))
        end
      end
      local tabnr = vim.api.nvim_tabpage_get_number(tabid)
      local cwd = string.format(" %8s: ", vim.fn.fnamemodify(vim.fn.getcwd(-1, tabnr), ":t"))
      local is_current = vim.api.nvim_tabpage_get_number(0) == tabnr and "✸" or " "
      return tabnr .. is_current .. cwd .. table.concat(bufs, ", ")
    end,
  }, function(tabid)
    if tabid ~= nil then
      vim.cmd(tabid .. "tabnext")
      vim.notify("Switched to Tab " .. tabid, vim.log.levels.INFO)
    end
  end)
end, { desc = "Tabs" })

-- Buffers
map("n", "<leader>bf", "<cmd>bfirst<cr>", { desc = "First Buffer" })
map("n", "<leader>ba", "<cmd>blast<cr>", { desc = "Last Buffer" })
map("n", "<leader>b<tab>", "<cmd>tabnew %<cr>", { desc = "Current Buffer in New Tab" })

-- Toggle statusline
map("n", "<leader>uS", function()
  if o.laststatus:get() == 0 then
    o.laststatus = 3
  else
    o.laststatus = 0
  end
  vim.notify("Toggled Statusline", vim.log.levels.INFO)
end, { desc = "Toggle Statusline" })

-- Toggle tabline
map("n", "<leader>u<tab>", function()
  if o.showtabline:get() == 0 then
    o.showtabline = 2
  else
    o.showtabline = 0
  end
  vim.notify("Toggled Tabline", vim.log.levels.INFO)
end, { desc = "Toggle Tabline" })

-- Comment box
map("n", "]/", "/\\S\\zs\\s*╭<CR>zt", { desc = "Next Block Comment" })
map("n", "[/", "?\\S\\zs\\s*╭<CR>zt", { desc = "Prev Block Comment" })

-- Plugin Info
map("n", "<leader>cif", "<cmd>LazyFormatInfo<cr>", { desc = "Formatting" })
map("n", "<leader>cic", "<cmd>ConformInfo<cr>", { desc = "Conform" })
local linters = function()
  local linters_attached = require("lint").linters_by_ft[vim.bo.filetype]
  local buf_linters = {}

  if not linters_attached then
    LazyVim.warn("No linters attached", { title = "Linter" })
    return
  end

  for _, linter in pairs(linters_attached) do
    table.insert(buf_linters, linter)
  end

  local unique_client_names = table.concat(buf_linters, ", ")
  local linters = string.format("%s", unique_client_names)

  LazyVim.notify(linters, { title = "Linter" })
  vim.notify("Attached linters: " .. linters, vim.log.levels.INFO)
end
map("n", "<leader>ciL", linters, { desc = "Lint" })
map("n", "<leader>cir", "<cmd>LazyRoot<cr>", { desc = "Root" })

-- U for redo
map("n", "U", "<C-r>", { desc = "Redo" })

-- Copy whole text to clipboard
map("n", "<C-c>", ":%y+<CR>", { desc = "Copy Whole Text to Clipboard", silent = true })

-- Motion
map("c", "<C-a>", "<C-b>", { desc = "Start Of Line" })
map("i", "<C-a>", "<Home>", { desc = "Start Of Line" })
map("i", "<C-e>", "<End>", { desc = "End Of Line" })

-- Select all text
map("n", "<C-e>", "gg<S-V>G", { desc = "Select all Text", silent = true, noremap = true })

-- Paste options
map("i", "<C-v>", '<C-r>"', { desc = "Paste on Insert Mode" })
map("v", "p", '"_dP', { desc = "Paste Without Overwriting" })

-- Delete and change without yanking
map({ "n", "x" }, "<A-d>", '"_d', { desc = "Delete Without Yanking" })
map({ "n", "x" }, "<A-c>", '"_c', { desc = "Change Without Yanking" })

-- Delete without yanking (for empty lines or any line)
map("n", "<leader>dd", '"_dd', { desc = "Delete Line Without Yanking" })

-- Copy whole text to clipboard
map("n", "<C-c>", ":%y+<CR>", { desc = "Copy Whole Text to Clipboard", silent = true })

-- Paste from clipboard
map("n", "<C-v>", '"+p', { desc = "Paste from Clipboard", silent = true })

-- Navigate through quickfix list
map("n", "<leader>qn", "<cmd>cnext<CR>", { desc = "Next Quickfix Item" })
map("n", "<leader>qp", "<cmd>cprev<CR>", { desc = "Previous Quickfix Item" })

-- Toggle Spell Check
map("n", "<leader>ts", function()
  if vim.wo.spell then
    vim.wo.spell = false
    vim.notify("Spell Check Disabled", vim.log.levels.INFO)
  else
    vim.wo.spell = true
    vim.notify("Spell Check Enabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle Spell Check" })

-- Enable/Disable line numbers
map("n", "<leader>tn", function()
  if vim.wo.number then
    vim.wo.number = false
    vim.notify("Line Numbers Disabled", vim.log.levels.INFO)
  else
    vim.wo.number = true
    vim.notify("Line Numbers Enabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle Line Numbers" })

-- Toggle relative line numbers
map("n", "<leader>tr", function()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.notify("Relative Line Numbers Disabled", vim.log.levels.INFO)
  else
    vim.wo.relativenumber = true
    vim.notify("Relative Line Numbers Enabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle Relative Line Numbers" })

-- Toggle invisible characters
map("n", "<leader>ti", function()
  if vim.wo.list then
    vim.wo.list = false
    vim.notify("Invisible Characters Hidden", vim.log.levels.INFO)
  else
    vim.wo.list = true
    vim.notify("Invisible Characters Shown", vim.log.levels.INFO)
  end
end, { desc = "Toggle Invisible Characters" })

-- Open terminal window
map("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Open Terminal" })

-- Open file tree
map("n", "<leader>ft", "<cmd>Ex<cr>", { desc = "Open File Tree" })

-- Close current buffer
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close Current Buffer" })

-- Close all buffers except the current one
map("n", "<leader>ba", "<cmd>bufdo bd<cr>", { desc = "Close All Buffers Except Current" })

-- Toggle transparency
map("n", "<leader>ttb", function()
  if vim.g.transparent_background then
    vim.g.transparent_background = false
    vim.notify("Transparency Disabled", vim.log.levels.INFO)
  else
    vim.g.transparent_background = true
    vim.notify("Transparency Enabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle Transparency" })

-- Focus on terminal window
map("n", "<leader>ftw", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
      vim.api.nvim_set_current_win(win)
      vim.notify("Switched to Terminal Window", vim.log.levels.INFO)
      return
    end
  end
  vim.notify("No Terminal Windows Found", vim.log.levels.WARN)
end, { desc = "Focus on Terminal Window" })
