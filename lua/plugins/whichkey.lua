return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        wk.setup({
            icons = {
                rules = false,
                separator = "➜",
                group = "",
            },
            show_keys = false,
            show_help = false,
            layout = {
                align = "center",
            },
            win = {
                border = "double",
                title = false,
                padding = { 1, 1 },
                no_overlap = true,
            },
        })

    end,
}
