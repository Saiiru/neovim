return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    local function biome_exists()
      local current_dir = vim.fn.getcwd()
      local config_file = current_dir .. "/biome.json"
      if vim.fn.filereadable(config_file) == 1 then
        return true
      end

      local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
      if git_root and git_root ~= "" then
        config_file = git_root .. "/biome.json"
        if vim.fn.filereadable(config_file) == 1 then
          return true
        end
      end

      return false
    end

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        svelte = { biome_exists() and "biome" or "prettier" },
        javascript = { biome_exists() and "biome" or "prettier" },
        typescript = { biome_exists() and "biome" or "prettier" },
        javascriptreact = { biome_exists() and "biome" or "prettier" },
        typescriptreact = { biome_exists() and "biome" or "prettier" },
        json = { biome_exists() and "biome" or "prettier" },
        graphql = { biome_exists() and "biome" or "prettier" },
        html = { biome_exists() and "biome" or "prettier" },
        css = { biome_exists() and "biome" or "prettier" },
        scss = { biome_exists() and "biome" or "prettier" },
        yaml = { biome_exists() and "biome" or "prettier" },
        markdown = { biome_exists() and "biome" or "prettier" },
        python = { "black", "isort" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        go = { "gofmt" },
        rust = { "rustfmt" },
        java = { "google-java-format" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
