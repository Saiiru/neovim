return {
  -- Plugins necessários para LSP e integração com Mason, cmp, Treesitter e Rust Tools
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "simrat39/rust-tools.nvim" },
  {
    "neovim/nvim-lspconfig",
    config = function()
      ------------------------------------------------------------------------------
      -- Lista de Language Servers para toda a sua stack
      ------------------------------------------------------------------------------
      local servers = {
        "bashls",
        "biome",
        "cssls",
        "css_variables",
        "cssmodules_ls",
        "docker_compose_language_service",
        "dockerls",
        "eslint",
        "intelephense",
        "jsonls",
        "eslint-lsp",
        "prettierd",
        "tailwindcss-language-server",
        "typescript-language-server",
        "pylsp",           -- Python
        "rnix",
        "stylelint_lsp",
        "tailwindcss",
        "ts_ls",           -- TypeScript/JavaScript (ts_ls)
        "volar",           -- Vue
        "gopls",           -- Golang
        "rust_analyzer",   -- Rust
        "yamlls",          -- YAML (DevOps)
        "terraformls",     -- Terraform (DevOps)
        "lua_ls",          -- Lua (utilize o lua_ls, o novo LSP para Lua)
        "marksman",        -- Markdown
      }

      ------------------------------------------------------------------------------
      -- Função utilitária para capturar a saída de um comando shell
      ------------------------------------------------------------------------------
      local function os_capture(cmd, raw)
        local f = assert(io.popen(cmd, "r"))
        local s = assert(f:read("*a"))
        f:close()
        if raw then return s end
        return s:gsub("^%s+", ""):gsub("%s+$", ""):gsub("[\n\r]+", " ")
      end

      ------------------------------------------------------------------------------
      -- Configuração do Mason e Mason-LSPconfig
      ------------------------------------------------------------------------------
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      mason.setup({
        log_level = vim.log.levels.DEBUG,
        ui = {
          check_outdated_servers_on_open = true,
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending   = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      mason_lspconfig.setup({
        automatic_installation = true,
        ensure_installed = servers,
      })

      ------------------------------------------------------------------------------
      -- Configuração Global do LSP e Diagnósticos
      ------------------------------------------------------------------------------
      local lspconfig = require("lspconfig")
      local lsp_util = require("lspconfig.util")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- Borda arredondada para janelas LSP
      require("lspconfig.ui.windows").default_options.border = "rounded"

      -- Capabilities integradas com nvim-cmp
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Função on_attach com mapeamentos úteis
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end

      -- Configuração global dos diagnósticos
      vim.diagnostic.config({
        virtual_text = true, { prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Configuração do LSP - Diagnóstico visual
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, _)
  -- Personaliza os diagnósticos para exibição
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client or not result.diagnostics then return end
  for _, diagnostic in ipairs(result.diagnostics) do
    diagnostic.severity = diagnostic.severity or vim.diagnostic.severity.Error
  end
  vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
end

      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      ------------------------------------------------------------------------------
      -- Configurações específicas para cada Language Server
      ------------------------------------------------------------------------------
      for _, lsp in ipairs(servers) do
        local default_config = {}
        local settings = {}
        local configs = {}
        local init_options = {}

        if lsp == "eslint" then
          local root_files = {
            ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml",
            ".eslintrc.yml", ".eslintrc.json", "eslint.config.js", "eslint.config.mjs",
            "eslint.config.cjs", "eslint.config.ts", "eslint.config.mts", "eslint.config.cts",
          }
          default_config = {
            cmd = { "vscode-eslint-language-server", "--stdio" },
            filetypes = {
              "javascript", "javascriptreact", "javascript.jsx",
              "typescript", "typescriptreact", "typescript.tsx",
              "vue", "svelte", "astro",
            },
            root_dir = function(fname)
              return lsp_util.root_pattern(unpack(root_files))(fname)
            end,
            settings = {
              validate = "on",
              packageManager = nil,
              useESLintClass = false,
              experimental = { useFlatConfig = false },
              codeActionOnSave = { enable = false, mode = "all" },
              format = true,
              quiet = false,
              onIgnoredFiles = "off",
              rulesCustomizations = {},
              run = "onType",
              problems = { shortenToSingleLine = false },
              nodePath = "",
              workingDirectory = { mode = "location" },
              codeAction = {
                disableRuleComment = { enable = true, location = "separateLine" },
                showDocumentation = { enable = true },
              },
            },
            on_new_config = function(config, new_root_dir)
              config.settings.workspaceFolder = {
                uri = new_root_dir,
                name = vim.fn.fnamemodify(new_root_dir, ":t"),
              }
              local flat_config = false
              for _, f in ipairs({ "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "eslint.config.ts", "eslint.config.mts", "eslint.config.cts" }) do
                if vim.fn.filereadable(new_root_dir .. "/" .. f) == 1 then
                  flat_config = true
                  break
                end
              end
              if flat_config then
                config.settings.experimental.useFlatConfig = true
              end
              local pnp_cjs = new_root_dir .. "/.pnp.cjs"
              local pnp_js  = new_root_dir .. "/.pnp.js"
              if vim.loop.fs_stat(pnp_cjs) or vim.loop.fs_stat(pnp_js) then
                config.cmd = vim.list_extend({ "yarn", "exec" }, config.cmd)
              end
            end,
            handlers = {
              ["eslint/openDoc"] = function(_, result)
                if not result then return {} end
                local sysname = vim.loop.os_uname().sysname
                if sysname:match("Windows") then
                  os.execute(string.format('start %q', result.url))
                elseif sysname:match("Linux") then
                  os.execute(string.format('xdg-open %q', result.url))
                else
                  os.execute(string.format('open %q', result.url))
                end
                return {}
              end,
              ["eslint/confirmESLintExecution"] = function(_, result)
                if not result then return {} end
                return 4
              end,
              ["eslint/probeFailed"] = function()
                vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
                return {}
              end,
              ["eslint/noLibrary"] = function()
                vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
                return {}
              end,
            },
          }
        elseif lsp == "lua_ls" then
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              },
              telemetry = { enable = false },
            },
          }
        elseif lsp == "intelephense" then
          if not configs.intelephense then
            configs.intelephense = {
              default_config = {
                cmd = { "intelphense", "--stdio" },
                filetypes = { "php" },
                root_dir = function() return vim.loop.cwd() end,
              },
            }
          end
          settings = {
            intelephense = {
              stubs = {
                "bcmath", "bz2", "calendar", "Core", "curl", "cypress",
                "date", "dba", "django", "dom", "enchant", "fileinfo",
                "filter", "ftp", "gd", "gettext", "hash", "iconv", "imap",
                "intl", "json", "ldap", "libxml", "mbstring", "mcrypt",
                "mysqli", "oci8", "openssl", "pdo", "pdo_mysql", "pdo_pgsql",
                "pgsql", "readline", "shmop", "SimpleXML", "soap", "sockets",
                "sodium", "SPL", "sqlite3", "sysvsem", "sysvshm", "tidy",
                "tokenizer", "xml", "xmlreader", "xmlrpc", "xmlwriter", "xsl",
              },
              diagnostic = {
                enable = true,
                level = "warning",
              },
            },
          }
        end

        -- Aplicando o LSP de acordo com as configurações e servidores
        lspconfig[lsp].setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = settings,
          init_options = init_options,
        })
      end

    end,
  },
}

