-- ================================================================================================
-- TITLE : wilder.nvim
-- ABOUT : Autocomplete para command-line (`:`), busca (`/`) e busca reversa (`?`).
-- LINKS :
--   > github : https://github.com/gelguy/wilder.nvim
-- NOTE  :
--   Noice fica com mensagens/notificações. Wilder fica com a experiência de digitar comandos.
--   Não usa build Python nem filtros nativos. Menos fancy, mais confiável.
-- ================================================================================================

return {
  "gelguy/wilder.nvim",
  event = "CmdlineEnter",
  config = function()
    local ok, wilder = pcall(require, "wilder")
    if not ok then
      return
    end

    local p = vim.g.noctis_palette or require("config.theme.palette").colors
    vim.api.nvim_set_hl(0, "WilderMenu", { fg = p.fg, bg = p.bg_dark })
    vim.api.nvim_set_hl(0, "WilderAccent", { fg = p.blue, bg = p.bg_dark, bold = true })

    wilder.setup({
      modes = { ":", "/", "?" },
      next_key = "<Tab>",
      previous_key = "<S-Tab>",
      reject_key = "<C-e>",
      accept_key = "<Down>",
    })

    wilder.set_option(
      "pipeline",
      wilder.branch(
        wilder.cmdline_pipeline({
          -- Keep this native-module free. `lua_fzy_filter()` can require
          -- fzy-lua-native on some setups, which makes cmdline completion fail
          -- before the user has built optional native extensions.
          fuzzy = 0,
        }),
        wilder.search_pipeline()
      )
    )
    wilder.set_option(
      "renderer",
      wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        left = { " " },
        right = { " ", wilder.popupmenu_scrollbar({ thumb_char = " " }) },
        max_height = "35%",
        min_height = 0,
        border = "rounded",
        highlights = {
          default = "WilderMenu",
          accent = "WilderAccent",
        },
      })
    )
  end,
}
