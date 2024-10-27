return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "quangnguyen30192/cmp-nvim-ultisnips", -- Fonte de completude para UltiSnips
    "SirVer/ultisnips"                     -- Snippet engine
  },
  config = function()
    -- Maneira segura de requerer nvim-cmp
    local status, cmp = pcall(require, "cmp")
    if not status then
      vim.notify("Erro ao carregar nvim-cmp: " .. tostring(cmp), vim.log.levels.ERROR)
      return
    end

    -- Configuração do nvim-cmp
    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["UltiSnips#ExpandSnippet"](args.body) -- Expansão de snippets do UltiSnips
        end,
      },
      mapping = {
        ['<C-e>'] = cmp.mapping.confirm({ select = true }), -- Confirmar seleção
        ['<C-space>'] = cmp.mapping.complete(),             -- Disparar completude
      },
      sources = {
        { name = 'ultisnips' }, -- Apenas UltiSnips como fonte
      },
    })

    -- Configuração do trigger para pular para o próximo placeholder no UltiSnips
    vim.cmd("let g:UltiSnipsJumpForwardTrigger='<C-e>'") -- Trigger para o próximo placeholder
  end
}
