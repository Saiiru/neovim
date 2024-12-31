return {
  "akinsho/git-conflict.nvim",
  event = "BufReadPre", -- Carrega o plugin antes de ler o arquivo
  config = {
    default_mappings = true, -- Habilita os mapeamentos padrão para gerenciar conflitos
    default_commands = true, -- Habilita os comandos padrão do plugin
    disable_diagnostics = false, -- Não desativa os diagnósticos enquanto o arquivo está com conflitos
    list_opener = "copen", -- Usa o comando 'copen' para abrir a lista de conflitos
    highlights = { -- Define as cores de destaque para as seções conflitantes
      incoming = "DiffAdd", -- Texto da versão remota será destacado com a cor de adição
      current = "DiffText", -- Texto da versão local será destacado com a cor de diferença
    },
  },
  setup = function()
    -- Paleta de cores cyberpunk
    vim.cmd([[
      highlight DiffAdd guifg=#00FF00 guibg=#1C1C1C gui=bold      " Neon green for incoming changes
      highlight DiffText guifg=#FF00FF guibg=#1C1C1C gui=bold    " Neon pink/purple for current changes
      highlight GitConflictCurrent guifg=#FF4500 guibg=#1C1C1C   " Neon red for current changes
      highlight GitConflictIncoming guifg=#00FFFF guibg=#1C1C1C  " Neon cyan for incoming changes
      highlight GitConflictUnmerged guifg=#FFFF00 guibg=#1C1C1C " Neon yellow for unmerged sections
    ]])

    -- Ativar símbolos futuristas e cyberpunk para os conflitos
    vim.g.git_conflict_marker_style = "block" -- Usar blocos sólidos para dividir os conflitos

    -- Adicionar um efeito neon com brilho
    vim.cmd([[
      highlight GitConflictCurrent guifg=#FF4500 guibg=#2A2A2A gui=bold
      highlight GitConflictIncoming guifg=#00FFFF guibg=#2A2A2A gui=bold
      highlight GitConflictUnmerged guifg=#FFFF00 guibg=#2A2A2A gui=bold
    ]])
  end,
}
