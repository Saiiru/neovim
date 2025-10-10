-- Neovim LSP (API nova) + integrações (glance, actions-preview, trouble, telescope, lsp-lens)
return {
  -- Code actions com preview (usa Telescope)
  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    opts = {
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = { width = 0.6, height = 0.7, prompt_position = "top", preview_cutoff = 20 },
      },
    },
  },

  -- Peek de refs/impl/typedef
  {
    "dnlhc/glance.nvim",
    cmd = { "Glance" },
    opts = {
      theme = { enable = true },
      hooks = {
        before_open = function(results, open, jump)
          if #results == 1 then jump(results[1]) else open(results) end
        end,
      },
    },
  },

  -- LSP Lens (contadores de refs, def, impl) – sem chamar .refresh()
  {
    "VidocqH/lsp-lens.nvim",
    event = "LspAttach",
    opts = {
      enable = true,
      include_declaration = false,
      sections = { definition = true, references = true, implements = true },
      ignore_filetype = { "markdown", "gitcommit" },
      targets = { immediate = false, filetype_subdirs = false },
    },
  },

  -- LSP core
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()
      local ok_utils, UL = pcall(require, "utils.lsp")
      local cmp_caps = require("cmp_nvim_lsp").default_capabilities()
      cmp_caps.textDocument.completion.completionItem.snippetSupport = true

      -- ===== Diagnostics (JetBrains style) =====
      local diagnostic_signs = {
        Error = "", Warn = "", Info = "", Hint = "󰌶"
      }
      for type, icon in pairs(diagnostic_signs) do
        local name = "DiagnosticSign" .. type
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config({
        virtual_text = { spacing = 2, prefix = "●" },
        underline = true,
        severity_sort = true,
        update_in_insert = false,
        float = { border = "rounded", source = "always" },
        signs = true,
      })

      -- ===== on_attach: keymaps + QoL =====
      local function on_attach(client, bufnr)
        if ok_utils and UL.on_attach_extra then pcall(UL.on_attach_extra, client, bufnr) end

        if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
          pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
        end

        local telescope = require("telescope.builtin")
        local has_actions, actions_preview = pcall(require, "actions-preview")
        local code_action = has_actions and actions_preview.code_actions or vim.lsp.buf.code_action

        local keymaps = {
          -- Navigation
          { "n", "gd", telescope.lsp_definitions,         "Goto Definitions" },
          { "n", "gD", vim.lsp.buf.declaration,           "Goto Declaration" },
          { "n", "gi", telescope.lsp_implementations,     "Goto Implementations" },
          { "n", "gt", telescope.lsp_type_definitions,    "Goto Type Definitions" },
          { "n", "gr", "<cmd>Glance references<CR>",      "Peek References" },
          { "n", "gI", "<cmd>Glance implementations<CR>", "Peek Implementations" },
          { "n", "gy", "<cmd>Glance type_definitions<CR>","Peek Type Defs" },
          -- Actions/rename/hover
          { { "n", "v" }, "<leader>ca", code_action,      "Code Action (preview)" },
          { "n", "<leader>rn", vim.lsp.buf.rename,        "Rename Symbol" },
          { "n", "K", vim.lsp.buf.hover,                  "Hover Docs" },
          { "i", "<C-h>", vim.lsp.buf.signature_help,     "Signature Help" },
          -- Diagnostics
          { "n", "]d", vim.diagnostic.goto_next,          "Next Diagnostic" },
          { "n", "[d", vim.diagnostic.goto_prev,          "Prev Diagnostic" },
          { "n", "<leader>dd", vim.diagnostic.open_float, "Line Diagnostics" },
          { "n", "<leader>dw", "<cmd>Trouble diagnostics toggle focus=false<CR>", "Diagnostics (workspace)" },
          { "n", "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", "Diagnostics (buffer)" },
          -- Toggle Inlay Hints
          { "n", "<leader>lx", function()
              if vim.lsp.inlay_hint then
                local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
              end
            end, "Toggle Inlay Hints" },
        }
        for _, km in ipairs(keymaps) do
          vim.keymap.set(km[1], km[2], km[3], { buffer = bufnr, silent = true, desc = km[4] })
        end
      end

      -- ===== Server Setup =====
      local function enable(server, cfg)
        cfg = cfg or {}
        cfg.capabilities = vim.tbl_extend("force", {}, cmp_caps, cfg.capabilities or {})
        cfg.on_attach = UL and UL.wrap_on_attach and UL.wrap_on_attach(on_attach) or on_attach
        vim.lsp.config(server, cfg)
        vim.lsp.enable(server)
      end

      -- Language servers
      enable("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim", "Snacks", "require" } },
            completion = { callSnippet = "Replace" },
          },
        },
      })

      enable("vtsls", {
        settings = {
          vtsls = {
            tsserver = { globalPlugins = {} },
            experimental = { maxInlayHintLength = 30 },
          },
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
            preferences = { importModuleSpecifier = "non-relative" },
          },
          javascript = { inlayHints = { includeInlayParameterNameHints = "all" } },
        },
      })

      for _, srv in ipairs({
        { "html", {} },
        { "cssls", { settings = { css = { validate = true }, scss = { validate = true }, less = { validate = true } } } },
        { "tailwindcss", { settings = { tailwindCSS = { experimental = { classRegex = { "tw`([^`]*)", 'tw="([^"]*)' } } } } } },
        { "emmet_language_server", { filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" } } },
        { "intelephense", {} },
        { "graphql", {} },
        { "dockerls", {} },
        { "docker_compose_language_service", {} },
        { "lemminx", {} },
        { "taplo", {} },
        { "marksman", {} },
        { "sqls", {} },
        { "ltex", { settings = { ltex = { language = "en-US" } } } },
      }) do
        enable(srv[1], srv[2])
      end

      local schemastore = require("schemastore")
      enable("jsonls", {
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
      })
      enable("yamlls", {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = schemastore.yaml.schemas(),
            keyOrdering = false,
          },
        },
      })

      enable("basedpyright", {
        settings = {
          python = { analysis = { typeCheckingMode = "standard", autoImportCompletions = true } },
        },
      })

      enable("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = { unusedparams = true },
          },
        },
      })

      enable("clangd", {
        cmd = { "clangd", "--background-index", "--fallback-style=LLVM", "--header-insertion=never", "--offset-encoding=utf-16" },
      })

      -- Java: see ftplugin/java.lua (jdtls.start_or_attach)
    end,
  },
}

