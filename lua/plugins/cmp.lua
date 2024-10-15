return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
    { "hrsh7th/cmp-emoji", event = "InsertEnter" },
    { "hrsh7th/cmp-buffer", event = "InsertEnter" },
    { "hrsh7th/cmp-path", event = "InsertEnter" },
    { "hrsh7th/cmp-cmdline", event = "InsertEnter" },
    { "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
    {
      "L3MON4D3/LuaSnip",
      event = "InsertEnter",
      dependencies = { "rafamadriz/friendly-snippets" },
    },
    { "hrsh7th/cmp-nvim-lua", event = "InsertEnter" },
  },
  config = function()
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    require("luasnip/loaders/from_vscode").lazy_load()

    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#CA42F0" })
    vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })

    local check_backspace = function()
      local col = vim.fn.col "." - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
    end

    local icons = require("config.icons.icons")

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- For luasnip users.
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.scroll_docs(-1),
        ["<C-j>"] = cmp.mapping.scroll_docs(1),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-y>"] = cmp.config.disable, -- Specify cmp.config.disable if you want to remove the default <C-y> mapping.
        ["<C-e>"] = cmp.mapping {
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        },
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif check_backspace() then
            fallback()
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = icons.kind[vim_item.kind]
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            nvim_lua = "[Lua]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
            emoji = "[Emoji]",
          })[entry.source.name]

          if entry.source.name == "emoji" then
            vim_item.kind = icons.misc.Smiley
            vim_item.kind_hl_group = "CmpItemKindEmoji"
          end

          if entry.source.name == "cmp_tabnine" then
            vim_item.kind = icons.misc.Robot
            vim_item.kind_hl_group = "CmpItemKindTabnine"
          end

          return vim_item
        end,
      },
      sources = {
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "cmp_tabnine" },
        { name = "nvim_lua" },
        { name = "buffer" },
        { name = "path" },
        { name = "calc" },
        { name = "emoji" },
      },
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      window = {
        completion = { border = "rounded", scrollbar = false },
        documentation = { border = "rounded" },
      },
      experimental = {
        ghost_text = true, -- Enable ghost text for better inline suggestion.
      },
    }
  end
}
