local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
    { "hrsh7th/cmp-buffer", event = "InsertEnter" },
    { "hrsh7th/cmp-path", event = "InsertEnter" },
    { "hrsh7th/cmp-cmdline", event = "InsertEnter" },
    { "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
    {
      "L3MON4D3/LuaSnip",
      event = "InsertEnter",
      dependencies = { "rafamadriz/friendly-snippets" },
    },
    { "hrsh7th/cmp-emoji", event = "InsertEnter" },
    { "hrsh7th/cmp-nvim-lua" },
    {
      "tzachar/cmp-tabnine",
      build = "./install.sh",
      config = function()
        local tabnine = require "cmp_tabnine.config"
        tabnine:setup {
          max_lines = 1000,
          max_num_results = 3,
          sort = true,
          show_prediction_strength = false,
          run_on_every_keystroke = true,
          snippet_placeholder = "..",
          ignored_file_types = {},
        }
      end,
    },
    { "hrsh7th/cmp-copilot" },
  },
}

function M.config()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local icons = require("sairu.icons")

  require("luasnip.loaders.from_vscode").lazy_load()

  -- Helper function for backspace check
  local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
  end

  -- nvim-cmp setup
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
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
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = icons.kind[vim_item.kind]
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          nvim_lua = "[Lua]",
          luasnip = "[Snip]",
          buffer = "[Buffer]",
          path = "[Path]",
          emoji = "[Emoji]",
        })[entry.source.name]

        if entry.source.name == "emoji" then
          vim_item.kind = icons.misc.Smiley
        elseif entry.source.name == "copilot" then
          vim_item.kind = icons.git.Copilot
        elseif entry.source.name == "cmp_tabnine" then
          vim_item.kind = icons.misc.Robot
        end

        if entry.source.name == "luasnip" then
          vim_item.kind = icons.kind.Snippet
          vim_item.expandable_indicator = "▶"
        end

        return vim_item
      end,
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "copilot" },
      { name = "buffer" },
      { name = "path" },
      { name = "emoji" },
      { name = "cmp_tabnine" },
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        require("copilot_cmp.comparators").prioritize or function() end,
        function(entry1, entry2)
          if entry1:get_kind() == cmp.lsp.CompletionItemKind.Snippet then
            return false
          elseif entry2:get_kind() == cmp.lsp.CompletionItemKind.Snippet then
            return true
          end
        end,
        require("cmp").config.compare.exact,
        require("cmp").config.compare.locality,
        require("cmp").config.compare.recently_used,
        function(entry1, entry2)
          local _, entry1_under = entry1.completion_item.label:find("^_+")
          local _, entry2_under = entry2.completion_item.label:find("^_+")
          entry1_under = entry1_under or 0
          entry2_under = entry2_under or 0
          if entry1_under > entry2_under then
            return false
          elseif entry1_under < entry2_under then
            return true
          end
        end,
        require("cmp").config.compare.score,
        require("cmp").config.compare.kind,
        require("cmp").config.compare.length,
        require("cmp").config.compare.order,
        require("cmp").config.compare.sort_text,
      },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    window = {
      completion = {
        border = "rounded",
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        pumblend = 15,
        max_item_count = 10,
      },
      documentation = {
        border = "rounded",
        winhighlight = "NormalFloat:Pmenu,FloatBorder:Pmenu",
      },
    },
    experimental = {
      ghost_text = true,
    },
  })

  -- Cmdline setup
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end

return M
