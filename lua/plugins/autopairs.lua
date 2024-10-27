return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    -- Importa o módulo principal do nvim-autopairs
    local autopairs = require("nvim-autopairs")
    autopairs.setup({
      check_ts = true,                      -- Habilita Treesitter para melhorar a inserção de pares
      enable_check_bracket_line = true,     -- Evita pares se já houver um fechamento na linha
      ts_config = {
        lua = { "string" },                 -- Evita pares em strings no Lua
        javascript = { "template_string" }, -- Evita pares em template strings do JavaScript
        java = false,                       -- Desabilita verificação do Treesitter para Java
      },
    })

    -- Importa a funcionalidade de completions do nvim-autopairs e configura integração com cmp
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")

    -- Define o evento para integração entre nvim-autopairs e cmp, assegurando pares em confirmações de autocompletar
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
