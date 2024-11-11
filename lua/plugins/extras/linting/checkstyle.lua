return {
  -- Configuração para o mason.nvim, garantindo que o CheckStyle e o SpotBugs estejam instalados
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "checkstyle", -- CheckStyle, para linting baseado em estilo de código
        "spotbugs", -- SpotBugs, para análise de bugs e qualidade do código
      },
    },
  },

  -- Configuração para o nvim-lint, adicionando CheckStyle e SpotBugs para Java
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft.java = opts.linters_by_ft.java or {}

      -- Adiciona o CheckStyle e SpotBugs para linting de código Java
      table.insert(opts.linters_by_ft.java, "checkstyle")
      table.insert(opts.linters_by_ft.java, "spotbugs")

      return opts
    end,
  },
}
