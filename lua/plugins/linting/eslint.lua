return {
  -- ESLint Linting Setup
  { import = "lazyvim.plugins.extras.linting.eslint" },

  -- DevDocs integration for ESLint documentation (optional, for quick references)
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "eslint",
      },
    },
    config = function(_, opts)
      local devdocs = require "devdocs"
      -- Ensure ESLint documentation is available in DevDocs
      devdocs.setup {
        ensure_installed = opts.ensure_installed,
      }
    end,
  },

  -- LSP Configuration with Fallback Mechanism for ESLint
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local lspconfig = require "lspconfig"

      -- ESLint LSP setup
      lspconfig.eslint.setup {
        on_attach = function(client, bufnr)
          -- Set up keymaps and other options after attaching LSP
          require("lazyvim.plugins.lsp.keymaps").setup(client, bufnr)

          -- Enable ESLint linting for multiple filetypes
          lspconfig.eslint.setup {
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
            settings = {
              validate = "on", -- Automatically validate files
              codeActionOnSave = {
                enable = true, -- Enable fixing errors on save
              },
              codeActions = {
                organizeImports = true, -- Auto organize imports
              },
            },
            -- Fallback to default config if no `.eslintrc` is found
            init_options = {
              fallbackConfig = {
                extends = { "eslint:recommended" }, -- Fallback to recommended rules if no `.eslintrc` is found
                env = {
                  browser = true,
                  node = true,
                  es2020 = true,
                },
                parserOptions = {
                  ecmaVersion = 2020,
                  sourceType = "module",
                },
              },
            },
          }
        end,
      }
    end,
  },

  -- Fallback mechanism in case ESLint configuration is not found in the project
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "eslintd" },
    },
  },

  -- AutoFixing & Fallback Support with `eslint` & `eslint-ls`
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Ensure ESLint is included in the linters for JavaScript and framework files
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.javascript = opts.linters_by_ft.javascript or {}
      table.insert(opts.linters_by_ft.javascript, "eslint")
      opts.linters_by_ft.javascriptreact = opts.linters_by_ft.javascriptreact or {}
      table.insert(opts.linters_by_ft.javascriptreact, "eslint")
      opts.linters_by_ft.typescript = opts.linters_by_ft.typescript or {}
      table.insert(opts.linters_by_ft.typescript, "eslint")
      opts.linters_by_ft.typescriptreact = opts.linters_by_ft.typescriptreact or {}
      table.insert(opts.linters_by_ft.typescriptreact, "eslint")
      opts.linters_by_ft.vue = opts.linters_by_ft.vue or {}
      table.insert(opts.linters_by_ft.vue, "eslint")
      opts.linters_by_ft.svelte = opts.linters_by_ft.svelte or {}
      table.insert(opts.linters_by_ft.svelte, "eslint")
      return opts
    end,
  },
}
