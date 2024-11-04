-- Run linter manually per buffer
-- @param name The name of the linter to run.
local function run_linter_by(name)
  require("lint").try_lint(name)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.cmd(string.format("augroup au_%s_lint_%d", name, bufnr))
  vim.cmd("au!")
  vim.cmd(string.format("au BufWritePost <buffer=%d> lua require'lint'.try_lint('%s')", bufnr, name))
  vim.cmd(string.format("au BufEnter <buffer=%d> lua require'lint'.try_lint('%s')", bufnr, name))
  vim.cmd("augroup end")
end

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        go = { "golangcilint" },
        python = { "ruff" },
        php = { "pint" },
        rust = { "rustfmt" },
        yaml = { { "prettierd", "prettier", "dprint" } },
        markdown = { { "prettierd", "prettier", "dprint" } },
        ["markdown.mdx"] = { { "prettierd", "prettier", "dprint" } },
        javascript = { { "deno_fmt", "prettierd", "prettier", "biome", "dprint" } },
        javascriptreact = { "rustywind", { "deno_fmt", "prettierd", "prettier", "biome", "dprint" } },
        typescript = { { "deno_fmt", "prettierd", "prettier", "biome", "dprint" } },
        typescriptreact = { "rustywind", { "deno_fmt", "prettierd", "prettier", "biome", "dprint" } },
        svelte = { "rustywind", { "deno_fmt", "prettierd", "prettier", "biome", "dprint" } },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        tmux = { "tmux" },
        conf = { "shfmt" },
      },
    },
    keys = {
      {
        -- Run lint by name
        "<leader>rl",
        function()
          local items = {
            "actionlint", -- go install github.com/rhysd/actionlint/cmd/actionlint@latest
            "dotenv_linter", -- brew install dotenv-linter
            "write_good", -- npm install -g write-good
          }

          vim.ui.select(items, {
            prompt = "Select Linter to run",
          }, function(choice)
            if choice ~= nil then
              run_linter_by(choice)
            end
          end)
        end,
        desc = "Run Nvim Lint",
      },
      -- Fix .env variables
      {
        "<leader>fv",
        function()
          local file = vim.fn.fnameescape(vim.fn.expand("%:p")) -- Escape file path for shell

          -- Warn user if file is not .env
          if not string.match(file, "%.env") then
            vim.notify("This is not a .env file", vim.log.levels.WARN)
            return
          end

          vim.cmd("silent !dotenv-linter fix " .. file)
        end,
        desc = "dotenv linter - fix",
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      -- Enable linting when opening a buffer
      vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
    event = { "BufReadPre", "BufNewFile" },
  },
}
