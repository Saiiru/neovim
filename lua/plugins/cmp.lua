return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "L3MON4D3/LuaSnip", config = true },
    { "neovim/nvim-lspconfig", config = true },
    { "onsails/lspkind.nvim", config = true }, -- For icons
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
    { "hrsh7th/cmp-path" }, -- Path completion
    { "jose-elias-alvarez/nvim-lsp-ts-utils", config = true }, -- Auto-import for TypeScript
  },
  opts = function(_, opts)
    opts.formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(_, item)
        local icons = require("lspkind").cmp_format({ with_text = true, maxwidth = 50 })
        return icons(_, item)
      end,
    }
    vim.cmd([[
  highlight FloatBorder guifg=#ff0000 guibg=#1e1e1e gui=bold
  highlight Normal guifg=#ffffff guibg=#1e1e1e
  highlight CursorLine guibg=#3c3c3c
]])

    -- Define the border for completion and documentation
    local border = {
      { "╭", "FloatBorder" },
      { "─", "FloatBorder" },
      { "╮", "FloatBorder" },
      { "│", "FloatBorder" },
      { "╯", "FloatBorder" },
      { "─", "FloatBorder" },
      { "╰", "FloatBorder" },
      { "│", "FloatBorder" },
    }

    opts.window = {
      completion = {
        border = border,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:Search",
      },
      documentation = {
        border = border,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:Search",
      },
    }
  end,
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      view = {
        entries = "native", -- Use native completion entries
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- Expand snippets using LuaSnip
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "neorg" },
        { name = "path" },
        { name = "buffer" },
      },

      experimental = {
        ghost_text = true, -- Enable ghost text
      },
    })

    -- TypeScript auto-import setup
    require("lspconfig").tsserver.setup({
      on_attach = function(client)
        require("nvim-lsp-ts-utils").setup({
          disable_commands = false,
          enable_import_on_completion = true,
          import_all_buffered = true,
        })
      end,
    })
  end,
}
