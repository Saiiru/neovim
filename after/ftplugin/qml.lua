vim.bo.commentstring = "// %s"
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2

vim.opt_local.conceallevel = 0
vim.opt_local.colorcolumn = "100"

vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
})
