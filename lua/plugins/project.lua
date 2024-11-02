return {
  -- Plugin para gerenciamento de projetos e navegação automática
  {
    "ahmedkhalf/project.nvim",
    event = "User BaseDefered",
    cmd = "ProjectRoot",
    opts = {
      -- Padrões para encontrar o diretório raiz do projeto
      patterns = {
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
        "package.json",
        ".solution",
        ".solution.toml"
      },
      -- Diretórios a serem excluídos da listagem de projetos
      exclude_dirs = {
        "~/", -- exclui o diretório home
      },
      silent_chdir = true, -- Muda para o diretório do projeto em silêncio
      manual_mode = false,  -- Modo manual desativado, mude automaticamente

      -- Exclui certos buffers de mudar de diretório
      exclude_chdir = {
        filetype = { "OverseerList", "alpha" }, -- exclui tipos de arquivo específicos
        buftype = { "nofile", "terminal" },      -- exclui buffers sem arquivos e terminais
      },
    },
    config = function(_, opts)
      require("project_nvim").setup(opts) -- Configuração do plugin
    end,
  },
}

