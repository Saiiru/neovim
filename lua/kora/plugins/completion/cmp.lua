-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                    KORA NEURAL COMPLETION MATRIX                        ║
-- ║                      INTELLIGENT AUTOCOMPLETION                         ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- ═════════════════════════════════════════════════════════════════════════
  --  COMPLETION ENGINE - NEURAL AUTOCOMPLETE
  -- ═════════════════════════════════════════════════════════════════════════
  
-- ══════════════════════════════════════════════════════════════════════════
-- EXEMPLOS DE USO - COMPLETION.LUA
-- ══════════════════════════════════════════════════════════════════════════
-- Este arquivo configura o sistema de autocompletar inteligente:
--
-- NVIM-CMP (AUTOCOMPLETAR PRINCIPAL):
-- <C-n>/<C-p>                  -- Navegar itens do menu
-- <C-b>/<C-f>                  -- Scroll documentação
-- <C-Space>                    -- Forçar completion
-- <C-e>                        -- Cancelar completion
-- <CR>                         -- Aceitar sugestão
-- <Tab>/<S-Tab>                -- Navegar + snippet jump
--
-- FONTES DE COMPLETION (PRIORIDADES):
-- LSP (1000)                   -- Language servers (principais)
-- LuaSnip (750)                -- Snippets de código
-- Buffer (500)                 -- Palavras do buffer atual
-- Path (250)                   -- Caminhos de arquivos
--
-- LUASNIP (SNIPPETS):
-- <C-K>                        -- Expandir snippet
-- <C-L>                        -- Pular para próximo placeholder
-- <C-J>                        -- Voltar para placeholder anterior
-- <C-E>                        -- Trocar choice node
--
-- SNIPPETS INCLUSOS:
-- date                         -- Data atual (2024-01-15)
-- time                         -- Hora atual (14:30:45)
-- datetime                     -- Data e hora completa
--
-- SNIPPETS LUA:
-- req                          -- local module = require("module")
-- fn                           -- function template
--
-- SNIPPETS JAVASCRIPT:
-- cl                           -- console.log()
-- af                           -- arrow function template
--
-- SNIPPETS PYTHON:
-- def                          -- function template
-- class                        -- class template
--
-- SNIPPETS GO:
-- iferr                        -- if err != nil template
-- func                         -- function template
--
-- SNIPPETS JAVA:
-- main                         -- public static void main
-- sout                         -- System.out.println
  {  "b0o/schemastore.nvim"},
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local icons = {} -- Customize as needed
            if icons[item.kind] then
              item.kind = icons[item.kind] .. " " .. item.kind
            end
            local source_names = {
              nvim_lsp = "[LSP]",
              luasnip = "[SNIP]",
              buffer = "[BUF]",
              path = "[PATH]",
              cmdline = "[CMD]",
            }
            item.menu = source_names[entry.source.name] or ""
            if #item.abbr > 50 then
              item.abbr = string.sub(item.abbr, 1, 47) .. "..."
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
          }),
        },
        performance = {
          debounce = 60,
          throttle = 30,
          fetching_timeout = 500,
          confirm_resolve_timeout = 80,
          async_budget = 1,
          max_view_entries = 200,
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      -- Enhanced command line completion
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
    end,
  }
}
