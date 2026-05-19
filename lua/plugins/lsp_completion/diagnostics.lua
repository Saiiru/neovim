return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  opts = function(_, opts)
    vim.diagnostic.config({
      virtual_text = false,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "single",
        source = "if_many",
        focusable = false,
        header = "",
        prefix = "",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      },
    })

    return opts
  end,
}
