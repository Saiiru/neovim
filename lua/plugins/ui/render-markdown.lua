-- lua/plugins/ui/render-markdown.lua :: Renderiza markdown com ícones e highlights.

return {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    init = function()
        -- Cores para os highlights dos cabeçalhos.
        local color1_bg = "#ff757f"
        local color2_bg = "#4fd6be"
        local color3_bg = "#7dcfff"
        local color4_bg = "#ff9e64"
        local color5_bg = "#7aa2f7"
        local color6_bg = "#c0caf5"
        local color_fg = "#1F2335"
    end,
    opts = {
        heading = {
            sign = false,
            icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
            backgrounds = {
                "Headline1Bg",
                "Headline2Bg",
                "Headline3Bg",
                "Headline4Bg",
                "Headline5Bg",
                "Headline6Bg",
            },
            foregrounds = {
                "Headline1Fg",
                "Headline2Fg",
                "Headline3Fg",
                "Headline4Fg",
                "Headline5Fg",
                "Headline6Fg",
            },
        },
        code = {
            sign = false,
            width = "block",
            right_pad = 1,
        },
        bullet = {
            enabled = true,
        },
        checkbox = {
            enabled = true,
            position = "inline",
            unchecked = {
                icon = "   󰄱 ",
                highlight = "RenderMarkdownUnchecked",
                scope_highlight = nil,
            },
            checked = {
                icon = "   󰱒 ",
                highlight = "RenderMarkdownChecked",
                scope_highlight = nil,
            },
        },
    },
}
