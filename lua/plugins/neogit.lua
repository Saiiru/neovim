-- Plugin do Neogit
return {
  "NeogitOrg/neogit", -- Principal plugin para Neogit
  dependencies = {
    "nvim-lua/plenary.nvim", -- Biblioteca de utilitários
    "sindrets/diffview.nvim", -- Integração para visualização de diffs
    "nvim-telescope/telescope.nvim", -- Opcional: Telescope para navegação e busca
    "ibhagwan/fzf-lua", -- Opcional: Integração com FZF para pesquisa fuzzy
    "echasnovski/mini.pick", -- Opcional: Mini picker para UI
  },
  cmd = "Neogit", -- Comando para abrir o Neogit

  opts = {
    signs = {
      hunk = { "", "" }, -- Personalização dos ícones para hunks
      item = { "", "" }, -- Ícones para itens no status do Git
      section = { "", "" }, -- Ícones para seções no Neogit
    },
    integrations = {
      diffview = true, -- Habilita a integração com o diffview
    },
  },

  -- Mapeamento de teclas para comandos do Neogit
  keys = {
    { "<leader>gs", "<cmd>Neogit<CR>", desc = "Git status" }, -- Abre o status do Neogit
    { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Git commit" }, -- Abre o commit do Neogit
    { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Git pull" }, -- Realiza o git pull
    { "<leader>gP", "<cmd>Neogit push<CR>", desc = "Git push" }, -- Realiza o git push
    { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches" }, -- Lista as branches via Telescope
    { "<leader>gB", "<cmd>G blame<CR>", desc = "Git blame" }, -- Realiza o git blame com Fugitive
  },
}
