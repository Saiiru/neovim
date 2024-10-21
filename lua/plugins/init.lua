return {
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    config = function()
        require("tailwindcss-colorizer-cmp").setup({
            color_square_width = 3,           -- Largura do quadrado de cor
            color_square_height = 1,          -- Altura do quadrado de cor
            enable_tailwind = true,           -- Habilita o suporte a classes Tailwind CSS
            color_background = true,           -- Exibe a cor de fundo
            color_text = true,                 -- Exibe a cor do texto
            color_text_background = false,     -- Define se o fundo do texto deve ser colorido
            color_square_integration = true,   -- Integra a cor no item da lista
            auto_update = true,                -- Atualiza automaticamente as cores
        })
    end,
},
{
    "b0o/schemastore.nvim",

}
}
