return {
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
  {
     'tzachar/cmp-tabnine',
     build = './install.sh',
     dependencies = 'hrsh7th/nvim-cmp',
 },
}
