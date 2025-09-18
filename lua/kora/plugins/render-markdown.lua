return {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = true,
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  init = function()
    -- Define e garante grupos de highlight usados nas opts
    local fg = "#1F2335"
    local bg = { "#ff757f", "#4fd6be", "#7dcfff", "#ff9e64", "#7aa2f7", "#c0caf5" }
    local api = vim.api.nvim_set_hl
    for i = 1, 6 do
      api(0, ("Headline%dBg"):format(i), { fg = fg, bg = bg[i], bold = true })
      api(0, ("Headline%dFg"):format(i), { fg = bg[i], bold = true })
    end
  end,
  opts = {
    heading = {
      sign = false,
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
      backgrounds = { "Headline1Bg","Headline2Bg","Headline3Bg","Headline4Bg","Headline5Bg","Headline6Bg" },
      foregrounds = { "Headline1Fg","Headline2Fg","Headline3Fg","Headline4Fg","Headline5Fg","Headline6Fg" },
    },
    code = { sign = false, width = "block", right_pad = 1 },
    bullet = { enabled = true },
    checkbox = {
      enabled = true, position = "inline",
      unchecked = { icon = "   󰄱 ", highlight = "RenderMarkdownUnchecked" },
      checked   = { icon = "   󰱒 ", highlight = "RenderMarkdownChecked" },
    },
  },
}
