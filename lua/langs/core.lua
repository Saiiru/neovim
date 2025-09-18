local M, lsp = {}, require "lspconfig"
local shared = require "langs._shared"

local function setup(name, conf)
  conf = conf or {}
  conf.capabilities = shared.capabilities()
  conf.on_attach = shared.on_attach
  lsp[name].setup(conf)
end

function M.setup()
  -- Core
  setup("lua_ls", {
    settings = {
      Lua = {
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = { "vim" } },
        hint = { enable = vim.fn.has "nvim-0.10" == 1, setType = vim.fn.has "nvim-0.10" == 1 },
      },
    },
  })
  setup "jsonls"
  setup "yamlls"
  setup "taplo"
  setup "bashls"
  setup "marksman"
  setup "lemminx"

  -- Web / FE
  setup "html"
  setup "cssls"
  setup "tailwindcss"
  setup("emmet_ls", {
    filetypes = {
      "html",
      "css",
      "scss",
      "sass",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "astro",
    },
  })
  setup("vtsls", {
    settings = {
      typescript = {
        tsserver = { maxTsServerMemory = 4096 },
        inlayHints = {
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
        },
        preferences = {
          importModuleSpecifier = "non-relative",
          includePackageJsonAutoImports = "auto",
        },
      },
      javascript = {
        inlayHints = { parameterTypes = { enabled = true } },
      },
    },
  })
  pcall(setup, "eslint")
  pcall(setup, "volar", { filetypes = { "vue" }, init_options = { vue = { takeOverMode = true } } })
  pcall(setup, "svelte")
  pcall(setup, "angularls")
  pcall(setup, "astro")
  pcall(setup, "graphql")

  -- Backends
  setup(
    "gopls",
    { settings = { gopls = { usePlaceholders = true, hints = { assignVariableTypes = true, parameterNames = true } } } }
  )
  setup "pyright"
  pcall(setup, "ruff")
  -- clangd fica no módulo C++ (cpp.lua)
  setup "rust_analyzer"
  setup "intelephense"
  setup "arduino_language_server"
  setup "dockerls"
  setup "docker_compose_language_service"
end

return M
