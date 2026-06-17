-- Native LSP Configuration (Neovim 0.11+)
-- Uses vim.lsp.config() and vim.lsp.enable() instead of lspconfig
-- All root_markers and settings defined declaratively

local LspUtils = require("utils.lsp")
local Path = require("utils.path")

local M = {}

-- Default on_attach with keymaps and features
local function on_attach(client, bufnr)
  LspUtils.on_attach(client, bufnr)

  -- Inlay hints
  if client:supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  -- Document highlight
  if client:supports_method("textDocument/documentHighlight") then
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- Capabilities with blink.cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, "blink.cmp")
if ok then
  capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
end

-- ============================================================================
-- LSP SERVER CONFIGURATIONS
-- Each config is passed to vim.lsp.config(name, config)
-- ============================================================================

---@type table<string, vim.lsp.Config>
M.servers = {
  -- Python
  basedpyright = {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "openFilesOnly",
          typeCheckingMode = "basic",
        },
      },
    },
  },

  ruff = {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      -- Disable hover in favor of basedpyright
      client.server_capabilities.hoverProvider = false
    end,
    capabilities = capabilities,
  },

  -- Lua
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git",
    },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            "${3rd}/luv/library",
            "${3rd}/busted/library",
          },
        },
        completion = { callSnippet = "Replace" },
        diagnostics = {
          globals = { "vim", "Snacks" },
          disable = { "missing-fields" },
        },
        format = { enable = false }, -- Use stylua via conform
        hint = { enable = true, arrayIndex = "Disable" },
        telemetry = { enable = false },
      },
    },
  },

  -- TypeScript/JavaScript
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  vtsls = {
    cmd = { "vtsls", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      vtsls = {
        experimental = {
          completion = { enableServerSideFuzzyMatch = true },
        },
      },
      typescript = {
        inlayHints = {
          parameterNames = { enabled = "all" },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
    },
  },

  biome = {
    cmd = { "biome", "lsp-proxy" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc", "json5" },
    root_markers = { "biome.json", "biome.jsonc", "package.json", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {},
  },

  oxlint = {
    cmd = { "oxlint", "lsp-proxy" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "oxlintrc.json", ".oxlintrc.json", "package.json", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {},
  },

  prettierd = {
    cmd = { "prettierd" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "jsonc",
      "json5",
      "html",
      "css",
      "scss",
      "markdown",
      "yaml",
      "graphql",
    },
    root_markers = {
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.yaml",
      ".prettierrc.yml",
      ".prettierrc.toml",
      "prettier.config.js",
      "package.json",
      ".git",
    },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {},
  },

  -- Go
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.mod", "go.work", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
          shadow = true,
        },
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

  -- Rust
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" },
        inlayHints = {
          bindingModeHints = { enable = true },
          chainingHints = { enable = true },
          closingBraceHints = { enable = true },
          closureReturnTypeHints = { enable = true },
          lifetimeElisionHints = { enable = true },
          parameterHints = { enable = true },
          reborrowHints = { enable = true },
          typeHints = { enable = true },
        },
      },
    },
  },

  -- HTML/CSS/Tailwind
  tailwindcss = {
    cmd = { "tailwindcss-language-server", "--stdio" },
    filetypes = {
      "html",
      "css",
      "scss",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
      "astro",
    },
    root_markers = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs", "package.json", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      tailwindCSS = {
        experimental = { classRegex = { "cva\\(([^)]*)\\)", "cn\\(([^)]*)\\)" } },
        validate = true,
      },
    },
  },

  -- JSON
  jsonls = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc", "json5" },
    root_markers = { "package.json", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      json = {
        validate = { enable = true },
        format = { enable = true },
        schemas = {},
      },
    },
  },

  -- YAML
  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yml" },
    root_markers = { ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      yaml = {
        validate = true,
        format = { enable = true },
        hover = true,
        completion = true,
        schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
      },
    },
  },

  -- Markdown
  marksman = {
    cmd = { "marksman" },
    filetypes = { "markdown" },
    root_markers = { ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {},
  },

  -- Shell
  bashls = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "bash", "sh", "zsh" },
    root_markers = { ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {},
  },

  -- Docker
  dockerls = {
    cmd = { "docker-langserver", "--stdio" },
    filetypes = { "dockerfile" },
    root_markers = { "Dockerfile", "docker-compose.yml", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {},
  },

  -- TOML
  taplo = {
    cmd = { "taplo", "lsp", "stdio" },
    filetypes = { "toml" },
    root_markers = { "Cargo.toml", "pyproject.toml", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {},
  },

  -- SQL
  sqls = {
    cmd = { "sqls" },
    filetypes = { "sql" },
    root_markers = { ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {},
  },

  -- C# (C-Sharp)
  csharp_ls = {
    cmd = { "csharp-ls" },
    filetypes = { "cs" },
    root_markers = { "*.sln", "*.csproj", ".git" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      csharp = {
        inlayHints = {
          enable = true,
          parameterNames = true,
          parameterTypes = true,
          variableTypes = true,
        },
        formatting = {
          enable = false, -- Use csharpier via conform
        },
      },
    },
  },

  -- Arduino (uses clangd with Arduino-specific config)
  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
      "--query-driver=/home/**/.platformio/packages/toolchain-*/bin/*",
    },
    filetypes = { "c", "cpp", "arduino", "h", "hpp" },
    root_markers = { "compile_commands.json", "platformio.ini", "CMakeLists.txt", ".git", "*.ino" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      clangd = {
        fallbackFlags = { "-std=c++17", "-DARDUINO=10819", "-DARDUINO_AVR_UNO", "-DARDUINO_ARCH_AVR" },
        init_options = {
          fallbackFlags = { "-std=c++17", "-DARDUINO=10819", "-DARDUINO_AVR_UNO", "-DARDUINO_ARCH_AVR" },
          compilationDatabasePath = "./build",
        },
      },
    },
  },
}

-- ============================================================================
-- APPLY ALL CONFIGS
-- ============================================================================

function M.setup()
  for name, config in pairs(M.servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end

return M
