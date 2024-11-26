-- File: lua/config/lspconfig.lua
local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/nvim-cmp", -- Autocompletion
    "hrsh7th/cmp-nvim-lsp", -- LSP source for autocompletion
    "ray-x/lsp_signature.nvim", -- Function signature hints
    "folke/neodev.nvim", -- Lua development setup
    "nvim-lua/plenary.nvim", -- Utility functions
  },
}

function M.config()
  local lspconfig = require("lspconfig")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local lsp_signature = require("lsp_signature")
  local neodev = require("neodev")
  local icons = require "sairu.icons"
  -- Diagnostic icons
  -- local diagnostics_icons = {
  --   Error = " ",
  --   Warn = " ",
  --   Hint = " ",
  --   Info = " ",
  -- }

  -- Configure diagnostic signs
  -- for type, icon in pairs(diagnostics_icons) do
  --   local hl = "DiagnosticSign" .. type
  --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  -- end

  -- General diagnostic configuration
  vim.diagnostic.config({
   signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
        { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
      },
    },
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  -- Configure hover and signature help handlers
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  require("lspconfig.ui.windows").default_options.border = "rounded"

  -- Enhanced capabilities
  local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- Keymaps for LSP
  local function on_attach(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    lsp_signature.on_attach({
      bind = true,
      hint_prefix = "💡 ",
    }, bufnr)
  end

  -- Language-specific configurations
  local servers = {
    lua_ls = {
      settings = {
        Lua = {
					format = {
        enable = false,
      },
          runtime = {
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
						 special = {
								spec = "require",
						},
          },
          diagnostics = {
            globals = { "vim", "spec" },
          },
          workspace = {
            library = {
							[vim.fn.expand "$VIMRUNTIME/lua"] = true,
							[vim.fn.stdpath "config" .. "/lua"] = true,
					},
            checkThirdParty = false,
          },
          telemetry = { enable = false },
					 hint = {
        enable = false,
        arrayIndex = "Disable", -- "Enable" | "Auto" | "Disable"
        await = true,
        paramName = "Disable", -- "All" | "Literal" | "Disable"
        paramType = true,
        semicolon = "All", -- "All" | "SameLine" | "Disable"
        setType = false,
      },
        },
      },
    },
    ts_ls = {
      root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
      settings = {
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayFunctionLikeReturnTypeHints = true,
          },
        },
      },
    },
    cssls = {},
    tailwindcss = {},
    html = {},
    pyright = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "strict",
          },
        },
      },
    },
    intelephense = {},
    clangd = {},
    jsonls = {
		 settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
    },
  },
  setup = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
        end,
      },
    },
  },},
    yamlls = {
      settings = {
        yaml = {
          keyOrdering = false,
        },
      },
    },
  }

  -- Apply configurations for each server
  for server, config in pairs(servers) do
    if server == "lua_ls" then
      neodev.setup()
    end

    lspconfig[server].setup(vim.tbl_deep_extend("force", {
      capabilities = capabilities,
      on_attach = on_attach,
    }, config))
  end
end

return M

