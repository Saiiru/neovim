-- Plugin Neogit para gerenciamento Git no Neovim
return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Requerido para funcionalidade adicional
    "sindrets/diffview.nvim", -- Integração para visualização de diffs

    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua", -- optional
    "echasnovski/mini.pick", -- optional
  },
  cmd = "Neogit", -- Comando para abrir o Neogit

  -- Configuração do Neogit
  opts = {
    signs = {
      hunk = { "", "" }, -- Personalização dos ícones para hunk
      item = { "", "" }, -- Ícones para itens do Git
      section = { "", "" }, -- Ícones para seções
    },
    integrations = {
      diffview = true, -- Habilita integração com o diffview
    },
  },

  -- Mapeamento de teclas
  keys = {
    -- Atalhos para o Neogit
    { "<leader>gg", "<cmd>Neogit<CR>", desc = "Git status" }, -- Abre o Neogit (status Git)
    { "<leader>gC", "<cmd>Neogit commit<CR>", desc = "Git commit" }, -- Abre a tela de commit do Neogit
    { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Git pull" }, -- Realiza um git pull
    { "<leader>gP", "<cmd>Neogit push<CR>", desc = "Git push" }, -- Realiza um git push
    { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches" }, -- Abre o Telescope para navegar entre branches
    { "<leader>gB", "<cmd>G blame<CR>", desc = "Git blame" }, -- Executa o git blame com Fugitive
  },
}
