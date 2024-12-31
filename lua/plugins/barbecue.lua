return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  event = "BufEnter",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    theme = nil, -- Deixe nulo para usar o tema padrão do Neovim
    show_navic = true, -- Se você deseja usar o 'nvim-navic' para mostrar o contexto de navegação
    symbols = {
      -- Usar separadores e ícones que evocam o estilo cyberpunk
      separator = "➤", -- Seta futurista
      modified = "", -- Ícone de arquivo modificado
      ellipsis = "…", -- Três pontos para indicar continuação
    },
    highlight = {
      -- Definindo cores neon no esquema Cyberpunk
      background = { bg = "#121212", fg = "#999999" }, -- Fundo escuro com texto sutil
      context = { fg = "#8be9fd" }, -- Azul neon para o texto de contexto
      context_file = { fg = "#ff79c6" }, -- Rosa neon para arquivos
      context_module = { fg = "#50fa7b" }, -- Verde neon para módulos
      context_namespace = { fg = "#f1fa8c" }, -- Amarelo neon para namespaces
      context_package = { fg = "#ffb86c" }, -- Laranja neon para pacotes
      context_class = { fg = "#8be9fd" }, -- Azul neon para classes
      context_method = { fg = "#ff79c6" }, -- Rosa neon para métodos
      context_property = { fg = "#50fa7b" }, -- Verde neon para propriedades
      context_field = { fg = "#f1fa8c" }, -- Amarelo neon para campos
      context_constructor = { fg = "#bd93f9" }, -- Roxo neon para construtores
      context_enum = { fg = "#ff5555" }, -- Vermelho neon para enums
      context_interface = { fg = "#50fa7b" }, -- Verde neon para interfaces
      context_function = { fg = "#8be9fd" }, -- Azul neon para funções
      context_variable = { fg = "#ff79c6" }, -- Rosa neon para variáveis
      context_constant = { fg = "#bd93f9" }, -- Roxo neon para constantes
      context_string = { fg = "#50fa7b" }, -- Verde neon para strings
      context_number = { fg = "#f1fa8c" }, -- Amarelo neon para números
      context_boolean = { fg = "#ff79c6" }, -- Rosa neon para booleanos
      context_array = { fg = "#8be9fd" }, -- Azul neon para arrays
      context_object = { fg = "#ff5555" }, -- Vermelho neon para objetos
    },
  },
  config = function(_, opts)
    require("barbecue").setup(opts)
  end,
}
