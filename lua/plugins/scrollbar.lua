local colors = require("util.colors") -- Importando o colorMap do seu arquivo de cores

return {
  "petertriho/nvim-scrollbar",
  opts = {
    show_in_active_only = true,
    handle = {
      text = " ",
      color = colors.sumiInk4,    -- Usando a cor do colorMap
      hide_if_all_visible = true, -- Esconde a alça se todas as linhas estiverem visíveis
    },
    marks = {
      Search = { text = { "-", "=" }, priority = 0, color = colors.sakuraPink }, -- Pode ser ajustado conforme preferir
      Error = { text = { "-", "=" }, priority = 1, color = colors.autumnRed },
      Warn = { text = { "-", "=" }, priority = 2, color = colors.winterYellow },
      Info = { text = { "-", "=" }, priority = 3, color = colors.springBlue },
      Hint = { text = { "-", "=" }, priority = 4, color = colors.springGreen },
      Misc = { text = { "-", "=" }, priority = 5, color = colors.waveBlue2 },
    },
    excluded_filetypes = {
      "",
      "prompt",
      "TelescopePrompt",
      "noice",
    },
    autocmd = {
      render = {
        "BufWinEnter",
        "TabEnter",
        "TermEnter",
        "WinEnter",
        "CmdwinLeave",
        "TextChanged",
        "VimResized",
        "WinScrolled",
      },
    },
    handlers = {
      diagnostic = false,
      search = false,
    },
  }
}
