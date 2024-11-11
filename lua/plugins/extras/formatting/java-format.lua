return {
  -- Configuração para o conform.nvim com o formatter para Java
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Adiciona o google-java-format para Java
      opts.formatters_by_ft.java = opts.formatters_by_ft.java or {}
      table.insert(opts.formatters_by_ft.java, "google-java-format")
      return opts
    end,
  },

  -- Configuração do mason.nvim para garantir que o google-java-format esteja instalado
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "google-java-format", -- Garantindo que o google-java-format esteja instalado
      },
    },
  },
}
