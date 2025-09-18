return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        lua = { "luacheck" },
        java = { "checkstyle" },
        c = { "clangtidy","cppcheck","cpplint" },
        cpp = { "clangtidy","cppcheck","cpplint" },
        javascript = { "eslint_d" }, typescript = { "eslint_d" }, javascriptreact = { "eslint_d" }, typescriptreact = { "eslint_d" },
        vue = { "eslint_d" }, svelte = { "eslint_d" }, astro = { "eslint_d" },
        css = { "stylelint" }, scss = { "stylelint" }, less = { "stylelint" },
        json = { "jq" }, yaml = { "yamllint" }, markdown = { "markdownlint" }, dockerfile = { "hadolint" },
        toml = { "taplo" }, xml = { "xmllint" },
        python = { "ruff","mypy" }, go = { "golangcilint" }, php = { "phpstan" },
        sh = { "shellcheck" }, bash = { "shellcheck" }, zsh = { "shellcheck" }, sql = { "sqlfluff" },
      }
      local grp = vim.api.nvim_create_augroup("KoraLintAlways", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = grp,
        callback = function() vim.defer_fn(function() require("lint").try_lint() end, 0) end,
      })
      vim.api.nvim_create_user_command("Lint", function() lint.try_lint() end, {})
    end,
  },
}