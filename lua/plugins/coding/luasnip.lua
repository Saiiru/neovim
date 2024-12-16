return {
  -- Import LazyVim extras for LuaSnip
  { import = "lazyvim.plugins.extras.coding.luasnip" },

  -- LuaSnip configuration
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        local luasnip = require "luasnip"
        local vscode_loader = require "luasnip.loaders.from_vscode"

        -- Load default VSCode snippets
        vscode_loader.lazy_load()

        -- Extend filetypes with custom documentation styles
        local filetype_extensions = {
          typescript = { "tsdoc", "next-ts" },
          javascript = { "jsdoc", "next" },
          lua = { "luadoc" },
          python = { "pydoc" },
          rust = { "rustdoc" },
          cs = { "csharpdoc" },
          java = { "javadoc" },
          c = { "cdoc" },
          cpp = { "cppdoc" },
          php = { "phpdoc" },
          kotlin = { "kdoc" },
          ruby = { "rdoc" },
          sh = { "shelldoc" },
        }

        for filetype, extensions in pairs(filetype_extensions) do
          luasnip.filetype_extend(filetype, extensions)
        end

        -- Load custom snippets from user-defined paths
        vscode_loader.lazy_load { paths = vim.fn.stdpath "config" .. "/snippets" }
      end,
    },
  },

  -- Optional snippet plugin (disabled)
  {
    "garymjr/nvim-snippets",
    enabled = false,
  },
}
