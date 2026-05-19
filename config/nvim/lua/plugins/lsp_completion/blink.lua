return {
  -- ==============================================================================================
  -- TITLE : blink.cmp
  -- ABOUT : Autocomplete moderno e performático (mantido como engine principal).
  -- ==============================================================================================
  "saghen/blink.cmp",
  event = "InsertEnter",
  version = "1.*",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "folke/lazydev.nvim",
    "giuxtaposition/blink-cmp-copilot",
    "zbirenbaum/copilot.lua",
  },
  opts = function()
    local icons = require("config.icons")

    return {
      keymap = {
        preset = "enter",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-j>"] = { "snippet_forward", "fallback" },
        ["<C-k>"] = { "snippet_backward", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
        kind_icons = vim.tbl_extend("force", icons.kind, {
          Copilot = "",
        }),
      },

      completion = {
        list = {
          -- Equivalente ao `suggest.noselect`: não aceita item por acidente.
          selection = { preselect = false, auto_insert = false },
          max_items = 30,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 180,
          window = { border = "single", scrollbar = true },
        },
        menu = {
          border = "single",
          scrollbar = false,
          draw = {
            columns = {
              { "kind_icon" },
              { "label", gap = 1 },
              { "source_name" },
            },
          },
        },
        ghost_text = { enabled = false },
        trigger = {
          show_on_insert = true,
          show_on_keyword = true,
        },
      },

      cmdline = { enabled = false },
      snippets = { preset = "luasnip" },

      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer", "copilot" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 90,
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = "Copilot"
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
        },
      },

      signature = {
        enabled = true,
        window = { border = "single" },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },
    }
  end,
}
