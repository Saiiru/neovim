local Lsp = require "utils.lsp"

--- Run the first available formatter followed by more formatters
---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
  local conform = require "conform"
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

local M = {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>tf",
        function()
          if vim.g.disable_autoformat then
            vim.cmd "FormatEnable"
          else
            vim.cmd "FormatDisable"
          end
        end,
        mode = "",
        desc = "Toggle Format On Save",
      },
      { "<leader>cn", "<cmd>ConformInfo<cr>", desc = "Conform Info" },
      { "<leader>cf", "<cmd>Format<cr>",      desc = "Format Code", mode = "v" },
    },
    opts = {
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        sh = { "shfmt" },
        yaml = { "prettierd", "prettier", "dprint", stop_after_first = true },
        markdown = { "prettierd", "prettier", "dprint", stop_after_first = true },
        ["markdown.mdx"] = { "prettierd", "prettier", "dprint", stop_after_first = true },
        javascript = { "prettierd", "prettier", "biome", "dprint", stop_after_first = true },
        javascriptreact = function(bufnr)
          return { "rustywind", first(bufnr, "prettierd", "prettier", "biome", "dprint") }
        end,
        typescript = { "prettierd", "prettier", "biome", "dprint", stop_after_first = true },
        typescriptreact = function(bufnr)
          return { "rustywind", first(bufnr, "prettierd", "prettier", "biome", "dprint") }
        end,
        svelte = function(bufnr)
          return { "rustywind", first(bufnr, "prettierd", "prettier", "biome", "dprint") }
        end,
        python = { "black", "isort" },
        go = { "gofumpt", "golines" },
        rust = { "rustfmt" },
        java = { "google-java-format" },
        css = { "prettierd", "prettier" },
        scss = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        erb = { "htmlbeautifier" },
        bash = { "beautysh" },
        proto = { "buf" },
        toml = { "taplo" },
      },
      formatters = {
        biome = {
          condition = function()
            local path = Lsp.biome_config_path()
            local is_nvim = path and string.match(path, "nvim")
            if path and not is_nvim then
              return true
            end
            return false
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
            local is_nvim = path and string.match(path, "nvim")
            if path and not is_nvim then
              return false
            end
            return true
          end,
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format { async = true, lsp_format = "fallback", range = range }
      end, { range = true })

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end,
  },
}

return M
