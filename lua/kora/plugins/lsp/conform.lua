-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                    KORA FORMATTING ENGINE - CONFORM                     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({
          async = true,
          lsp_fallback = true,
          timeout_ms = 3000,
        })
      end,
      mode = { "n", "v" },
      desc = "🎨 Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🌐 WEB DEVELOPMENT - CSS/SCSS/TAILWIND
      -- ═══════════════════════════════════════════════════════════════════════════
      css = { "prettier", stop_after_first = true },
      scss = { "prettier", stop_after_first = true },
      sass = { "prettier", stop_after_first = true },
      less = { "prettier", stop_after_first = true },

      -- ═══════════════════════════════════════════════════════════════════════════
      -- ⚡ JAVASCRIPT/TYPESCRIPT ECOSYSTEM
      -- ═══════════════════════════════════════════════════════════════════════════
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      vue = { "prettierd", "prettier", stop_after_first = true },
      svelte = { "prettierd", "prettier", stop_after_first = true },

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 📄 MARKUP & DATA
      -- ═══════════════════════════════════════════════════════════════════════════
      html = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      jsonc = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🖥️ PROGRAMMING LANGUAGES
      -- ═══════════════════════════════════════════════════════════════════════════
      lua = { "stylua" },
      python = { "black", "isort" },
      go = { "gofumpt", "goimports" },
      rust = { "rustfmt" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      java = { "google-java-format" },

      -- ═══════════════════════════════════════════════════════════════════════════
      -- 🐚 SHELL & CONFIG
      -- ═══════════════════════════════════════════════════════════════════════════
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      fish = { "fish_indent" },
    },

    -- ═══════════════════════════════════════════════════════════════════════════
    -- ⚙️ FORMATTER CONFIGURATION
    -- ═══════════════════════════════════════════════════════════════════════════
    formatters = {
      prettier = {
        prepend_args = {
          "--single-quote",
          "--jsx-single-quote",
          "--trailing-comma",
          "es5",
          "--semi",
          "--tab-width",
          "2",
          "--print-width",
          "100",
        },
      },
      prettierd = {
        prepend_args = {
          "--single-quote",
          "--jsx-single-quote",
          "--trailing-comma",
          "es5",
          "--semi",
          "--tab-width",
          "2",
          "--print-width",
          "100",
        },
      },
      stylua = {
        prepend_args = {
          "--indent-type",
          "Spaces",
          "--indent-width",
          "2",
          "--column-width",
          "100",
        },
      },
      shfmt = {
        prepend_args = { "-i", "2", "-ci" },
      },
    },

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 💾 AUTO-FORMAT ON SAVE
    -- ═══════════════════════════════════════════════════════════════════════════
    format_on_save = function(bufnr)
      -- Disable for specific files/directories
      local disabled_dirs = {
        "node_modules",
        ".git",
        "vendor",
        "build",
        "dist",
        "__pycache__",
      }

      local bufname = vim.api.nvim_buf_get_name(bufnr)
      for _, dir in ipairs(disabled_dirs) do
        if bufname:match(dir) then
          return false
        end
      end

      -- Check global/buffer disable flags
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return false
      end

      -- Large file check (100KB)
      local max_filesize = 100 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, bufname)
      if ok and stats and stats.size > max_filesize then
        return false
      end

      return {
        timeout_ms = 1000,
        lsp_fallback = true,
      }
    end,

    notify_on_error = true,
    notify_no_formatters = false,
  },

  config = function(_, opts)
    require("conform").setup(opts)

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🎮 COMMANDS FOR MANUAL CONTROL
    -- ═══════════════════════════════════════════════════════════════════════════
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = "Disable autoformat-on-save", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Re-enable autoformat-on-save" })

    vim.api.nvim_create_user_command("FormatInfo", function()
      local ft = vim.bo.filetype
      local formatters = require("conform").list_formatters(0)
      local formatter_names = {}

      for _, formatter in ipairs(formatters) do
        table.insert(formatter_names, formatter.name)
      end

      if #formatter_names > 0 then
        print("Formatters for " .. ft .. ": " .. table.concat(formatter_names, ", "))
      else
        print("No formatters available for filetype: " .. ft)
      end
    end, { desc = "Show available formatters" })

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🗝️ ADDITIONAL KEYMAPS
    -- ═══════════════════════════════════════════════════════════════════════════
    vim.keymap.set(
      "n",
      "<leader>cF",
      "<cmd>FormatDisable<cr>",
      { desc = "🚫 Disable formatting" }
    )
    vim.keymap.set("n", "<leader>cE", "<cmd>FormatEnable<cr>", { desc = "✅ Enable formatting" })
    vim.keymap.set("n", "<leader>ci", "<cmd>FormatInfo<cr>", { desc = "📊 Format info" })
  end,

  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
