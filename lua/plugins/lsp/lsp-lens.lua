-- Contadores inline de refs/impl/etc + ações
return {
  "VidocqH/lsp-lens.nvim",
  event = "LspAttach",
  opts = {
    enable = true,
    include_declaration = true,
    sections = {
      definition = true,
      references = true,
      implements = true,
      typedefs = true,
    },
    ignore_filetype = { "markdown", "gitcommit" },
  },
  config = function(_, opts)
    local lens = require("lsp-lens")
    lens.setup(opts)
    -- atalhos
    vim.keymap.set("n", "<leader>lL", function() lens.toggle() end, { desc = "LSP Lens Toggle" })
    vim.keymap.set("n", "<leader>lR", function() lens.refresh() end, { desc = "LSP Lens Refresh" })
  end,
}

