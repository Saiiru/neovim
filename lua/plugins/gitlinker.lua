return {
  "linrongbin16/gitlinker.nvim",
  cmd = "GitLink", -- Comando para chamar o plugin
  dependencies = { "nvim-lua/plenary.nvim" }, -- Dependência necessária
  opts = {}, -- Aqui você pode colocar suas configurações personalizadas (por exemplo, escolher o host Git)
  keys = {
    { "<leader>gy", "<cmd>GitLink<cr>", desc = "Yank git link" }, -- Atalho para gerar e copiar o link do Git
  },
}
