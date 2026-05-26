-- Política única de diagnostics do Neovim.
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  signs = true,
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = "rounded",
    source = "if_many",
    focusable = true,
    header = "",
    prefix = "",
  },
})
