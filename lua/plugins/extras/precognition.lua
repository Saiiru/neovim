return {
  "tris203/precognition.nvim",
  opts = {
    startVisible = true,
    showBlankVirtLine = true,
    highlightColor = { link = "Comment" },

    -- Movimentos principais de navegação e edição
    hints = {
      Caret = { text = "^", prio = 2 }, -- Linha atual
      Dollar = { text = "$", prio = 1 }, -- Fim da linha
      MatchingPair = { text = "%", prio = 5 }, -- Par correspondente
      Zero = { text = "0", prio = 1 }, -- Início da linha
      w = { text = "w", prio = 10 }, -- Próxima palavra
      b = { text = "b", prio = 9 }, -- Palavra anterior
      e = { text = "e", prio = 8 }, -- Fim da palavra
      W = { text = "W", prio = 7 }, -- Próxima palavra (considerando espaços)
      B = { text = "B", prio = 6 }, -- Palavra anterior (considerando espaços)
      E = { text = "E", prio = 5 }, -- Fim da palavra (considerando espaços)

      -- Movimentos de busca
      f = { text = "f", prio = 10 }, -- Próximo caractere (mesma linha)
      t = { text = "t", prio = 9 }, -- Antes do próximo caractere
      F = { text = "F", prio = 8 }, -- Caractere anterior
      T = { text = "T", prio = 7 }, -- Antes do caractere anterior

      -- Movimentos de frase e parágrafo
      LeftParenthesis = { text = "(", prio = 7 }, -- Início da frase
      RightParenthesis = { text = ")", prio = 7 }, -- Fim da frase
      LeftBrace = { text = "{", prio = 6 }, -- Início do parágrafo
      RightBrace = { text = "}", prio = 6 }, -- Fim do parágrafo

      -- Movimentos específicos para símbolos e sentenças
      aQuote = { text = 'a"', prio = 5 }, -- Selecionar frase com aspas
      iQuote = { text = 'i"', prio = 5 }, -- Selecionar dentro de aspas
      aParen = { text = "a(", prio = 5 }, -- Selecionar frase entre parênteses
      iParen = { text = "i(", prio = 5 }, -- Selecionar dentro de parênteses
      aBracket = { text = "a[", prio = 5 }, -- Selecionar frase entre colchetes
      iBracket = { text = "i[", prio = 5 }, -- Selecionar dentro de colchetes
    },

    -- Hints para o gutter
    gutterHints = {
      G = { text = "G", prio = 10 }, -- Fim do arquivo
      gg = { text = "gg", prio = 9 }, -- Início do arquivo
      PrevParagraph = { text = "{", prio = 8 }, -- Parágrafo anterior
      NextParagraph = { text = "}", prio = 8 }, -- Próximo parágrafo
    },

    -- Arquivos nos quais os hints estão desativados
    disabled_fts = {
      "startify",
      "help",
      "dashboard",
      "alpha",
      "TelescopePrompt",
    },
  },
}
