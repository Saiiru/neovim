return {
  "nat-418/boole.nvim",
  event = "BufEnter",
  opts = {
    mappings = {
      increment = "<C-a>", -- Incrementa o valor atual
      decrement = "<C-x>", -- Decrementa o valor atual
    },
    additions = {
      -- Ambientes
      { "production", "development", "test", "sandbox" },
      { "produção", "desenvolvimento", "teste", "sandbox" },
      -- Declarações
      { "let", "const" },
      { "var", "const" },
      { "deixe", "constante" },
      -- Temporal
      { "start", "end" },
      { "início", "fim" },
      { "antes", "depois" },
      { "antes", "após" },
      -- Operações de módulo
      { "import", "export" },
      { "importar", "exportar" },
      -- Direções
      { "left", "right" },
      { "esquerda", "direita" },
      -- Estados lógicos
      { "true", "false" },
      { "verdadeiro", "falso" },
      -- Verbo singular/plural
      { "is", "are" },
      { "é", "são" },
      -- Matemática e lógica
      { "plus", "minus" },
      { "mais", "menos" },
      { "decrementar", "decrementar" },
      { "dec", "inc" },

      -- Estilo ou abordagem
      { "smart", "truncate" },
      { "inteligente", "truncar" },
    },
  },
}
