local group = vim.api.nvim_create_augroup("TinyPDE", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 120 })
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  pattern = { "*.ino", "*.pde" },
  callback = function()
    vim.bo.filetype = "cpp"
  end,
})
