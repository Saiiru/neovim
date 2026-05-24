return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    local formatting = require("config.formatting")

    local function buf_dir(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == "" then
        return nil
      end
      return vim.fs.dirname(name)
    end

    local function has_upward(bufnr, names, kind)
      local path = buf_dir(bufnr)
      if not path then
        return false
      end
      return vim.fs.find(names, {
        upward = true,
        path = path,
        type = kind or "file",
      })[1] ~= nil
    end

    local function has_biome_config(bufnr)
      return has_upward(bufnr, {
        "biome.json",
        "biome.jsonc",
        ".biome.json",
        ".biome.jsonc",
      })
    end

    local function prettier_formatters()
      return {
        "prettierd",
        "prettier",
        stop_after_first = true,
        lsp_format = "fallback",
      }
    end

    local function web_code_formatters(bufnr)
      if has_biome_config(bufnr) then
        return {
          "biome-organize-imports",
          "biome",
          lsp_format = "fallback",
        }
      end
      return prettier_formatters()
    end

    local function web_data_formatters(bufnr)
      if has_biome_config(bufnr) then
        return {
          "biome",
          lsp_format = "fallback",
        }
      end
      return prettier_formatters()
    end

    local function web_markup_formatters()
      return prettier_formatters()
    end

    local function python_formatters(bufnr)
      local conform = require("conform")
      if conform.get_formatter_info("ruff_format", bufnr).available then
        return {
          "ruff_fix",
          "ruff_organize_imports",
          "ruff_format",
        }
      end
      return {
        "isort",
        "black",
      }
    end

    return {
      default_format_opts = {
        lsp_format = "fallback",
        quiet = true,
      },
      formatters_by_ft = {
        ["*"] = function(bufnr)
          local ft = vim.bo[bufnr].filetype
          if ft == "markdown" or ft == "gitcommit" or ft == "text" then
            return { "trim_newlines" }
          end
          return { "trim_whitespace", "trim_newlines" }
        end,

        lua = { "stylua" },
        python = python_formatters,

        javascript = web_code_formatters,
        javascriptreact = web_code_formatters,
        typescript = web_code_formatters,
        typescriptreact = web_code_formatters,

        json = web_data_formatters,
        jsonc = web_data_formatters,
        css = web_data_formatters,
        scss = web_data_formatters,
        less = web_data_formatters,

        html = web_markup_formatters,
        vue = web_markup_formatters,
        svelte = web_markup_formatters,
        astro = web_markup_formatters,
        graphql = web_markup_formatters,
        liquid = web_markup_formatters,
        markdown = web_markup_formatters,
        ["markdown.mdx"] = web_markup_formatters,

        yaml = { "yamlfmt", lsp_format = "fallback" },
        toml = { "taplo", lsp_format = "fallback" },

        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },

        go = { "goimports", "gofumpt", lsp_format = "fallback" },
        rust = { "rustfmt", lsp_format = "fallback" },
        java = { "google-java-format", lsp_format = "fallback" },
        kotlin = { "ktlint", lsp_format = "fallback" },

        c = { "clang-format", lsp_format = "fallback" },
        cpp = { "clang-format", lsp_format = "fallback" },
        arduino = { "clang-format", lsp_format = "fallback" },
        objc = { "clang-format", lsp_format = "fallback" },
        objcpp = { "clang-format", lsp_format = "fallback" },

        nix = { "nixfmt", lsp_format = "fallback" },
      },
      formatters = {
        prettier = {
          require_cwd = true,
        },
        prettierd = {
          require_cwd = true,
        },
      },
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if ft == "gitcommit" then
          return nil
        end
        if not formatting.enabled() then
          return nil
        end
        return {
          timeout_ms = 1500,
          lsp_format = "fallback",
          quiet = true,
        }
      end,
      notify_on_error = true,
      notify_no_formatters = false,
      log_level = vim.log.levels.ERROR,
    }
  end,
  keys = {
    {
      "<leader>Fm",
      function()
        require("conform").format({
          lsp_format = "fallback",
          timeout_ms = 1500,
        })
      end,
      mode = { "n", "v" },
      desc = "Conform: Format manually",
    },
    {
      "<leader>cF",
      function()
        require("conform").format({
          lsp_format = "fallback",
          timeout_ms = 1500,
        })
      end,
      mode = { "n", "v" },
      desc = "Format Buffer/Selection",
    },
    {
      "<leader>cT",
      function()
        require("config.formatting").toggle()
      end,
      desc = "Toggle Autoformat",
    },
    {
      "<leader>cW",
      function()
        vim.cmd("FixWhitespace")
      end,
      desc = "Fix Whitespace",
    },
  },
}
