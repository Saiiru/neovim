-- lua/plugins/coding/treesitter.lua :: Configuração do Treesitter para syntax highlighting e mais.

return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            local treesitter = require("nvim-treesitter.configs")

            treesitter.setup({ 
                -- Ativa o syntax highlighting.
                highlight = {
                    enable = true,
                },
                -- Ativa a indentação baseada no Treesitter.
                indent = { enable = true },

                -- Lista de parsers a serem instalados.
                ensure_installed = {
                    "json",
                    "javascript",
                    "typescript",
                    "tsx",
                    "go",
                    "yaml",
                    "html",
                    "css",
                    "python",
                    "http",
                    "prisma",
                    "markdown",
                    "markdown_inline",
                    "svelte",
                    "graphql",
                    "bash",
                    "lua",
                    "vim",
                    "dockerfile",
                    "gitignore",
                    "query",
                    "vimdoc",
                    "c",
                    "java",
                    "rust",
                    "ron",
                },
                -- Seleção incremental de nós da árvore de sintaxe.
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                    },
                },
                additional_vim_regex_highlighting = false,
            })
        end,
    },
    -- Auto-fechamento de tags HTML/XML.
    {
        "windwp/nvim-ts-autotag",
        enabled = true,
        ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false,
                },
                per_filetype = {
                    ["html"] = {
                        enable_close = true,
                    },
                    ["typescriptreact"] = {
                        enable_close = true,
                    },
                },
            })
        end,
    },
}
