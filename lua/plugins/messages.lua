-- Mapeia a tecla <leader>m para abrir a janela de mensagens
vim.keymap.set("n", "<leader>m", ":Messages<CR>", { desc = "Open Messages" })

return {
  "AckslD/messages.nvim",
  opts = {
    prepare_buffer = function(opts)
      -- Cria um novo buffer para exibir as mensagens
      local buf = vim.api.nvim_create_buf(false, true)

      -- Mapeia a tecla <Esc> para fechar a janela de mensagens
      vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = buf, desc = "Close Messages Window" })

      -- Abre a janela de mensagens com as opções fornecidas
      return vim.api.nvim_open_win(buf, true, opts)
    end,
  }
}

