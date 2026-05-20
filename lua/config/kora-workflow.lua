local map = vim.keymap.set

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wildmode = "list:longest,list:full"

vim.opt.wildignore:append({
  "node_modules",
  ".git",
  "*.class",
  "*.o",
  "*.obj",
  "*.pyc",
  "*.pyo",
  "*.swp",
  "*.swo",
  "target",
  "build",
  "dist",
})

vim.opt.suffixesadd:append({ ".java", ".py", ".js", ".ts", ".go", ".rs" })

map("n", "j", "(v:count == 0 ? 'gj' : 'j')", { expr = true, desc = "Down visual line" })
map("n", "k", "(v:count == 0 ? 'gk' : 'k')", { expr = true, desc = "Up visual line" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("n", "<leader>cn", ":cnext<CR>", { desc = "Quickfix next" })
map("n", "<leader>cp", ":cprev<CR>", { desc = "Quickfix previous" })
map("n", "<leader>co", ":copen<CR>", { desc = "Quickfix open" })
map("n", "<leader>cc", ":cclose<CR>", { desc = "Quickfix close" })

map("n", "<leader>sr", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Replace word under cursor" })

vim.api.nvim_create_autocmd("VimResized", {
  desc = "Keep splits balanced",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Clean terminal buffer UI",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})
