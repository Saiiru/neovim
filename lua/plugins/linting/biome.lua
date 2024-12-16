return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "biome", -- Ensures biome is installed for formatting
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        biome = {}, -- Ensures biome LSP server is configured
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local function add_formatters(tbl)
        -- Adds formatters to the configuration for specific file types
        for ft, formatters in pairs(tbl) do
          if opts.formatters_by_ft[ft] == nil then
            opts.formatters_by_ft[ft] = formatters
          else
            vim.list_extend(opts.formatters_by_ft[ft], formatters)
          end
        end
      end

      -- Add file types and assign biome as the formatter for them
      add_formatters {
        ["jsonc"] = { "biome" },
        ["json"] = { "biome" },
        ["javascript"] = { "biome" },
        ["typescript"] = { "biome" },
        ["typescriptreact"] = { "biome" },
        ["javascriptreact"] = { "biome" },
        ["astro"] = { "biome" },
        ["svelte"] = { "biome" },
        ["vue"] = { "biome" },
        ["graphql"] = { "biome" },
        ["css"] = { "biome" },
        ["scss"] = { "biome" }, -- Include SCSS
        ["less"] = { "biome" }, -- Include LESS
        ["html"] = { "biome" }, -- Include HTML (for templating)
        ["xml"] = { "biome" }, -- Include XML (used in Angular)
        ["markdown"] = { "biome" }, -- Include markdown for documentation purposes
        -- Add other relevant file types for your stack
      }

      opts.formatters = {
        biome = {
          condition = function(self, ctx)
            -- Check for biome.json in project root for enabling biome formatter
            return vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        prettier = {
          condition = function(self, ctx)
            -- Fallback to prettier if biome.json is not found
            return not vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        prettierd = {
          condition = function(self, ctx)
            -- Fallback to prettierd if biome.json is not found
            return not vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      }

      return opts
    end,
  },
}
