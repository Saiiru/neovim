return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
    opts = {
        focus = true, -- Foca na janela do Trouble
    },
    cmd = "Trouble",
    keys = {
        { "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "[X] Workspace [W] Diagnostics" }, -- Abre o diagnóstico de workspace
        { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "[X] Document [D] Diagnostics" }, -- Abre o diagnóstico do documento
        { "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "[X] Quickfix [Q] List" }, -- Abre a lista quickfix
        { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "[X] Location [L] List" }, -- Abre a lista de localização
        { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "[X] Todo [T] List" }, -- Abre os todos no Trouble
    },
    config = function()
        require("trouble").setup({
            position = "bottom",  -- Posição da janela de problemas
            height = 10,          -- Altura da janela
            icons = true,         -- Ativa os ícones
            mode = "workspace",   -- Modo de visualização (pode ser "workspace", "document" ou "lsp")
            action_keys = {       -- Teclas de atalho para ações dentro do Trouble
                close = "<Esc>",  -- Fecha o Trouble
                cancel = "<Esc>", -- Cancela ações
                refresh = "r",    -- Atualiza a lista de problemas
                jump = { "<CR>", "<Tab>" }, -- Salta para o problema selecionado
                jump_close = { "<CR>", "<Tab>" }, -- Salta e fecha o Trouble
                toggle_mode = "m", -- Alterna entre modos
                previous = "k",     -- Problema anterior
                next = "j",         -- Próximo problema
                focus = "f",        -- Foca no problema
                edit = "e",         -- Edita o problema
                cancel = "<C-e>",   -- Cancela a edição
                change_mode = {     -- Alterna entre modos
                    "[x] = 'workspace'",
                    "[d] = 'document'",
                    "[l] = 'lsp'",
                },
            },
            auto_open = false,     -- Abre automaticamente o Trouble
            auto_close = false,    -- Fecha automaticamente o Trouble
            use_lsp_diagnostics = true, -- Usa os diagnósticos do LSP
        })
    end
}

