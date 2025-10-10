-- lua/plugins/coding/tailwind-tools.lua :: Ferramentas para desenvolvimento com TailwindCSS.

return {
    -- Mostra as cores do Tailwind no autocompletar.
    "roobert/tailwindcss-colorizer-cmp.nvim",
    {
        "NvChad/nvim-colorizer.lua",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {},
        config = function()
            local nvchadcolorizer = require("colorizer")
            local tailwindcolorizer = require("tailwindcss-colorizer-cmp")

            nvchadcolorizer.setup({
                user_default_options = {
                    tailwind = true,
                },
                filetypes = { "html", "css", "javascript", "typescript", "jsx", "tsx", "vue", "svelte" },
            })

            tailwindcolorizer.setup({
                color_square_width = 2,
            })

            vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
                callback = function()
                    vim.cmd("ColorizerAttachToBuffer")
                end,
            })

        end,
    },
}
