return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "aznhe21/actions-preview.nvim",
      "dnlhc/glance.nvim",
      "smjonas/inc-rename.nvim",
      "Wansmer/symbol-usage.nvim",
      "artemave/workspace-diagnostics.nvim",
      "folke/which-key.nvim",
      { "hrsh7th/cmp-nvim-lsp", enabled = true },
    },
    config = function()
      local lsp = require("lspconfig")
      local shared = require("langs.shared")

      shared.setup_diagnostics()
      require("symbol-usage").setup({
        vt_position = "end_of_line",
        text_format = function(s)
          if s.references then local n=s.references; return (" 󰌹 %s %s"):format(n, n==1 and "ref" or "refs") end
          return ""
        end,
      })
      require("workspace-diagnostics").setup()

      local caps, on_attach = require("langs.shared").capabilities(), require("langs.shared").on_attach
      local nvim_010 = vim.fn.has("nvim-0.10")==1

      local servers = {
        lua_ls = { settings = { Lua = {
          completion = { callSnippet = "Replace" },
          diagnostics = { globals = { "vim" } },
          hint = { enable = nvim_010, setType = nvim_010 },
        }}},
        jsonls = {}, yamlls = {}, taplo = {}, bashls = {}, marksman = {}, lemminx = {},
        html = {}, cssls = {}, tailwindcss = {},
        emmet_ls = { filetypes = { "html","css","scss","sass","javascript","javascriptreact","typescriptreact","svelte","vue","astro" } },
        vtsls = { settings = {
          typescript = {
            tsserver = { maxTsServerMemory = 4096 },
            inlayHints = {
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
            preferences = { importModuleSpecifier = "non-relative", includePackageJsonAutoImports = "auto" },
          },
          javascript = { inlayHints = { parameterTypes = { enabled = true } } },
        }},
        eslint = {}, volar = { filetypes = { "vue" }, init_options = { vue = { takeOverMode = true } } },
        svelte = {}, angularls = {}, astro = {}, graphql = {},
        gopls = { settings = { gopls = { usePlaceholders = true, hints = { assignVariableTypes = true, parameterNames = true } } } },
        pyright = {}, ruff = {},
        clangd = { cmd = { "clangd", "--offset-encoding=utf-16" } },
        rust_analyzer = {}, intelephense = {}, arduino_language_server = {}, dockerls = {}, docker_compose_language_service = {},
      }

      for name, conf in pairs(servers) do
        conf.capabilities = vim.tbl_deep_extend("force", {}, caps, conf.capabilities or {})
        conf.on_attach = on_attach
        lsp[name].setup(conf)
      end
    end,
  },
  { "dnlhc/glance.nvim", opts = { preview_win_opts = { number = true }, border = { enable = true } } },
  { "aznhe21/actions-preview.nvim", event = "LspAttach",
    opts = { telescope = { sorting_strategy="ascending", layout_strategy="vertical",
      layout_config = { width=0.6, height=0.7, prompt_position="top", preview_cutoff=20,
        preview_height=function(_,_,m) return m-15 end } } } },
  { "smjonas/inc-rename.nvim", cmd = "IncRename", opts = {} },
}