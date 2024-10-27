-- Basic Keymaps
-- See `:help vim.keymap.set()`

-- Silent keymap options for more concise configuration
local opts = { silent = true, noremap = true }
local keymap = vim.keymap.set

-- Splits and windows navigation
keymap("n", "ss", ":split<Return>", { desc = "[S]plit Horizontal", silent = true })
keymap("n", "sv", ":vsplit<Return>", { desc = "[S]plit Vertical", silent = true })
keymap("n", "sh", "<C-w>h", { desc = "[S]witch to left split", silent = true })
keymap("n", "sj", "<C-w>j", { desc = "[S]witch to bottom split", silent = true })
keymap("n", "sk", "<C-w>k", { desc = "[S]witch to top split", silent = true })
keymap("n", "sl", "<C-w>l", { desc = "[S]witch to right split", silent = true })
keymap("n", "sq", "<C-w>q", { desc = "[S]plit [Q]uit", silent = true })

-- Tab navigation
keymap("n", "<leader>tn", ":tabnext<CR>", { desc = "[T]ab [N]ext", silent = true })
keymap("n", "<leader>tp", ":tabprev<CR>", { desc = "[T]ab [P]revious", silent = true })
keymap("n", "<leader>tc", vim.cmd.tabclose, { desc = "[T]ab [C]lose", silent = true })
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "[T]ab [O]pen New" })     -- Abre uma nova aba
-- Miscellaneous keymaps
keymap("n", "<C-t>", "<C-^>", { desc = "Switch between two last buffers", silent = true })
keymap("n", "<leader>vv", ":e $MYVIMRC<CR>", { desc = "[V]im [V]RC: Edit Vim config", silent = true })
keymap("n", "<leader>a", "ggVG", { desc = "[A]ll: Select entire file", silent = true })
keymap("n", "*", ":keepjumps normal! mi*`i<CR>", { desc = "Search word under cursor without jumping", silent = true })
keymap("v", "<leader>y", '"+y', { desc = "[Y]ank to clipboard", silent = true })
keymap("n", "H", "^", { desc = "Move to the start of the line", silent = true })
keymap("i", "<C-h>", "<Left>", { desc = "Move cursor left in insert mode", silent = true })
keymap("i", "<C-l>", "<Right>", { desc = "Move cursor right in insert mode", silent = true })
keymap("x", "<leader>p", '"_dP', { desc = "Paste without replacing register", silent = true })

-- Buffer navigation
keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Cycle to the next buffer", silent = true })
keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Cycle to the previous buffer", silent = true })
keymap("n", "gn", ":bn<CR>", { desc = "Go to next buffer", silent = true })
keymap("n", "gp", ":bp<CR>", { desc = "Go to previous buffer", silent = true })
keymap("n", "<S-q>", ":lua require('mini.bufremove').delete(0, false)<CR>",
  { desc = "Close current buffer", silent = true })

-- LSP-related mappings
keymap("n", "gd", vim.lsp.buf.definition, { desc = "[G]o to [D]efinition", silent = true })
keymap("n", "gr", function() vim.lsp.buf.references({ includeDeclaration = false }) end,
  { desc = "[G]o to [R]eferences", silent = true })
keymap("n", "gy", vim.lsp.buf.type_definition, { desc = "[G]o to Type Definition", silent = true })
keymap("n", "<C-Space>", vim.lsp.buf.code_action, { desc = "Trigger code action", silent = true })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction", silent = true })
keymap("v", "<leader>ca", ":'<,'>lua vim.lsp.buf.code_action()<CR>", { desc = "[C]ode [A]ction (Visual)", silent = true })
keymap("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[C]ode [R]ename", silent = true })
keymap("n", "<leader>cf", "<cmd>lua require('config.lsp.functions').format()<CR>",
  { desc = "[C]ode [F]ormat", silent = true })
keymap("n", "<leader>cl", "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>",
  { desc = "[C]ode Diagnostics [L]ine", silent = true })
keymap("n", "L", vim.lsp.buf.signature_help, { desc = "Show function signature help", silent = true })
keymap("n", "]g", vim.diagnostic.goto_next, { desc = "Go to next diagnostic", silent = true })

-- Search in visual mode
vim.cmd([[
  function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
  endfunction
  vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
]])

-- Open links (macOS and Linux support)
if vim.fn.has('macunix') == 1 then
  keymap("n", "gx", "<cmd>silent execute '!open ' . shellescape('<cWORD>')<CR>",
    { desc = "Open link in macOS", silent = true })
else
  keymap("n", "gx", "<cmd>silent execute '!xdg-open ' . shellescape('<cWORD>')<CR>",
    { desc = "Open link in Linux", silent = true })
end

-- Additional utility mappings
keymap("n", "<leader>vpp", ":e ~/.dotfiles/nvim/.config/nvim/init.lua<CR>",
  { desc = "[V]im [P]acker [P]rofile", silent = true })
keymap("n", "<leader>mr", ":CellularAutomaton make_it_rain<CR>", { desc = "[M]ake it [R]ain" })
keymap("n", "<leader><leader>", function() vim.cmd("so") end, { desc = "Reload config" })
keymap("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "[Z]ig: Restart LSP" })

-- Diagnostic list
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list", silent = true })

-- Terminal mode exit
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", silent = true })

-- Buffer removing with MiniBufRemove plugin
keymap("n", "<S-q>", ":lua require('mini.bufremove').delete(0, false)<CR>",
  { desc = "Close buffer with mini.bufremove", silent = true })
