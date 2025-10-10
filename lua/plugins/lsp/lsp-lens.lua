-- lua/plugins/lsp/lsp-lens.lua :: Mostra informações de referências e implementações como "Code Lens".

-- lua/plugins/lsp/lsp-lens.lua :: Mostra informações de referências e implementações como "Code Lens".

return {
  "VidocqH/lsp-lens.nvim",
  event = "LspAttach",
  keys = {
    { "<leader>cl", function() require("lsp-lens").toggle() end,   desc = "LSP Lens: Toggle" },
    { "<leader>cL", function() require("lsp-lens").refresh() end,  desc = "LSP Lens: Refresh" },
  },
  opts = {
    enable = true,
    include_declaration = true,
    sections = {
      definition   = true,
      references   = true,
      implements   = true,
      git_authors  = true, -- Habilitado para emular o JetBrains.
    },
    ignore_filetype = {
      "TelescopePrompt", "snacks_dashboard", "oil", "NvimTree", "Trouble",
    },
  },
  config = function(_, opts) 
    local lens = require("lsp-lens")
    lens.setup(opts)

    -- Atualiza as lentes de forma mais sutil, como no JetBrains.
    local grp = vim.api.nvim_create_augroup("LspLensRefresh", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "BufWritePost" }, {
      group = grp,
      callback = function()
        pcall(lens.refresh)
      end,
    })
  end,
}
