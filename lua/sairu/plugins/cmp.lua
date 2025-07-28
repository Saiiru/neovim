return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind-nvim",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-cmdline",
    "roobert/tailwindcss-colorizer-cmp.nvim",
    "windwp/nvim-autopairs",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
    local tailwindcss_colorizer_cmp = require("tailwindcss-colorizer-cmp")

    -- Load friendly snippets + user snippets
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })

    vim.opt.completeopt = { "menu", "menuone", "noselect" }
    vim.opt.shortmess:append("c")

    -- Icon & kind map for clean VSCode-like UI
    local kind_icons = {
      Text = "", Method = "ƒ", Function = "", Constructor = "",
      Field = "ﰠ", Variable = "", Class = "", Interface = "ﰮ",
      Module = "", Property = "", Unit = "", Value = "",
      Enum = "了", Keyword = "", Snippet = "﬌", Color = "",
      File = "", Reference = "", Folder = "", EnumMember = "",
      Constant = "", Struct = "", Event = "", Operator = "ﬦ",
      TypeParameter = "",
    }

    -- Core CMP Setup
    cmp.setup({
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
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
      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 900 },
        { name = "buffer", priority = 700 },
        { name = "path", priority = 500 },
      }),
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          -- Tailwind colorizer integration
          vim_item = tailwindcss_colorizer_cmp.formatter(entry, vim_item)

          -- Replace kind icon
          vim_item.kind = (kind_icons[vim_item.kind] or "") .. " " .. vim_item.kind

          -- Source menu icons
          local menu_icons = {
            nvim_lsp = "[LSP]",
            luasnip = "[SNIP]",
            buffer = "[BUF]",
            path = "[PATH]",
            cmdline = "[CMD]",
          }
          vim_item.menu = menu_icons[entry.source.name] or ""
          return vim_item
        end,
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      experimental = {
        ghost_text = true,
        native_menu = false,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      performance = {
        debounce = 60,
        throttle = 30,
        fetching_timeout = 500,
        confirm_resolve_timeout = 80,
        async_budget = 1,
        max_view_entries = 200,
      },
    })

    -- Filetype specific source overrides to maximize snippet utility
    cmp.setup.filetype({ "c", "cpp" }, {
      sources = cmp.config.sources({
        { name = "luasnip", priority = 1100 },
        { name = "nvim_lsp", priority = 1000 },
        { name = "buffer", priority = 700 },
        { name = "path", priority = 500 },
      }),
    })

    cmp.setup.filetype("gitcommit", {
      sources = cmp.config.sources({
        { name = "buffer", priority = 900 },
      }),
    })

    cmp.setup.filetype("markdown", {
      sources = cmp.config.sources({
        { name = "buffer", priority = 900 },
        { name = "path", priority = 600 },
      }),
    })

    -- Command-line completion for ':'
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" },
      }),
    })

    -- Command-line completion for '/' and '?'
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Auto pairs integration
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    -- Snippet navigation highlight
    luasnip.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
          active = {
            virt_text = { { "●", "GruvboxPurple" } },
          },
        },
      },
    })

    -- Optional: custom highlight groups for cmp UI
    vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#7B68EE", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = "#4DABF7", bg = "NONE" })
    vim.api.nvim_set_hl(0, "CmpPmenu", { bg = "#1A1A1A" })
    vim.api.nvim_set_hl(0, "CmpSel", { bg = "#2F2F2F", fg = "#E6E6E6" })
    vim.api.nvim_set_hl(0, "CmpDoc", { bg = "#0A0A0A" })
  end,
}

