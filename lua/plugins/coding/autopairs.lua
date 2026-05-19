-- ================================================================================================
-- TITLE : nvim-autopairs
-- ABOUT : Fecha pares automaticamente sem brigar com LaTeX/Rust.
-- HOW   : digite `(`, `"`, `{` normalmente; o plugin cria o par e respeita filetypes.
-- ================================================================================================

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    disable_filetype = { "TelescopePrompt", "snacks_picker_input", "vim" },
  },
  config = function(_, opts)
    local autopairs = require("nvim-autopairs")
    local rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    autopairs.setup(opts)

    -- LaTeX: `$...$` é útil, mas não deve quebrar linha automaticamente.
    autopairs.add_rules({
      rule("$", "$", { "tex", "latex" }):with_cr(cond.none()),
    })

    local backtick = autopairs.get_rules("`")[1]
    if backtick then
      backtick.not_filetypes = { "tex", "latex" }
    end

    local single_quote = autopairs.get_rules("'")[1]
    if single_quote then
      single_quote.not_filetypes = { "tex", "latex", "rust" }
    end
  end,
}
