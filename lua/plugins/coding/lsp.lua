return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      vim.diagnostic.config({
        underline = true,
        virtual_text = false,
        virtual_lines = false,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true, header = "", prefix = "" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then capabilities = cmp_lsp.default_capabilities(capabilities) end

      local function executable(cmd)
        return type(cmd) == "string" and vim.fn.executable(cmd) == 1
      end

      local function has(root, rel)
        return root and vim.uv.fs_stat(root .. "/" .. rel) ~= nil
      end

      local function root_has(patterns)
        return vim.fs.root(0, patterns) or vim.uv.cwd()
      end

      local function has_workspace_typescript()
        return has(root_has({ "package.json", "tsconfig.json", "jsconfig.json", ".git" }), "node_modules/typescript/lib/typescript.js")
      end

      local function supports(client, method)
        if client.supports_method then return client:supports_method(method) end
        local caps = client.server_capabilities or {}
        if method == "textDocument/inlayHint" then return caps.inlayHintProvider ~= nil end
        if method == "textDocument/documentHighlight" then return caps.documentHighlightProvider ~= nil end
        if method == "textDocument/codeLens" then return caps.codeLensProvider ~= nil end
        return false
      end

      local function source_action(kind)
        vim.lsp.buf.code_action({
          apply = true,
          context = { only = { kind } },
        })
      end

      local function on_attach(client, bufnr)
        if client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
        end

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "Definition")
        map("n", "gD", vim.lsp.buf.declaration, "Declaration")
        map("n", "gI", vim.lsp.buf.implementation, "Implementation")
        map("n", "gy", vim.lsp.buf.type_definition, "Type definition")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("i", "<C-s>", vim.lsp.buf.signature_help, "Signature help")
        map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
        map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>co", function() source_action("source.organizeImports") end, "Organize imports")
        map("n", "<leader>cF", function() source_action("source.fixAll") end, "Fix all")
        map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
        map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
        map("n", "<leader>cq", vim.diagnostic.setqflist, "Diagnostics quickfix")

        if supports(client, "textDocument/inlayHint") and vim.lsp.inlay_hint then
          pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
          map("n", "<leader>uh", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
          end, "Toggle inlay hints")
        end

        if supports(client, "textDocument/documentHighlight") then
          local group = vim.api.nvim_create_augroup("sairu-lsp-highlight-" .. bufnr, { clear = true })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        if supports(client, "textDocument/codeLens") then
          local group = vim.api.nvim_create_augroup("sairu-lsp-codelens-" .. bufnr, { clear = true })
          vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
            group = group,
            buffer = bufnr,
            callback = function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end,
          })
          map("n", "<leader>cl", function() vim.lsp.codelens.run() end, "Run code lens")
        end
      end

      local ts_inlay = {
        parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      }

      local servers = {
        lua_ls = {
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" },
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim", "Snacks" } },
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
              hint = { enable = true, arrayIndex = "Disable", await = true, paramName = "Literal", paramType = true, semicolon = "Disable", setType = true },
              telemetry = { enable = false },
            },
          },
        },
        clangd = {
          cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--completion-style=detailed", "--function-arg-placeholders" },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "arduino" },
          root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", "platformio.ini", "sketch.yaml", "CMakeLists.txt", ".git" },
          init_options = { fallbackFlags = { "-std=c++17" } },
        },
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_markers = { "go.work", "go.mod", ".git" },
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
              usePlaceholders = true,
              completeFunctionCalls = true,
              semanticTokens = true,
              analyses = { nilness = true, shadow = true, unusedparams = true, unusedwrite = true, useany = true },
              hints = { assignVariableTypes = false, compositeLiteralFields = true, compositeLiteralTypes = false, constantValues = true, functionTypeParameters = true, ignoredError = true, parameterNames = true, rangeVariableTypes = true },
              codelenses = { generate = true, regenerate_cgo = true, run_govulncheck = true, tidy = true, upgrade_dependency = true, vendor = true },
            },
          },
        },
        rust_analyzer = {
          cmd = { "rust-analyzer" },
          filetypes = { "rust" },
          root_markers = { "Cargo.toml", "rust-project.json", ".git" },
          enabled = function()
            return not pcall(require, "rustaceanvim")
          end,
          settings = { ["rust-analyzer"] = { cargo = { allTargets = true, buildScripts = { enable = true } }, procMacro = { enable = true }, check = { command = "clippy" } } },
        },
        jdtls = {
          cmd = { "jdtls" },
          filetypes = { "java" },
          root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts", ".git" },
        },
        basedpyright = {
          cmd = { "basedpyright-langserver", "--stdio" },
          filetypes = { "python" },
          root_markers = { "pyproject.toml", "basedpyrightconfig.json", "pyrightconfig.json", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
          settings = { basedpyright = { analysis = { typeCheckingMode = "standard", diagnosticMode = "openFilesOnly", autoSearchPaths = true, autoImportCompletions = true, useLibraryCodeForTypes = true, inlayHints = { variableTypes = false, callArgumentNames = true, callArgumentNamesMatching = false, functionReturnTypes = true, genericTypes = true } } } },
        },
        ruff = {
          cmd = { "ruff", "server" },
          filetypes = { "python" },
          root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
        },
        vtsls = {
          cmd = { "vtsls", "--stdio" },
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
          enabled = function() return has_workspace_typescript() end,
          settings = {
            vtsls = { autoUseWorkspaceTsdk = true },
            typescript = { suggest = { completeFunctionCalls = true }, updateImportsOnFileMove = { enabled = "always" }, preferences = { includePackageJsonAutoImports = "on", importModuleSpecifier = "shortest", quoteStyle = "auto" }, inlayHints = ts_inlay, tsserver = { maxTsServerMemory = 4096 } },
            javascript = { suggest = { completeFunctionCalls = true }, updateImportsOnFileMove = { enabled = "always" }, inlayHints = vim.tbl_extend("force", ts_inlay, { parameterTypes = { enabled = false } }) },
          },
        },
        ts_ls = {
          cmd = { "typescript-language-server", "--stdio" },
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
          enabled = function() return not executable("vtsls") and has_workspace_typescript() end,
        },
        vue_ls = { cmd = { "vue-language-server", "--stdio" }, filetypes = { "vue" }, root_markers = { "package.json", "vue.config.js", "vite.config.ts", "vite.config.js", "nuxt.config.ts", ".git" } },
        svelte = { cmd = { "svelte-language-server", "--stdio" }, filetypes = { "svelte" }, root_markers = { "package.json", "svelte.config.js", "svelte.config.ts", ".git" } },
        astro = { cmd = { "astro-ls", "--stdio" }, filetypes = { "astro" }, root_markers = { "package.json", "astro.config.mjs", "astro.config.ts", ".git" } },
        jsonls = { cmd = { "vscode-json-language-server", "--stdio" }, filetypes = { "json", "jsonc" }, root_markers = { "package.json", ".git" } },
        yamlls = { cmd = { "yaml-language-server", "--stdio" }, filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" }, root_markers = { ".git" }, settings = { yaml = { keyOrdering = false } } },
        taplo = { cmd = { "taplo", "lsp", "stdio" }, filetypes = { "toml" }, root_markers = { "taplo.toml", ".taplo.toml", ".git" } },
        bashls = { cmd = { "bash-language-server", "start" }, filetypes = { "bash", "sh", "zsh" }, root_markers = { ".git" } },
        html = { cmd = { "vscode-html-language-server", "--stdio" }, filetypes = { "html" }, root_markers = { "package.json", ".git" } },
        cssls = { cmd = { "vscode-css-language-server", "--stdio" }, filetypes = { "css", "scss", "less" }, root_markers = { "package.json", ".git" } },
      }

      for name, config in pairs(servers) do
        local enabled = config.enabled
        config.enabled = nil
        config.capabilities = capabilities
        config.on_attach = on_attach
        if (not enabled or enabled()) and config.cmd and executable(config.cmd[1]) then
          vim.lsp.config(name, config)
          vim.lsp.enable(name)
        end
      end
    end,
  },
}
