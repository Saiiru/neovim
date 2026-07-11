return {
  {
    "someone-stole-my-name/yaml-companion.nvim",
    ft = { "yaml" },
    lazy = true,
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
    },
    opts = {}
  },
  {
    "mfussenegger/nvim-ansible",
    ft = { "yaml.ansible" },
    event = "VeryLazy",
    lazy = true,
  },
  {
    -- Schemas
    "b0o/schemastore.nvim",
    lazy = true,
    enabled = true,
    ft = { "yaml", "json" },
  },
}
