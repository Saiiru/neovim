-- Configuração profissional do null-ls e mason-null-ls para múltiplas linguagens
return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = { "jay-babu/mason-null-ls.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")
    local mason_null_ls = require("mason-null-ls")

    -- Lista de ferramentas a serem instaladas e configuradas automaticamente
    mason_null_ls.setup({
      ensure_installed = {
        -- Formatters
        "stylua",            -- Lua
        "prettier",          -- JavaScript, TypeScript, HTML, CSS
        "black",             -- Python
        "gofumpt",           -- Go
        "shfmt",             -- Shell
        -- Linters
        "eslint_d",          -- JavaScript, TypeScript
        "flake8",            -- Python
        "golangci_lint",     -- Go
        "shellcheck",        -- Shell
        "phpcs",             -- PHP
      },
      automatic_installation = true,
    })

    -- Handlers para configurar cada fonte automaticamente
    mason_null_ls.setup_handlers({
      function(source_name, methods)
        -- Configuração padrão para ferramentas com automatic_setup
        require("mason-null-ls.automatic_setup")(source_name, methods)
      end,
      -- Configuração customizada para cada linguagem
      stylua = function()
        null_ls.register(null_ls.builtins.formatting.stylua)
      end,
      prettier = function()
        null_ls.register(null_ls.builtins.formatting.prettier.with({
          filetypes = { "javascript", "typescript", "css", "html", "json", "yaml", "markdown" },
        }))
      end,
      black = function()
        null_ls.register(null_ls.builtins.formatting.black)
      end,
      gofumpt = function()
        null_ls.register(null_ls.builtins.formatting.gofumpt)
      end,
      shfmt = function()
        null_ls.register(null_ls.builtins.formatting.shfmt)
      end,
      eslint_d = function()
        null_ls.register(null_ls.builtins.diagnostics.eslint_d)
        null_ls.register(null_ls.builtins.code_actions.eslint_d)
      end,
      flake8 = function()
        null_ls.register(null_ls.builtins.diagnostics.flake8)
      end,
      golangci_lint = function()
        null_ls.register(null_ls.builtins.diagnostics.golangci_lint)
      end,
      shellcheck = function()
        null_ls.register(null_ls.builtins.diagnostics.shellcheck)
        null_ls.register(null_ls.builtins.code_actions.shellcheck)
      end,
      phpcs = function()
        null_ls.register(null_ls.builtins.diagnostics.phpcs)
      end,
    })

    -- Grupo de autocmds para formatação automática ao salvar
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    -- Configuração global do null-ls
    null_ls.setup({
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })
  end,
}

