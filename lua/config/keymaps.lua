-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Set leader key
vim.g.mapleader = " "

-- Local options for key mappings
local opts = { silent = true, noremap = true }
local keymap = vim.keymap.set

-- ------------------------------
-- Splits and Window Navigation
-- ------------------------------
keymap("n", "ss", ":split<CR>", { desc = "[S]plit Horizontal" })
keymap("n", "sv", ":vsplit<CR>", { desc = "[S]plit Vertical" })

-- Navigate splits
keymap("n", "sh", "<C-w>h", { desc = "[S]witch left split" })
keymap("n", "sj", "<C-w>j", { desc = "[S]witch bottom split" })
keymap("n", "sk", "<C-w>k", { desc = "[S]witch top split" })
keymap("n", "sl", "<C-w>l", { desc = "[S]witch right split" })
keymap("n", "sq", "<C-w>q", { desc = "[S]plit [Q]uit" })

-- Better window navigation (overwriting with tmux navigator)
keymap("n", "<C-h>", ":<C-U>TmuxNavigateLeft<cr>", opts)
keymap("n", "<C-l>", ":<C-U>TmuxNavigateRight<cr>", opts)
keymap("n", "<C-j>", ":<C-U>TmuxNavigateDown<cr>", opts)
keymap("n", "<C-k>", ":<C-U>TmuxNavigateUp<cr>", opts)
keymap("n", "<C-\\>", ":<C-U>TmuxNavigatePrevious<cr>", opts)

-- Resize window using <ctrl> arrow keys
keymap("n", "<M-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<M-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap("n", "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- ------------------------------
-- Terminal and Lazydocker
-- ------------------------------
local Terminal = require("toggleterm.terminal").Terminal
local lazydocker = Terminal:new({
  cmd = "lazydocker",
  hidden = true,
  close_on_exit = true,
  direction = "float",
  float_opts = { border = "double" },
})

keymap("n", "<leader>dd", function()
  lazydocker:toggle()
end, { desc = "Lazydocker", noremap = true, silent = true })
keymap("n", "<leader>dt", function()
  require("lazyvim.util").float_term({ "lazydocker" }, { cwd = require("lazyvim.util").get_root() })
end, { desc = "Lazydocker Terminal" })

-- ------------------------------
-- Miscellaneous
-- ------------------------------
keymap("i", "jj", "<esc>", opts) -- Exit insert mode

-- Navigation and Manipulation
keymap("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
keymap("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Execute tmux command" })

-- Increment and decrement
keymap("n", "+", "<C-a>")
keymap("n", "-", "<C-x>")

-- Delete a word backwards
keymap("n", "dw", 'vb"_d')

-- Select all
keymap("n", "<C-a>", "gg<S-v>G")

-- Miscellaneous actions
keymap("n", "<C-t>", "<C-^>", { desc = "Toggle between last two buffers" })
keymap("n", "<leader>vv", ":e $MYVIMRC<CR>", { desc = "[V]im [V]RC: Edit config" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open [Q]uickfix diagnostics list" })
keymap("n", "<leader><leader>", function()
  vim.cmd("so")
end, { desc = "Reload config" })

-- ------------------------------
-- Navigation and Buffer Management
-- ------------------------------
keymap("n", "<leader>tn", ":tabnext<CR>", { desc = "[T]ab [N]ext" })
keymap("n", "<leader>tp", ":tabprev<CR>", { desc = "[T]ab [P]revious" })
keymap("n", "<leader>tc", ":tabclose<CR>", { desc = "[T]ab [C]lose" })
keymap("n", "<leader>to", ":tabnew<CR>", { desc = "[T]ab [O]pen New" })

-- Buffer navigation
keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
keymap("n", "gn", ":bn<CR>", { desc = "Next buffer" })
keymap("n", "gp", ":bp<CR>", { desc = "Previous buffer" })

-- ------------------------------
-- Function Mappings
-- ------------------------------
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
keymap("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "[Z]ig: Restart LSP" })

-- Open links in system browser
local open_cmd = vim.fn.has("macunix") == 1 and "open" or "xdg-open"
keymap("n", "gx", "<cmd>silent execute '! " .. open_cmd .. " ' . shellescape('<cWORD>')<CR>", { desc = "Open link" })

-- Add global mappings as needed
keymap("n", "<leader>sx", require("telescope.builtin").resume, { noremap = true, silent = true, desc = "Resume" })

-- Increment/decrement mapping
keymap("n", "<C-w><left>", "<C-w><")
keymap("n", "<C-w><right>", "<C-w>>")
keymap("n", "<C-w><up>", "<C-w>+")
keymap("n", "<C-w><down>", "<C-w>-")

-- Worktree management (if applicable)
keymap(
  "n",
  "<leader>gG",
  ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
  { desc = "Create Worktree" }
)

-- Set search function for visual selection
vim.cmd([[
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
]])

-- CMake
keymap("", "<leader>cg", ":CMakeGenerate<cr>", {})
keymap("", "<leader>cb", ":CMakeBuild<cr>", {})
keymap("", "<leader>cq", ":CMakeClose<cr>", {})
keymap("", "<leader>cL", ":CMakeClean<cr>", {})
