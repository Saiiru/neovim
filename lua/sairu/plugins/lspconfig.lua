-- lua/sairu/plugins/lspconfig.lua
return {{
 {
        "mfussenegger/nvim-jdtls",
        dependencies = {
            "mfussenegger/nvim-dap",
            "ray-x/lsp_signature.nvim"
        },
    }},
      {
        "ray-x/lsp_signature.nvim",
        config = function()
            require "lsp_signature".setup()
        end
    },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
            {
  "b0o/schemastore.nvim",
  lazy = true,
},
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local mason_tool_installer = require("mason-tool-installer")

      -- Capacidades aprimoradas para LSP
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Inicializar Mason e ferramentas
      mason.setup()
      mason_lspconfig.setup {
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "bashls",
          "gopls",
          "html",
          "cssls",
          "jsonls",
          "marksman",
          "yamlls",
          "jdtls"
        },
        automatic_installation = true,
      }

      mason_tool_installer.setup {
        ensure_installed = {
          "stylua",
          "prettier",
          "eslint_d",
          "shellcheck",
          "golangci-lint",
          -- adicionar mais conforme necessário
        },
      }

      -- Configurações específicas por servidor
      local servers = {
        lua_ls = {
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
                checkThirdParty = false,
              },
              telemetry = { enable = false },
              hint = { enable = true },
            },
          },
        },

        ts_ls = {
          capabilities = capabilities,
          root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
          single_file_support = false,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        bashls = {
          capabilities = capabilities,
          filetypes = { "sh", "bash" },
        },

        gopls = {
          capabilities = capabilities,
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },

        html = {
          capabilities = capabilities,
          filetypes = { "html", "handlebars", "htmldjango" },
        },

        cssls = {
          capabilities = capabilities,
          settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
          },
        },

        jsonls = {
          capabilities = capabilities,
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        marksman = {
          capabilities = capabilities,
        },

        yamlls = {
          capabilities = capabilities,
          settings = {
            yaml = {
              schemaStore = { enable = false },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
      }

      -- Inicializar todos os servidores com suas configs
      for server, config in pairs(servers) do
        lspconfig[server].setup(config)
      end
    end,
  },
}

