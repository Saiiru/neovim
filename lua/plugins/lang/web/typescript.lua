local Lsp = require("utils.lsp")
local typescript_lsp = vim.g.typescript_lsp or "vtsls" -- ts_ls or vtsls

return {
  -- Importing TypeScript and JSON-related plugins
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "plugins.extras.lang.json-extended" },

  -- Mason Plugin for managing LSP servers
  { "williamboman/mason.nvim" },

  -- nvim-lspconfig for setting up LSP servers
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- TypeScript error translation plugin
      {
        "dmmulroy/ts-error-translator.nvim",
        ft = "javascript,typescript,typescriptreact,svelte",
      },
      -- TwoSlash queries for TypeScript debugging
      {
        "marilari88/twoslash-queries.nvim",
        ft = "javascript,typescript,typescriptreact,svelte",
        opts = {
          is_enabled = false, -- Use :TwoslashQueriesEnable to enable
          multi_line = true, -- to print types in multi line mode
          highlight = "Type", -- to set up a highlight group for the virtual text
        },
        keys = {
          { "<leader>dt", ":TwoslashQueriesEnable<cr>", desc = "Enable twoslash queries" },
          { "<leader>dd", ":TwoslashQueriesInspect<cr>", desc = "Inspect twoslash queries" },
        },
      },
    },
    opts = {
      servers = {
        ts_ls = {
          root_dir = require("lspconfig").util.root_pattern("package.json", "tsconfig.json"),
          single_file_support = false,
          handlers = {
            -- Error code formatting with better messages
            ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
              require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
              vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            end,
          },
          -- Keymaps for actions
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = { only = { "source.organizeImports" }, diagnostics = {} },
                })
              end,
              desc = "Organize Imports",
            },
            {
              "<leader>cR",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = { only = { "source.removeUnused" }, diagnostics = {} },
                })
              end,
              desc = "Remove Unused Imports",
            },
          },
          -- Inlay hints & code lens configurations
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literals", -- 'none' | 'literals' | 'all'
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              implementationsCodeLens = { enabled = true },
              referencesCodeLens = { enabled = true, showOnAllFunctions = true },
              format = { indentSize = vim.o.shiftwidth, convertTabsToSpaces = vim.o.expandtab, tabSize = vim.o.tabstop },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                includeInlayVariableTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
              },
              implementationsCodeLens = { enabled = true },
              referencesCodeLens = { enabled = true, showOnAllFunctions = true },
              format = { indentSize = vim.o.shiftwidth, convertTabsToSpaces = vim.o.expandtab, tabSize = vim.o.tabstop },
            },
            completions = { completeFunctionCalls = true },
          },
        },
        vtsls = {
          settings = {
            vtsls = { enableMoveToFileCodeAction = true, autoUseWorkspaceTsdk = true },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = { completeFunctionCalls = true },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
          keys = {
            {
              "gD",
              function()
                local params = vim.lsp.util.make_position_params()
                Lsp.execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              desc = "Goto Source Definition",
            },
            { "<leader>co", Lsp.action["source.organizeImports"], desc = "Organize Imports" },
            { "<leader>cM", Lsp.action["source.addMissingImports.ts"], desc = "Add Missing Imports" },
            { "<leader>cu", Lsp.action["source.removeUnused.ts"], desc = "Remove Unused Imports" },
            { "<leader>cD", Lsp.action["source.fixAll.ts"], desc = "Fix All Diagnostics" },
            {
              "<leader>cv",
              function()
                Lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              desc = "Select TypeScript Version",
            },
          },
        },
      },
      setup = {
        -- Handle Deno configurations
        vtsls = function(_, opts)
          if Lsp.deno_config_exist() then
            return true
          end
          if typescript_lsp == "ts_ls" then
            return true
          end
          Lsp.on_attach(function(client, bufnr)
            if client.name == "vtsls" then
              require("twoslash-queries").attach(client, bufnr)
            end
          end)
          Lsp.register_keymaps("vtsls", opts.keys, "TS")
        end,
        ts_ls = function(_, opts)
          if Lsp.deno_config_exist() then
            return true
          end
          if typescript_lsp == "vtsls" then
            return true
          end
          Lsp.on_attach(function(client, bufnr)
            if client.name == "ts_ls" then
              require("twoslash-queries").attach(client, bufnr)
            end
          end)
          Lsp.register_keymaps("ts_ls", opts.keys, "Typescript")
        end,
      },
    },
  },

  -- File Icons for TypeScript and other config files
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
    },
  },

  -- Neotest for testing support
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "marilari88/neotest-vitest" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      vim.list_extend(opts.adapters, { require("neotest-vitest") })
    end,
  },

  -- Mason configuration for better LSP management
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
              require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
              vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            end,
          },
          init_options = { preferences = { disableSuggestions = true } },
        },
      },
    },
  },

  -- Treesitter setup for better syntax highlighting and parsing
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "javascript", "jsdoc" },
    },
  },

  -- TypeScript checking tool (TSC) configuration
  {
    "dmmulroy/tsc.nvim",
    opts = {
      auto_start_watch_mode = false,
      use_trouble_qflist = true,
      flags = { watch = false },
    },
    keys = {
      { "<leader>ct", ft = { "typescript", "typescriptreact" }, "<cmd>TSC<cr>", desc = "Type Check" },
      { "<leader>xy", ft = { "typescript", "typescriptreact" }, "<cmd>TSCOpen<cr>", desc = "Type Check Quickfix" },
    },
    ft = { "typescript", "typescriptreact" },
    cmd = { "TSC", "TSCOpen", "TSCClose", "TSStop" },
  },

  -- TypeScript error translation plugin
  { "dmmulroy/ts-error-translator.nvim", opts = {} },

  -- Neotest configuration for Jest, Mocha, and Vitest
  {
    "nvim-neotest/neotest",
    dependencies = {
      { "marilari88/neotest-vitest" },
    },
    opts = {
      adapters = {
        require("neotest-vitest"),
      },
    },
  },
}
