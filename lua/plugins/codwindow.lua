return {
  "gorbit99/codewindow.nvim",
  config = function()
    local codewindow = require("codewindow")
    codewindow.setup({
      auto_enable = false, -- Não ativa automaticamente o minimapa
      active_in_terminals = false, -- Não ativa para buffers de terminal
      exclude_filetypes = { "help", "oil", "octo" }, -- Exclui tipos de arquivo do minimapa
      max_minimap_height = nil, -- Sem limite de altura do minimapa
      max_lines = nil, -- Sem limite de linhas para o minimapa
      minimap_width = 20, -- Largura do minimapa
      use_lsp = true, -- Usa LSP para mostrar erros e avisos
      use_treesitter = true, -- Usa Treesitter para destacar a sintaxe
      use_git = true, -- Mostra mudanças do Git
      width_multiplier = 4, -- Cada ponto representa 4 caracteres
      z_index = 1, -- Z-index da janela flutuante
      show_cursor = false, -- Não mostra o cursor no minimapa
      window_border = "none", -- Sem borda na janela flutuante
      relative = "win", -- O minimapa será posicionado relativo à janela atual
      events = { "TextChanged", "InsertLeave", "DiagnosticChanged", "FileWritePost" }, -- Eventos que atualizam o minimapa
    })
    codewindow.apply_default_keybinds()

    -- Definindo um atalho para alternar a exibição do minimapa
    vim.api.nvim_set_keymap(
      "n",
      "<leader>m",
      "<cmd>CodeWindowToggle<cr>",
      { noremap = true, silent = true, desc = "Alternar Minimap" }
    )
  end,
}
