return {
  "tris203/precognition.nvim",
  enabled = true, -- Ativa o plugin
  init = function()
    -- Mapeamento para ativar/desativar a Precognition
    vim.keymap.set("n", "<leader>op", function()
      require("precognition").toggle()
    end, { desc = "Precognition | Toggle Precognition", silent = true })

    -- Força a ativação do Precognition logo após a inicialização do Neovim
    vim.cmd([[autocmd VimEnter * lua require("precognition").toggle()]]) -- Ativa assim que o Neovim é carregado
  end,
  opts = {
    startVisible = true, -- Garante que comece visível
    showBlankVirtLine = true, -- Mostra uma linha em branco no início da linha
    highlightColor = { link = "Comment" }, -- Coloração para os destaques
    hints = {
      Caret = { text = "^", prio = 2 }, -- Indica o início da linha
      Dollar = { text = "$", prio = 1 }, -- Indica o final da linha
      MatchingPair = { text = "%", prio = 5 }, -- Indica os parênteses correspondentes
      Zero = { text = "0", prio = 1 }, -- Indica a posição 0
      w = { text = "w", prio = 10 }, -- Indica as palavras
      b = { text = "b", prio = 9 }, -- Indica palavras dentro de outras palavras
      e = { text = "e", prio = 8 }, -- Indica o final das palavras
      W = { text = "W", prio = 7 }, -- Indica palavras com letras maiúsculas
      B = { text = "B", prio = 6 }, -- Indica palavras separadas por espaços
      E = { text = "E", prio = 5 }, -- Indica palavras no final
    },
    gutterHints = {
      G = { text = "G", prio = 1 }, -- Indica o final da linha (G)
      gg = { text = "gg", prio = 1 }, -- Indica o início da linha (gg)
      PrevParagraph = { text = "{", prio = 1 }, -- Indica o parágrafo anterior
      NextParagraph = { text = "}", prio = 1 }, -- Indica o próximo parágrafo
    },
  },
}
