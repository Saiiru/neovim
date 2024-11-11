return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.java = opts.formatters_by_ft.java or {}
      table.insert(opts.formatters_by_ft.java, "google-java-format")
      return opts
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "google-java-format", -- Garantindo que o google-java-format esteja instalado
      },
    },
  },
}
