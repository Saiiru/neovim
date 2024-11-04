return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
    {
      "zbirenbaum/copilot-cmp",
      verylazy = true,
      dependencies = "copilot.lua",
      opts = {},
      config = function(_, opts)
        local copilot_cmp = require("copilot_cmp")
        copilot_cmp.setup(opts)

        -- Modifiquei aqui para não usar `utils.functions`
        vim.api.nvim_create_autocmd("InsertEnter", {
          callback = function()
            if vim.lsp.get_active_clients()[1] and vim.lsp.get_active_clients()[1].name == "copilot" then
              copilot_cmp._on_insert_enter({})
            end
          end,
        })
      end,
    },
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local luasnip = require("luasnip")
    local vscodesnippets = require("luasnip.loaders.from_vscode")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    -- Função para verificar se há palavras antes do cursor
    local function has_words_before()
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    cmp.setup({
      enabled = function()
        local context = require("cmp.config.context")
        if vim.api.nvim_get_mode().mode == "c" then
          return true
        else
          return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
        end
      end,
      preselect = "none",
      completion = {
        keyword_length = 1,
        completeopt = "menu,menuone,noinsert,noselect",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        fields = { "abbr", "kind", "menu" },
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
          mode = "symbol_text",
          symbol_map = { Copilot = "" },
        }),
      },
      mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<C-c>"] = cmp.mapping.abort(),
        ["<C-n>"] = { i = cmp.mapping.complete() },
      },
      sources = {
        { name = "copilot", group_index = 2 },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "path", option = { trailing_slash = true } },
        { name = "buffer" },
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          require("copilot_cmp.comparators").prioritize,
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
    })

    -- Configurações específicas para cmdline
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

    -- Carregando snippets do VSCode
    vscodesnippets.lazy_load()
  end,
}
