return {
    "stevearc/aerial.nvim",
    cmd = "AerialToggle", -- Comando para alternar Aerial
    config = function()
        require("aerial").setup({
            highlight_on_hover = true,  -- Destacar na passagem do mouse
            autojump = true,            -- Auto pular para a definição ao selecionar
            highlight_on_jump = false,  -- Não destacar após o salto
            manage_folds = true,        -- Gerenciar dobras automaticamente
            show_guides = true,         -- Mostrar guias de hierarquia
        })
    end,
}

