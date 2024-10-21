-- Configuração do plugin inc-rename.nvim para renomeação incremental no LSP
return {
  'smjonas/inc-rename.nvim',
  cmd = 'IncRename',  -- Carrega o comando IncRename
  config = function()
    require('inc_rename').setup({
      input_buffer_type = "dressing",  -- Usa dressing.nvim para uma melhor UI, caso instalado
    })

    -- Mapeamento de atalho para renomear variáveis de maneira incremental
    vim.keymap.set("n", "<leader>rn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, desc = '[R]ename Incremental LSP' })
  end
}

