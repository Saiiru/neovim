-- lua/plugins/lsp/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    "aznhe21/actions-preview.nvim",
    "dnlhc/glance.nvim",
    "VidocqH/lsp-lens.nvim",
    "j-hui/fidget.nvim",
    "ray-x/lsp_signature.nvim",
    "folke/trouble.nvim",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local caps = require("cmp_nvim_lsp").default_capabilities()

    -- UI / extras
    require("fidget").setup({})
    require("actions-preview").setup({})
    require("glance").setup({})
    require("trouble").setup({})
    require("lsp_signature").setup({
      bind = true,
      handler_opts = { border = "rounded" },
      hint_enable = true,
    })
    require("lsp-lens").setup({
      enable = true,
      include_declaration = true,
      sections = {
        definition = true,
        references = true,
        implements = true,
        typedefs = true,
      },
      ignore_filetype = { "markdown", "gitcommit" },
    })

    -- sinais / diagnósticos
    local signs = {
      { name = "DiagnosticSignError", text = "" },
      { name = "DiagnosticSignWarn",  text = "" },
      { name = "DiagnosticSignHint",  text = "󰠠" },
      { name = "DiagnosticSignInfo",  text = "" },
    }
    for _, s in ipairs(signs) do
      vim.fn.sign_define(s.name, { text = s.text, texthl = s.name, numhl = "" })
    end
    vim.diagnostic.config({
      virtual_text = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = { border = "rounded", source = "always" },
    })

    -- Keymaps por buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
        end

        -- Navegação (Glance)
        map("n", "gr", "<cmd>Glance references<cr>",        "Goto References")
        map("n", "gd", "<cmd>Glance definitions<cr>",       "Goto Definitions")
        map("n", "gI", "<cmd>Glance implementations<cr>",   "Goto Implementations")
        map("n", "gy", "<cmd>Glance type_definitions<cr>",  "Goto Type Definitions")
        map("n", "gD", vim.lsp.buf.declaration,             "Goto Declaration")

        -- Telescope fallback (mantém teu hábito)
        map("n", "gR", "<cmd>Telescope lsp_references<CR>", "LSP References (Telescope)")

        -- Ações / Hover / Rename / Symbols
        map({ "n","v" }, "<leader>ca", function() require("actions-preview").code_actions() end, "Code Action (Preview)")
        map("n", "K",          vim.lsp.buf.hover,                "Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename,               "Rename")
        map("n", "<leader>cs", vim.lsp.buf.document_symbol,      "Document Symbols")
        map("n", "<leader>cS", vim.lsp.buf.workspace_symbol,     "Workspace Symbols")

        -- Diags / Trouble
        map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Buffer Diagnostics")
        map("n", "<leader>d", vim.diagnostic.open_float,               "Line Diagnostics")
        map("n", "]d",        vim.diagnostic.goto_next,                "Next Diagnostic")
        map("n", "[d",        vim.diagnostic.goto_prev,                "Prev Diagnostic")
        map("n", "<leader>cq","<cmd>Trouble diagnostics toggle<cr>",   "Toggle Trouble")

        -- Signature help (Insert)
        map("i", "<C-h>", function() vim.lsp.buf.signature_help() end, "Signature Help")

        -- LSP Lens toggles
        map("n", "<leader>lL", function() require("lsp-lens").toggle() end,  "LSP Lens Toggle")
        map("n", "<leader>lR", function() require("lsp-lens").refresh() end, "LSP Lens Refresh")

        -- Restart
        map("n", "<leader>rs", ":LspRestart<CR>", "Restart LSP")
      end,
    })

    -- Servidores
    local servers = {
      -- Lua
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion  = { callSnippet = "Replace" },
            workspace   = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      },

      -- Web
      vtsls = {}, -- (se preferir tsserver, troque por tsserver = {})
      eslint = {},
      html = {},
      cssls = {
        settings = {
          css  = { validate = true, lint = { unknownAtRules = "ignore" } },
          scss = { validate = true, lint = { unknownAtRules = "ignore" } },
          less = { validate = true, lint = { unknownAtRules = "ignore" } },
        },
      },
      tailwindcss = {},
      jsonls = {},
      yamlls = {},
      emmet_ls = {
        filetypes = { "html","typescriptreact","javascriptreact","css","sass","scss","less","svelte" },
      },
      graphql = {},

      -- DevOps
      dockerls = {},
      docker_compose_language_service = {},
      bashls = {},
      lemminx = {},  -- XML
      taplo = {},    -- TOML

      -- Backends
      gopls = {
        settings = {
          gopls = { analyses = { unusedparams = true }, staticcheck = true, gofumpt = true },
        },
      },
      clangd = {},
      intelephense = {},
      basedpyright = {}, -- (ou pyright)
      sqls = {},
      marksman = {}, -- Markdown
      -- jdtls -> subir via ftplugin/java.lua (nvim-jdtls)
    }

    for name, cfg in pairs(servers) do
      cfg.capabilities = caps
      lspconfig[name].setup(cfg)
    end
  end,
}

