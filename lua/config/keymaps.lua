-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local o = vim.opt

-- Search current word with Brave and notify user
local searching_brave = function()
  vim.fn.system({ "xdg-open", "https://google.com/search?q=" .. vim.fn.expand("<cword>") })
  vim.notify("Searching for: " .. vim.fn.expand("<cword>"), vim.log.levels.INFO)
end
map("n", "<leader>?", searching_brave, { noremap = true, silent = true, desc = "Search Current Word on Brave Search" })

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
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })

-- Search Navigation
map("n", "gn", "gN", { desc = "Search Next" })
map("n", "gN", "gn", { desc = "Search Previous" })

-- Close windows
map("n", "<leader>q", "<cmd>q!<cr>", { desc = "Quit" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit All" })
map("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save All" })
map("n", "<leader>c", "<cmd>close<cr>", { desc = "Close" })
map("n", "<leader>x", "<cmd>q<cr>", { desc = "Quit" })

-- Insert a comment
map("n", "/*", "i/*", { desc = "Insert Comment" })

-- Jump to current file
map("n", "<leader>tf", "<cmd>e %<cr>", { desc = "Current File" })
