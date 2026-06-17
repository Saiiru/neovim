-- Formatting with conform.nvim
-- Lightweight, fast formatter with LSP fallback

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format { async = true, lsp_fallback = true }
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    ------------------------------------------------------------------------
    -- FORMATTERS BY FILETYPE
    ------------------------------------------------------------------------
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format", "ruff_organize_imports" },
      javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
      typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
      json = { "biome", "prettierd", "prettier", stop_after_first = true },
      jsonc = { "biome", "prettierd", "prettier", stop_after_first = true },
      json5 = { "biome", "prettierd", "prettier", stop_after_first = true },
      html = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      scss = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      go = { "goimports", "gofmt" },
      rust = { "rustfmt" },
      java = { "google_java_format" },
      sh = { "shfmt" },
      zsh = { "shfmt" },
      bash = { "shfmt" },
      toml = { "taplo" },
      sql = { "sqlfmt" },
      dockerfile = { "dockerfmt" },
      ["_"] = { "trim_whitespace", "trim_newlines" },
    },

    ------------------------------------------------------------------------
    -- FORMATTER OPTIONS
    ------------------------------------------------------------------------
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
      ruff_format = {
        prepend_args = { "--line-length", "100" },
      },
      ruff_organize_imports = {
        prepend_args = { "--select", "I" },
      },
      biome = {
        require_cwd = true,
        condition = function(ctx)
          return vim.fn.filereadable(ctx.dirname .. "/biome.json") == 1
            or vim.fn.filereadable(ctx.dirname .. "/biome.jsonc") == 1
        end,
      },
      prettierd = {
        condition = function(ctx)
          return vim.fn.filereadable(ctx.dirname .. "/.prettierrc") == 1
            or vim.fn.filereadable(ctx.dirname .. "/.prettierrc.json") == 1
            or vim.fn.filereadable(ctx.dirname .. "/.prettierrc.yaml") == 1
            or vim.fn.filereadable(ctx.dirname .. "/.prettierrc.yml") == 1
            or vim.fn.filereadable(ctx.dirname .. "/.prettierrc.toml") == 1
            or vim.fn.filereadable(ctx.dirname .. "/prettier.config.js") == 1
        end,
      },
      prettier = {
        condition = function(ctx)
          return vim.fn.filereadable(ctx.dirname .. "/.prettierrc") == 1
            or vim.fn.filereadable(ctx.dirname .. "/.prettierrc.json") == 1
            or vim.fn.filereadable(ctx.dirname .. "/.prettierrc.yaml") == 1
            or vim.fn.filereadable(ctx.dirname .. "/.prettierrc.yml") == 1
            or vim.fn.filereadable(ctx.dirname .. "/.prettierrc.toml") == 1
            or vim.fn.filereadable(ctx.dirname .. "/prettier.config.js") == 1
        end,
      },
      google_java_format = {
        prepend_args = { "--aosp" },
      },
      shfmt = {
        prepend_args = { "-i", "2", "-ci", "-sr" },
      },
      goimports = {
        prepend_args = { "-local", "github.com" },
      },
      rustfmt = {
        prepend_args = { "--edition", "2021" },
      },
      taplo = {
        prepend_args = { "--option", "indent_string=  " },
      },
    },

    ------------------------------------------------------------------------
    -- FORMAT ON SAVE
    ------------------------------------------------------------------------
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      local max_filesize = 1024 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size > max_filesize then
        return
      end
      return { timeout_ms = 3000, lsp_fallback = true }
    end,

    ------------------------------------------------------------------------
    -- NOTIFICATIONS
    ------------------------------------------------------------------------
    notify_on_error = true,
    notify_no_formatters = true,

    ------------------------------------------------------------------------
    -- LOG LEVEL
    ------------------------------------------------------------------------
    log_level = vim.log.levels.INFO,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    ------------------------------------------------------------------------
    -- COMMANDS
    ------------------------------------------------------------------------
    vim.api.nvim_create_user_command("FormatToggle", function(args)
      if args.bang then
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        vim.notify("Buffer autoformat: " .. (vim.b.disable_autoformat and "OFF" or "ON"))
      else
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("Global autoformat: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
      end
    end, { desc = "Toggle autoformat on save", bang = true })
  end,
}