return {
  -- LSP para C e C++
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      ensure_installed = { "clangd" }, -- Instala o LSP principal
      setup = {
        clangd = function(_, opts)
          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          opts.capabilities = capabilities
          opts.cmd = { "clangd", "--background-index", "--clang-tidy" } -- Configurações básicas do clangd
          opts.filetypes = { "c", "cpp", "objc", "objcpp" } -- Detecta arquivos C e C++
        end,
      },
    },
  },

  -- Snippets e cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip", -- Snippet engine
      "rafamadriz/friendly-snippets", -- Coleção de snippets
    },
    opts = function(_, opts)
      local luasnip = require("plugins.editor.telescope.luasnip")
      local cmp = require("cmp")

      -- Define snippets específicos para C e C++
      luasnip.filetype_extend("c", { "c" })
      luasnip.filetype_extend("cpp", { "cpp", "c" })

      -- Configuração básica do cmp
      opts.snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      }

      opts.mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-Space>"] = cmp.mapping.complete(),
      })

      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- Prioriza snippets
        { name = "buffer", keyword_length = 4 },
        { name = "path" },
      })

      opts.formatting = {
        format = require("lspkind").cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      }
    end,
  },

  -- Formatador para C/C++
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "jay-babu/mason-null-ls.nvim" },
    opts = function(_, opts)
      local null_ls = require("null-ls")
      opts.sources = {
        null_ls.builtins.formatting.clang_format.with({
          filetypes = { "c", "cpp" },
        }),
      }
    end,
  },

  -- Suporte a testes com CTest
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "rouge8/neotest-ctest",
    },
    opts = {
      adapters = {
        ["neotest-ctest"] = {},
      },
    },
  },
}
