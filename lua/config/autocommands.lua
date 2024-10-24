-- Função para criação de diretório ao salvar arquivo, caso ele não exista
vim.cmd([[
  function! MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file !~# '\v^\w+\:\/'
      let dir = fnamemodify(a:file, ':h')
      if !isdirectory(dir)
        call mkdir(dir, 'p')
      endif
    endif
  endfunction

  augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * call MkNonExDir(expand('<afile>'), expand('<abuf>'))
  augroup END
]])

-- Variável global para armazenar a posição do cursor
local cursor_pos = {}

-- Grupo de autocmds otimizados
local yank_group = vim.api.nvim_create_augroup("YankPostGroup", { clear = true })

-- Callback para restaurar a posição do cursor após um yank
local function restore_cursor()
  if vim.v.event.operator == "y" then
    vim.fn.setpos(".", cursor_pos)
  end
end

-- Autocmd para salvar a posição do cursor e destacar o yank
vim.api.nvim_create_autocmd({ "VimEnter", "CursorMoved" }, {
  group = yank_group,
  pattern = "*",
  callback = function()
    cursor_pos = vim.fn.getpos(".")
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400, on_visual = true })
    restore_cursor()
  end,
  desc = "Highlight yanked text and restore cursor position",
})

