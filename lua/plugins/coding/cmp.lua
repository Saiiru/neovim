local cmp = require("cmp")

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip", -- Snippets
    "hrsh7th/cmp-nvim-lua", -- Lua completions
    "hrsh7th/cmp-cmdline", -- Cmdline completions
    "L3MON4D3/LuaSnip", -- Snippet engine
    "windwp/nvim-autopairs", -- Auto-pairs integration
    "David-Kunz/cmp-npm", -- NPM completions
    "onsails/lspkind.nvim", -- Icons
    "lukas-reineke/cmp-under-comparator", -- Comparator
    "hrsh7th/cmp-emoji", -- Emoji completions
    "lukas-reineke/cmp-rg", -- Ripgrep for fuzzy search
    "rcarriga/cmp-dap", -- Debug Adapter Protocol completions
    "hrsh7th/cmp-nvim-lsp-signature-help", -- Signature help
  },
  opts = function(_, opts)
    local lspkind = require("lspkind")
    local luasnip = require("plugins.editor.telescope.luasnip")
    local autopairs = require("nvim-autopairs.completion.cmp")

    -- Set snippet expansion
    opts.snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    }

    -- Enhanced UI
    opts.window = {
      completion = {
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
        scrollbar = true,
        col_offset = -3,
        side_padding = 1,
      },
      documentation = {
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
        scrollbar = true,
      },
    }

    -- Mappings
    opts.mapping = cmp.mapping.preset.insert({
      ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    })

    -- Performance tuning
    opts.performance = {
      debounce = 0,
      throttle = 0,
      fetching_timeout = 20,
      confirm_resolve_timeout = 20,
      async_budget = 1,
      max_view_entries = 50,
    }

    -- Sources with priority and additional features
    opts.sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 1000 },
      { name = "luasnip", priority = 900 },
      { name = "buffer", keyword_length = 4, priority = 800 },
      { name = "path", priority = 700 },
      { name = "emoji", priority = 600 },
      { name = "npm", keyword_length = 4, priority = 500 },
      { name = "rg", keyword_length = 4, priority = 400 },
      { name = "nvim_lsp_signature_help", priority = 300 },
    })

    -- Formatting with icons
    opts.formatting = {
      format = lspkind.cmp_format({
        mode = "symbol_text",
        maxwidth = 50,
        ellipsis_char = "...",
      }),
    }

    -- Auto-pairs integration
    cmp.event:on("confirm_done", autopairs.on_confirm_done())

    -- Cmdline setup
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    -- Comparator: Under case-sensitive items
    opts.sorting = {
      comparators = {
        require("cmp-under-comparator").under,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    }
  end,
}
