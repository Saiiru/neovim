-- Configuração do plugin barbecue.nvim para breadcrumbs no statusline
return {
  'utilyre/barbecue.nvim',
  name = 'barbecue',
  version = '*', -- Usar a versão mais recente
  dependencies = {
    'SmiteshP/nvim-navic', -- Navegação entre símbolos de código
  },
  event = "BufReadPost", -- Carrega quando abrir um buffer
  config = function()
    require("barbecue").setup({
      attach_navic = true, -- Conecta o plugin ao nvim-navic para obter informações de LSP
      create_autocmd = false, -- Controla manualmente a criação de autocmd
      theme = 'auto', -- Usa o tema padrão do Neovim ou configurações customizadas
      show_dirname = false, -- Evita mostrar o diretório no breadcrumb
      show_basename = true, -- Exibe apenas o nome do arquivo atual
      symbols = {
        modified = "●", -- Indicador de arquivo modificado
        separator = ">", -- Símbolo separador entre breadcrumbs
      },
    })

    -- Criação automática de autocommand para garantir que o barbecue atualize ao abrir o buffer
    vim.api.nvim_create_autocmd({
      "BufWinEnter", "CursorMoved", "InsertLeave", "BufWritePost", "TabClosed"
    }, {
      group = vim.api.nvim_create_augroup("barbecue.updater", {}),
      callback = function()
        require("barbecue.ui").update()
      end,
    })
  end
}

