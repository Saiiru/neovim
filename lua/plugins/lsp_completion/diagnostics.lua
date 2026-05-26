return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  opts = function(_, opts)
    -- A política global vive em config.lsp_diagnostic.
    return opts
  end,
}
