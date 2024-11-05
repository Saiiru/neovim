-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local o = vim.opt
local lazy = require("lazy")

-- Search current word
local search_current_word_on_firefox = function()
  local query = vim.fn.expand("<cword>")
  if query ~= "" then
    vim.fn.system({ "xdg-open", "firefox-developer-edition", "https://search.firefox.com/search?q=" .. query })
  else
    print("No word under cursor.")
  end
end
map(
  "n",
  "<leader>?",
  search_current_word_on_firefox,
  { noremap = true, silent = true, desc = "Search Current Word on Firefox" }
)

-- Lazy options
map("n", "<leader>l", "<Nop>")
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>ld", function()
  vim.fn.system({ "xdg-open", "https://lazyvim.org" })
end, { desc = "LazyVim Docs" })
map("n", "<leader>lr", function()
  vim.fn.system({ "xdg-open", "https://github.com/LazyVim/LazyVim" })
end, { desc = "LazyVim Repo" })
map("n", "<leader>lx", "<cmd>LazyExtras<cr>", { desc = "Extras" })
map("n", "<leader>lc", function()
  LazyVim.news.changelog()
end, { desc = "LazyVim Changelog" })

map("n", "<leader>lu", function()
  lazy.update()
end, { desc = "Lazy Update" })
map("n", "<leader>lC", function()
  lazy.check()
end, { desc = "Lazy Check" })
map("n", "<leader>ls", function()
  lazy.sync()
end, { desc = "Lazy Sync" })

-- Disable LazyVim bindings
map("n", "<leader>L", "<Nop>")
map("n", "<leader>fT", "<Nop>")

-- Indentation
map("n", "<", "<<", { desc = "Deindent" })
map("n", ">", ">>", { desc = "Indent" })

-- Save without formatting
map("n", "<A-s>", "<cmd>noautocmd w<CR>", { desc = "Save Without Formatting" })

-- Cursor navigation in insert mode
map("i", "<M-h>", "<left>", { desc = "Move Cursor Left" })
map("i", "<M-l>", "<right>", { desc = "Move Cursor Right" })
map("i", "<M-j>", "<down>", { desc = "Move Cursor Down" })
map("i", "<M-k>", "<up>", { desc = "Move Cursor Up" })

-- End of the word backwards
map("n", "E", "ge")

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- Tab navigation
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
      wins = vim.tbl_filter(function(winid)
        return vim.api.nvim_win_get_config(winid).relative == ""
      end, wins)
      local bufs = {}
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= "nofile" then
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
    end
  end)
end, { desc = "Tabs" })

-- Buffer management
map("n", "<leader>bf", "<cmd>bfirst<cr>", { desc = "First Buffer" })
map("n", "<leader>ba", "<cmd>blast<cr>", { desc = "Last Buffer" })
map("n", "<leader>b<tab>", "<cmd>tabnew %<cr>", { desc = "Current Buffer in New Tab" })

-- Toggle statusline
map("n", "<leader>uS", function()
  o.laststatus = o.laststatus:get() == 0 and 3 or 0
end, { desc = "Toggle Statusline" })

-- Toggle tabline
map("n", "<leader>u<tab>", function()
  o.showtabline = o.showtabline:get() == 0 and 2 or 0
end, { desc = "Toggle Tabline" })

-- Comment box navigation
map("n", "]/", "/\\S\\zs\\s*╭<CR>zt", { desc = "Next Block Comment" })
map("n", "[/", "?\\S\\zs\\s*╭<CR>zt", { desc = "Prev Block Comment" })

-- Plugin Information
map("n", "<leader>cif", "<cmd>LazyFormatInfo<cr>", { desc = "Formatting" })
map("n", "<leader>cic", "<cmd>ConformInfo<cr>", { desc = "Conform" })

-- Linter information
local linters = function()
  local linters_attached = require("lint").linters_by_ft[vim.bo.filetype]
  if not linters_attached then
    LazyVim.warn("No linters attached", { title = "Linter" })
    return
  end
  local unique_client_names = table.concat(linters_attached, ", ")
  LazyVim.notify(unique_client_names, { title = "Linter" })
end
map("n", "<leader>ciL", linters, { desc = "Lint" })
map("n", "<leader>cir", "<cmd>LazyRoot<cr>", { desc = "Root" })

-- Redo action
map("n", "U", "<C-r>", { desc = "Redo" })

-- Copy whole text to clipboard
map("n", "<C-c>", ":%y+<CR>", { desc = "Copy Whole Text to Clipboard", silent = true })

-- Motion
map("c", "<C-a>", "<C-b>", { desc = "Start Of Line" })
map("i", "<C-a>", "<Home>", { desc = "Start Of Line" })
map("i", "<C-e>", "<End>", { desc = "End Of Line" })

-- Select all text
map("n", "<C-e>", "gg<S-V>G", { desc = "Select All Text", silent = true, noremap = true })

-- Paste options
map("i", "<C-v>", '<C-r>"', { desc = "Paste on Insert Mode" })
map("v", "p", '"_dP', { desc = "Paste Without Overwriting" })

-- Delete and change without yanking
map({ "n", "x" }, "<A-d>", '"_d', { desc = "Delete Without Yanking" })
map({ "n", "x" }, "<A-c>", '"_c', { desc = "Change Without Yanking" })

-- Undo and Redo
map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "<C-u>", "<C-r>", { desc = "Undo" })

-- Close current buffer
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close Current Buffer" })

-- Close all but current
map("n", "<leader>bc", function()
  local current = vim.fn.bufnr("%")
  for _, buffer in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
    if buffer.bufnr ~= current then
      vim.cmd("bd " .. buffer.bufnr)
    end
  end
end, { desc = "Close All But Current Buffer" })

-- Buffer switch with numbers
for i = 1, 9 do
  map("n", "<leader>0" .. i, "<cmd>buffer " .. i .. "<cr>", { desc = "Buffer " .. i })
end
