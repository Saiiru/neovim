return {
  {
    'brenoprata10/nvim-highlight-colors',
    event = { 'BufNewFile', 'BufRead' },
    config = function()
      vim.opt.termguicolors = true
      require('nvim-highlight-colors').setup {
        enable_tailwind = true,
        render = 'virtual',
        virtual_symbol_prefix = '[',
        virtual_symbol_suffix = ']',
        virtual_symbol_position = 'eol',
      }
    end
  },
  {
    'uga-rosa/ccc.nvim',
    config = function()
      -- Habilitar cores verdadeiras
      vim.opt.termguicolors = true
      local status, ccc = pcall(require, "ccc")
      if not status then return end
      local mapping = ccc.mapping

      ccc.setup({
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      })
    end,
    cmd = { 'CccPick' },
  },
  {
    'fei6409/log-highlight.nvim',
    ft = { 'log' },
    config = function()
      require('log-highlight').setup {}
    end,
  },
  {
    'nvchad/minty',
    dependencies = { 'nvchad/volt' },
    config = function()
      vim.api.nvim_create_user_command(
        "MintyHue", -- Nome do comando
        function()  -- Função a ser executada
          require('minty.huefy').open({ border = true })
        end,
        { nargs = 0 } -- Sem argumentos para o comando
      )

      vim.api.nvim_create_user_command(
        "MintyShade", -- Nome do segundo comando
        function()
          print("Comando MintyShade executado!")
        end,
        { nargs = 0 } -- Sem argumentos para este comando
      )
    end,
    cmd = { 'MintyHue', 'MintyShade' }
  },
}


