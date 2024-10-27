local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  vim.api.nvim_err_writeln("cmp not yet installed!")
  return
end

-- Fontes de completions incluindo Tabnine e Copilot
local cmp_sources = {
  { name = "path", max_item_count = 10 },
  { name = "nvim_lsp", max_item_count = 5 },
  { name = "nvim_lua", max_item_count = 5 },
  { name = "ultisnips", max_item_count = 5 },
  { name = "buffer", max_item_count = 5 },
  { name = "copilot", max_item_count = 3 }, -- Integração com GitHub Copilot
  { name = "cmp_tabnine", max_item_count = 3 }, -- Integração com Tabnine
  { name = "nvim_lsp_signature_help" },
}

-- Configuração aprimorada do nvim-cmp com Tabnine e Copilot
cmp.setup({
  preselect = cmp.PreselectMode.None, -- Evita escolha automática
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter confirma seleção
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-Space>"] = cmp.mapping.complete(), -- Ativa manualmente a conclusão
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Down>"] = cmp.mapping.scroll_docs(4), -- Rola a documentação para baixo
    ["<S-Up>"] = cmp.mapping.scroll_docs(-4), -- Rola a documentação para cima
  },
  sources = cmp.config.sources(cmp_sources),
})

-- -- Integração específica para Tabnine
-- local tabnine = require("cmp_tabnine.config")
-- tabnine:setup({
--   max_lines = 1000,
--   max_num_results = 5,
--   sort = true,
-- })
--
-- -- Integração específica para Copilot
-- require("copilot_cmp").setup({
--   method = "getCompletion", -- Método de obtenção das sugestões
-- })

