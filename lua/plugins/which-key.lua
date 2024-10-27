return {
  -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  opts = {
    icons = {
      -- Define if using Nerd Font
      mappings = vim.g.have_nerd_font,
      keys = vim.g.have_nerd_font and {} or {
        Up = '<Up> ',
        Down = '<Down> ',
        Left = '<Left> ',
        Right = '<Right> ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '<CR> ',
        Esc = '<Esc> ',
        ScrollWheelDown = '<ScrollWheelDown> ',
        ScrollWheelUp = '<ScrollWheelUp> ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '<Space> ',
        Tab = '<Tab> ',
        F1 = '<F1>', F2 = '<F2>', F3 = '<F3>', F4 = '<F4>', 
        F5 = '<F5>', F6 = '<F6>', F7 = '<F7>', F8 = '<F8>', 
        F9 = '<F9>', F10 = '<F10>', F11 = '<F11>', F12 = '<F12>',
      },
    },
      show_keys = false, -- Não exibir as teclas mapeadas
  show_help = false, -- Não exibir mensagem de ajuda na linha de comando
  layout = {
    align = "center", -- Alinhamento centralizado do pop-up
  },
  win = {
    border = "double", -- Tipo de borda do pop-up
    title = false, -- Desativa o título do pop-up
    padding = { 1, 1 }, -- Padding extra [top/bottom, right/left]
    no_overlap = true, -- Previne sobreposição de janelas
  },

    -- Document existing key chains
    spec = {
      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    },
  },
}

