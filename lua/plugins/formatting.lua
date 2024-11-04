local Lsp = require("utils.lsp")

return {
  -- Setup config for formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    keys = {
      -- Add keymap for show info
      { "<leader>cn", "<cmd>ConformInfo<cr>", desc = "Conform Info" },
    },
    opts = {
      formatters_by_ft = {
        fish = {},
        -- Conform will run multiple formatters sequentially
        ["go"] = { "goimports", "gofmt" },
        ["python"] = { "black", "ruff_fix", "ruff_format" },
        php = { "php-cs-fixer" },
        rust = { "rustfmt" },
        lua = { "stylua" },
        bash = { "shfmt" },
        -- Use a sub-list to run only the first available formatter
        ["yaml"] = { { "prettierd", "prettier", "dprint" } },
        ["markdown"] = { { "prettierd", "prettier", "dprint" } },
        ["markdown.mdx"] = { { "prettierd", "prettier", "dprint" } },
        ["javascript"] = { { "deno_fmt", "prettierd", "prettier", "biome", "dprint" } },
        ["javascriptreact"] = { "rustywind", { "deno_fmt", "prettierd", "prettier", "biome", "dprint" } },
        ["typescript"] = { { "deno_fmt", "prettierd", "prettier", "biome", "dprint" } },
        ["typescriptreact"] = { "rustywind", { "deno_fmt", "prettierd", "prettier", "biome", "dprint" } },
        ["svelte"] = { "rustywind", { "deno_fmt", "prettierd", "prettier", "biome", "dprint" } },
        ["bash"] = { "shfmt" },
        ["zsh"] = { "shfmt" },
        ["tmux"] = { "tmux" },
        ["conf"] = { "shfmt" },
        ["angular"] = { "prettier", "eslint_d" },
      },
      formatters = {
        biome = {
          condition = function()
            local path = Lsp.biome_config_path()
            -- Skip if biome.json is in nvim
            local is_nvim = path and string.match(path, "nvim")

            if path and not is_nvim then
              return true
            end

            return false
          end,
        },
        deno_fmt = {
          condition = function()
            return Lsp.deno_config_exist()
          end,
        },
        dprint = {
          condition = function()
            return Lsp.dprint_config_exist()
          end,
        },
        prettier = {
          condition = function()
            local path = Lsp.biome_config_path()
            -- Skip if biome.json is in nvim
            local is_nvim = path and string.match(path, "nvim")

            if path and not is_nvim then
              return false
            end

            return true
          end,
        },
        prettierd = {
          condition = function()
            local path = Lsp.biome_config_path()
            -- Skip if biome.json is in nvim
            local is_nvim = path and string.match(path, "nvim")

            if path and not is_nvim then
              return false
            end

            return true
          end,
        },
        shfmt = {
          condition = function()
            return true
          end,
        },
        tmux = {
          condition = function()
            return true
          end,
        },
      },
    },
  },
}
