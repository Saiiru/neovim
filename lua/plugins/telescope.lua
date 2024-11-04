return {
  "nvim-telescope/telescope-file-browser.nvim",
  keys = {
    {
      "<leader>sB",
      ":Telescope file_browser path=%:p:h=%:p:h<cr>",
      desc = "Browse Files",
    },
  },
  config = function()
    require("telescope").load_extension("file_browser")
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {
          "%.undo$", -- Ignora arquivos de undo
          "%.swp$", -- Ignora arquivos temporários
          "%.bak$", -- Ignora arquivos de backup
          "%.tmp$", -- Ignora arquivos temporários adicionais
          "^/home/sairu/.config/nvim/.undo",
        },
        -- Outras configurações
      },
    })
  end,
}
