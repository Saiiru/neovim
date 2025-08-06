-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                      KORA LINTING ENGINE - NVIM-LINT                   ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🎯 LINTERS BY FILETYPE
    -- ═══════════════════════════════════════════════════════════════════════════
    lint.linters_by_ft = {
      -- Web Development
      css = { "stylelint" },
      scss = { "stylelint" },
      sass = { "stylelint" },
      less = { "stylelint" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      vue = { "eslint_d" },
      svelte = { "eslint_d" },

      -- Data & Config
      json = { "jsonlint" },
      yaml = { "yamllint" },
      markdown = { "markdownlint" },

      -- Programming Languages
      python = { "flake8" },
      go = { "golangci-lint" },
      lua = { "luacheck" },

      -- Shell
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },

      -- DevOps
      dockerfile = { "hadolint" },
    }

    -- ═══════════════════════════════════════════════════════════════════════════
    -- ⚙️ LINTER CONFIGURATIONS
    -- ═══════════════════════════════════════════════════════════════════════════
    lint.linters.eslint_d.args = {
      "--no-warn-ignored",
      "--format",
      "json",
      "--stdin",
      "--stdin-filename",
      function()
        return vim.fn.expand("%:p")
      end,
    }

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🚀 AUTO-LINT TRIGGERS
    -- ═══════════════════════════════════════════════════════════════════════════
    local lint_augroup = vim.api.nvim_create_augroup("kora_lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Skip if disabled
        if vim.g.lint_disabled then
          return
        end

        -- Skip large files (100KB)
        local bufname = vim.api.nvim_buf_get_name(0)
        local ok, stats = pcall(vim.loop.fs_stat, bufname)
        if ok and stats and stats.size > 100 * 1024 then
          return
        end

        -- Skip problematic directories
        local skip_dirs = { "node_modules", ".git", "vendor", "build", "dist" }
        for _, dir in ipairs(skip_dirs) do
          if bufname:match(dir) then
            return
          end
        end

        lint.try_lint()
      end,
    })

    vim.api.nvim_create_user_command("LintInfo", function()
      local ft = vim.bo.filetype
      local linters = lint.linters_by_ft[ft] or {}
      local msg = #linters > 0 and ("Linters for " .. ft .. ": " .. table.concat(linters, ", "))
        or ("No linters for: " .. ft)
      print(msg)
    end, { desc = "Show linters for filetype" })

    vim.api.nvim_create_user_command("LintToggle", function()
      vim.g.lint_disabled = not vim.g.lint_disabled
      local status = vim.g.lint_disabled and "disabled" or "enabled"
      print("🔍 Linting " .. status)
      if not vim.g.lint_disabled then
        lint.try_lint()
      end
    end, { desc = "Toggle linting" })

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🗝️ KEYMAPS
    -- ═══════════════════════════════════════════════════════════════════════════
    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "🔍 Lint buffer" })
    vim.keymap.set("n", "<leader>cL", "<cmd>LintInfo<cr>", { desc = "📊 Lint info" })
    vim.keymap.set("n", "<leader>cT", "<cmd>LintToggle<cr>", { desc = "🔄 Toggle linting" })
  end,
}
