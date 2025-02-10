return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",        -- Integração com LSP
      "hrsh7th/cmp-buffer",          -- Completa palavras do buffer
      "hrsh7th/cmp-path",            -- Completa caminhos de arquivos
      "hrsh7th/cmp-cmdline",         -- Completa comandos na linha de comando
      "L3MON4D3/LuaSnip",            -- Motor de snippets
      "saadparwaiz1/cmp_luasnip",    -- Fonte de snippets para nvim-cmp
      "rafamadriz/friendly-snippets", -- Snippets prontos (VSCode-style)
      "onsails/lspkind.nvim",        -- Ícones estilo VSCode (nerd fonts)
      "hrsh7th/cmp-nvim-lsp-signature-help", -- Inlay hints de assinatura
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Carrega snippets no formato VSCode, se disponível
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            maxheight = 30, -- Ajuste a altura para se assemelhar ao VSCode
            winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:CmpSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            maxheight = 30,
            winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
          }),
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",  -- Exibe ícones e texto
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
        snippet = {
          expand = function(args)
            -- Verifica se o LuaSnip pode expandir o snippet
            if luasnip.expand_or_jumpable() then
              luasnip.lsp_expand(args.body)  -- Expande o snippet com LuaSnip
            else
              print("Não há snippet para expandir!") -- Feedback se não houver snippet
            end
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
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
          { name = "nvim_lsp", priority = 100 },
          { name = "luasnip",  priority = 90 },
          { name = "buffer",   priority = 80, keyword_length = 3 },
          { name = "path",     priority = 70 },
          { name = "cmdline",  priority = 60 },
        }),
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
      })

      -- Adiciona suporte para Inlay Hints (exibe informações sobre assinaturas de funções)
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",  -- Personaliza bordas de inlay hints
        focusable = false,   -- Não pode interagir diretamente
        close_events = {"InsertLeave", "CursorMoved", "BufLeave"}, -- Fechar o hint em alguns eventos
      })

      -- Configuração para o modo cmdline (':')
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      -- Configuração para o modo cmdline ('/')
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
}
