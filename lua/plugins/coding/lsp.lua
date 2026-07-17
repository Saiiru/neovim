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

      local function on_attach(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition, "LSP definition")
        map("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
        map("n", "gi", vim.lsp.buf.implementation, "LSP implementation")
        map("n", "gr", vim.lsp.buf.references, "LSP references")
        map("n", "K", vim.lsp.buf.hover, "LSP hover")
        map("n", "<leader>cr", vim.lsp.buf.rename, "LSP rename")
        map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
        map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
        map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
        map("n", "<leader>cq", vim.diagnostic.setqflist, "Diagnostics quickfix")
        if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map("n", "<leader>uh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
          end, "Toggle inlay hints")
        end
      end

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
              telemetry = { enable = false },
            },
          },
        },
        clangd = {
          cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--completion-style=detailed", "--function-arg-placeholders", "--fallback-style=llvm" },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "arduino" },
          root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", "platformio.ini", "sketch.yaml", "CMakeLists.txt", ".git" },
          init_options = { fallbackFlags = { "-std=c++17" } },
        },
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_markers = { "go.work", "go.mod", ".git" },
          settings = { gopls = { gofumpt = true, staticcheck = true, analyses = { unusedparams = true, shadow = true } } },
        },
        rust_analyzer = {
          cmd = { "rust-analyzer" },
          filetypes = { "rust" },
          root_markers = { "Cargo.toml", "rust-project.json", ".git" },
          enabled = function()
            -- rustaceanvim starts and configures rust-analyzer itself. Avoid
            -- attaching a second native client to the same Rust buffer.
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
          root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
          settings = { basedpyright = { analysis = { typeCheckingMode = "basic", autoSearchPaths = true, useLibraryCodeForTypes = true } } },
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
          enabled = function()
            return has_workspace_typescript()
          end,
          settings = { vtsls = { autoUseWorkspaceTsdk = true }, typescript = { tsserver = { maxTsServerMemory = 4096 } } },
        },
        ts_ls = {
          cmd = { "typescript-language-server", "--stdio" },
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
          enabled = function()
            return not executable("vtsls") and has_workspace_typescript()
          end,
        },
        vue_ls = {
          cmd = { "vue-language-server", "--stdio" },
          filetypes = { "vue" },
          root_markers = { "package.json", "vue.config.js", "vite.config.ts", "vite.config.js", "nuxt.config.ts", ".git" },
        },
        svelte = {
          cmd = { "svelte-language-server", "--stdio" },
          filetypes = { "svelte" },
          root_markers = { "package.json", "svelte.config.js", "svelte.config.ts", ".git" },
        },
        astro = {
          cmd = { "astro-ls", "--stdio" },
          filetypes = { "astro" },
          root_markers = { "package.json", "astro.config.mjs", "astro.config.ts", ".git" },
        },
        jsonls = {
          cmd = { "vscode-json-language-server", "--stdio" },
          filetypes = { "json", "jsonc" },
          root_markers = { "package.json", ".git" },
        },
        yamlls = {
          cmd = { "yaml-language-server", "--stdio" },
          filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
          root_markers = { ".git" },
          settings = { yaml = { keyOrdering = false } },
        },
        taplo = {
          cmd = { "taplo", "lsp", "stdio" },
          filetypes = { "toml" },
          root_markers = { "taplo.toml", ".taplo.toml", ".git" },
        },
        bashls = {
          cmd = { "bash-language-server", "start" },
          filetypes = { "bash", "sh", "zsh" },
          root_markers = { ".git" },
        },
        html = {
          cmd = { "vscode-html-language-server", "--stdio" },
          filetypes = { "html" },
          root_markers = { "package.json", ".git" },
        },
        cssls = {
          cmd = { "vscode-css-language-server", "--stdio" },
          filetypes = { "css", "scss", "less" },
          root_markers = { "package.json", ".git" },
        },
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
