local prettier = { "prettierd", "prettier", stop_after_first = true }
local biome = { "biome", stop_after_first = true } -- Biome setup

return {
  -- Prettier plugin configuration
  { import = "lazyvim.plugins.extras.formatting.prettier" },

  -- Mason plugin for ensuring Prettier and other formatters are installed
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "prettierd", -- Ensure prettierd is installed
        "biome", -- Ensure biome is installed (if you choose to use Biome)
      },
    },
  },

  -- Conform plugin for integrating multiple formatters
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      -- Formatters by file type
      formatters_by_ft = {
        -- JavaScript/TypeScript & React
        ["javascript"] = prettier,
        ["javascriptreact"] = prettier,
        ["typescript"] = prettier,
        ["typescriptreact"] = prettier,

        -- Vue, CSS, SCSS, LESS, HTML
        ["vue"] = prettier,
        ["css"] = prettier,
        ["scss"] = prettier,
        ["less"] = prettier,
        ["html"] = prettier,

        -- JSON, YAML, Markdown
        ["json"] = prettier,
        ["jsonc"] = prettier,
        ["yaml"] = prettier,
        ["markdown"] = prettier,
        ["markdown.mdx"] = prettier,

        -- GraphQL, Handlebars
        ["graphql"] = prettier,
        ["handlebars"] = prettier,

        -- Optional: Use Biome if available
        ["javascript"] = biome,
        ["typescript"] = biome,
        ["json"] = biome,
      },
    },
  },

  -- Devdocs plugin for easy documentation access (optional)
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "prettier", -- Ensure documentation for prettier is available
        "biome", -- Ensure documentation for Biome is available
      },
    },
  },
}
