return {
  -- Import default JSON settings from LazyVim
  { import = "lazyvim.plugins.extras.lang.json" },

  -- Plugin for accessing JSON schemas
  {
    "b0o/schemastore.nvim",
    lazy = true, -- Load lazily to avoid unnecessary startup overhead
  },

  -- Plugin for working with JSON and YAML data
  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" }, -- Lazy-load for JSON and YAML filetypes
    cmd = { "JqxList", "JqxQuery" }, -- Commands provided by the plugin
    keys = {
      { "<leader>cj", "<cmd>JqxList<cr>", desc = "Jqx List", ft = { "json", "yaml" } },
    },
  },

  -- JSON Language Server (jsonls) configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/schemastore.nvim" }, -- Ensure schemastore is installed first
    opts = {
      servers = {
        jsonls = {
          settings = {
            json = {
              schemas = function()
                return require("schemastore").json.schemas() -- Lazy-load schemastore
              end,
              validate = { enable = true }, -- Enable JSON validation
            },
          },
        },
      },
    },
  },
}
