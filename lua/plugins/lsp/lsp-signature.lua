return {
    "ray-x/lsp_signature.nvim",
    config = function()
        local lsp_signature = require("lsp_signature")

        lsp_signature.setup({
            bind = true,
            handler_opts = {
                border = "rounded", -- Define a borda da janela flutuante
            },
            toggle_key = "<M-x>", -- Tecla de atalho para ativar/desativar a assinatura
            floating_window = false, -- Desativa a janela flutuante
        })
    end
}

