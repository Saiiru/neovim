-- Linting with nvim-lint
-- Async linter runner with diagnostics integration

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {
      "<leader>cl",
      function()
        require("lint").try_lint()
      end,
      desc = "Trigger linting for current file",
    },
  },
  config = function()
    local lint = require "lint"

    ------------------------------------------------------------------------
    -- LINTERS BY FILETYPE
    ------------------------------------------------------------------------
    lint.linters_by_ft = {
      python = { "ruff", "mypy" },
      javascript = { "oxlint" },
      javascriptreact = { "oxlint" },
      typescript = { "oxlint" },
      typescriptreact = { "oxlint" },
      json = { "jsonlint" },
      jsonc = { "jsonlint" },
      yaml = { "yamllint" },
      markdown = { "markdownlint", "cspell" },
      go = { "golangcilint" },
      rust = { "cargo" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },
      dockerfile = { "hadolint" },
      lua = { "selene" },
      sql = { "sqlfluff" },
    }

    ------------------------------------------------------------------------
    -- LINTER CONFIGURATIONS
    ------------------------------------------------------------------------
    local parser = require "lint.parser"

    lint.linters.ruff = {
      cmd = "ruff",
      args = { "check", "--output-format=json", "--stdin-filename", "$FILENAME", "-" },
      stdin = true,
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}
        local ok, decoded = pcall(vim.json.decode, output)
        if ok and decoded then
          for _, item in ipairs(decoded) do
            local loc = item.location
            local end_loc = item.end_location
            table.insert(diagnostics, {
              lnum = (loc and loc.row and loc.row - 1) or 0,
              end_lnum = (end_loc and end_loc.row and end_loc.row - 1) or 0,
              col = (loc and loc.column and loc.column - 1) or 0,
              end_col = (end_loc and end_loc.column and end_loc.column - 1) or 0,
              message = item.message,
              severity = ({
                error = vim.diagnostic.severity.ERROR,
                warning = vim.diagnostic.severity.WARN,
                info = vim.diagnostic.severity.INFO,
                hint = vim.diagnostic.severity.HINT,
              })[(item.severity or item.level or ""):lower()] or vim.diagnostic.severity.WARN,
              source = "ruff",
              code = item.code,
            })
          end
        end
        return diagnostics
      end,
    }

    lint.linters.mypy = {
      cmd = "mypy",
      args = { "--show-column-numbers", "--show-error-codes", "--no-error-summary", "--no-pretty", "$FILENAME" },
      stdin = false,
      ignore_exitcode = true,
      parser = parser.from_errorformat("%f:%l:%c: %trror: %m", {
        source = "mypy",
        severity = vim.diagnostic.severity.ERROR,
      }),
    }

    lint.linters.oxlint = {
      cmd = "oxlint",
      args = { "--format=unix", "--stdin-filename", "$FILENAME" },
      stdin = true,
      ignore_exitcode = true,
      parser = parser.from_errorformat("%f:%l:%c: %t[%^:]#%n] %m", {
        source = "oxlint",
        severity_map = {
          error = vim.diagnostic.severity.ERROR,
          warning = vim.diagnostic.severity.WARN,
        },
      }),
    }

    lint.linters.jsonlint = {
      cmd = "jsonlint",
      args = { "-q", "$FILENAME" },
      stdin = false,
      ignore_exitcode = true,
      parser = parser.from_errorformat("%f:%l:%c: %m", {
        source = "jsonlint",
      }),
    }

    lint.linters.yamllint = {
      cmd = "yamllint",
      args = { "-f", "parsable", "$FILENAME" },
      stdin = false,
      ignore_exitcode = true,
      parser = parser.from_errorformat("%f:%l:%c: [%t] %m", {
        source = "yamllint",
        severity_map = {
          error = vim.diagnostic.severity.ERROR,
          warning = vim.diagnostic.severity.WARN,
        },
      }),
    }

    lint.linters.markdownlint = {
      cmd = "markdownlint",
      args = { "--stdin" },
      stdin = true,
      ignore_exitcode = true,
      parser = parser.from_errorformat("%f:%l:%c %t%*[^:] %m", {
        source = "markdownlint",
        severity_map = {
          error = vim.diagnostic.severity.ERROR,
          warning = vim.diagnostic.severity.WARN,
          info = vim.diagnostic.severity.INFO,
        },
      }),
    }

    lint.linters.cspell = {
      cmd = "cspell",
      args = { "--no-summary", "--no-progress", "--dot", "$FILENAME" },
      stdin = false,
      ignore_exitcode = true,
      parser = parser.from_errorformat("%f:%l:%c: %m", {
        source = "cspell",
      }),
    }

    lint.linters.golangcilint = {
      cmd = "golangci-lint",
      args = { "run", "--out-format", "json", "--issues-exit-code=1", "$FILENAME" },
      stdin = false,
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}
        local ok, decoded = pcall(vim.json.decode, output)
        if ok and decoded and decoded.Issues then
          for _, item in ipairs(decoded.Issues) do
            table.insert(diagnostics, {
              lnum = item.Pos.Line - 1,
              col = item.Pos.Column - 1,
              message = item.Text,
              severity = vim.diagnostic.severity.WARN,
              source = "golangci-lint",
              code = item.FromLinter,
            })
          end
        end
        return diagnostics
      end,
    }

    lint.linters.cargo = {
      cmd = "cargo",
      args = { "check", "--message-format=json-diagnostic-rendered-ansi" },
      stdin = false,
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}
        for line in output:gmatch("[^\r\n]+") do
          local ok, decoded = pcall(vim.json.decode, line)
          if ok and decoded and decoded.reason == "compiler-message" then
            local msg = decoded.message
            if msg then
              local file = msg.spans[1] and msg.spans[1].file_name
              if file and vim.fn.fnamemodify(file, ":p") == vim.api.nvim_buf_get_name(bufnr) then
                table.insert(diagnostics, {
                  lnum = msg.spans[1].line_start - 1,
                  col = msg.spans[1].column_start - 1,
                  end_lnum = msg.spans[1].line_end - 1,
                  end_col = msg.spans[1].column_end - 1,
                  message = msg.message,
                  severity = ({
                    error = vim.diagnostic.severity.ERROR,
                    warning = vim.diagnostic.severity.WARN,
                    note = vim.diagnostic.severity.INFO,
                    help = vim.diagnostic.severity.HINT,
                  })[msg.level] or vim.diagnostic.severity.WARN,
                  source = "cargo",
                  code = msg.code and msg.code.code,
                })
              end
            end
          end
        end
        return diagnostics
      end,
    }

    lint.linters.shellcheck = {
      cmd = "shellcheck",
      args = { "-f", "json", "$FILENAME" },
      stdin = false,
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}
        local ok, decoded = pcall(vim.json.decode, output)
        if ok and decoded then
          for _, item in ipairs(decoded) do
            table.insert(diagnostics, {
              lnum = item.line - 1,
              end_lnum = item.endLine and item.endLine - 1 or item.line - 1,
              col = item.column - 1,
              end_col = item.endColumn and item.endColumn - 1 or item.column - 1,
              message = item.message,
              severity = ({
                error = vim.diagnostic.severity.ERROR,
                warning = vim.diagnostic.severity.WARN,
                info = vim.diagnostic.severity.INFO,
                style = vim.diagnostic.severity.HINT,
              })[item.level] or vim.diagnostic.severity.WARN,
              source = "shellcheck",
              code = item.code,
            })
          end
        end
        return diagnostics
      end,
    }

    lint.linters.hadolint = {
      cmd = "hadolint",
      args = { "--format=json", "$FILENAME" },
      stdin = false,
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}
        local ok, decoded = pcall(vim.json.decode, output)
        if ok and decoded then
          for _, item in ipairs(decoded) do
            table.insert(diagnostics, {
              lnum = item.line - 1,
              col = item.column - 1,
              message = item.message,
              severity = ({
                error = vim.diagnostic.severity.ERROR,
                warning = vim.diagnostic.severity.WARN,
                info = vim.diagnostic.severity.INFO,
                style = vim.diagnostic.severity.HINT,
              })[item.level] or vim.diagnostic.severity.WARN,
              source = "hadolint",
              code = item.code,
            })
          end
        end
        return diagnostics
      end,
    }

    lint.linters.selene = {
      cmd = "selene",
      args = { "--display-style=json", "$FILENAME" },
      stdin = false,
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}
        local ok, decoded = pcall(vim.json.decode, output)
        if ok and decoded then
          for _, item in ipairs(decoded) do
            table.insert(diagnostics, {
              lnum = item.location.span.start.line - 1,
              col = item.location.span.start.column - 1,
              end_lnum = item.location.span["end"].line - 1,
              end_col = item.location.span["end"].column - 1,
              message = item.message,
              severity = vim.diagnostic.severity.WARN,
              source = "selene",
              code = item.kind,
            })
          end
        end
        return diagnostics
      end,
    }

    lint.linters.sqlfluff = {
      cmd = "sqlfluff",
      args = { "lint", "--format=json", "$FILENAME" },
      stdin = false,
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}
        local ok, decoded = pcall(vim.json.decode, output)
        if ok and decoded and decoded[1] and decoded[1].violations then
          for _, item in ipairs(decoded[1].violations) do
            table.insert(diagnostics, {
              lnum = item.line_no - 1,
              col = item.line_pos - 1,
              message = item.description,
              severity = vim.diagnostic.severity.WARN,
              source = "sqlfluff",
              code = item.code,
            })
          end
        end
        return diagnostics
      end,
    }

    ------------------------------------------------------------------------
    -- AUTO-LINT ON SAVE/ENTER
    ------------------------------------------------------------------------
    local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.bo[bufnr].modifiable and vim.bo[bufnr].buftype == "" then
          lint.try_lint()
        end
      end,
    })

    ------------------------------------------------------------------------
    -- COMMANDS
    ------------------------------------------------------------------------
    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })

    vim.api.nvim_create_user_command("LintInfo", function()
      local ft = vim.bo.filetype
      local linters = lint.linters_by_ft[ft] or {}
      print("Linters for " .. ft .. ": " .. vim.inspect(linters))
    end, { desc = "Show linters for current filetype" })
  end,
}