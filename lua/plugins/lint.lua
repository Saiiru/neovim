-- lua/plugins/lint.lua
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Condições utilitárias resumidas
      local function root_has(files)
        local r = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1] or vim.api.nvim_buf_get_name(0))
        return vim.fs.find(files, { path = r, type = "file", limit = 1 })[1] ~= nil
      end

      -- Preferências por linguagem (não-fix)
      lint.linters_by_ft = {
        lua = { "luacheck" },
        java = { "checkstyle" },
        c = { "clangtidy", "cppcheck", "cpplint" },
        cpp = { "clangtidy", "cppcheck", "cpplint" },
        javascript = { "eslint_d" }, typescript = { "eslint_d" }, javascriptreact = { "eslint_d" }, typescriptreact = { "eslint_d" },
        vue = { "eslint_d" }, svelte = { "eslint_d" }, astro = { "eslint_d" },
        css = { "stylelint" }, scss = { "stylelint" }, less = { "stylelint" },
        json = { "jq" }, yaml = { "yamllint" }, markdown = { "markdownlint" }, dockerfile = { "hadolint" }, toml = { "taplo" }, xml = { "xmllint" },
        python = { "ruff", "mypy" }, go = { "golangcilint" }, php = { "phpstan" }, sh = { "shellcheck" }, bash = { "shellcheck" }, zsh = { "shellcheck" }, sql = { "sqlfluff" },
      }

      -- Auto lint sempre ativo
      local grp = vim.api.nvim_create_augroup("KoraLintAlways", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = grp,
        callback = function() vim.defer_fn(function() require("lint").try_lint() end, 0) end,
      })

      vim.api.nvim_create_user_command("Lint", function() lint.try_lint() end, {})
    end,
  },
}