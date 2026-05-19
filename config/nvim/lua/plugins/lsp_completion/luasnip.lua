return {
  "L3MON4D3/LuaSnip",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "v2.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    require("luasnip").setup {
      enable_autosnippets = true,
    }
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load {
      paths = { vim.fn.stdpath "config" .. "/lua/snippets" },
    }
  end,
}
