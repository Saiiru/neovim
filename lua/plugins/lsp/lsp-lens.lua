return {
  "VidocqH/lsp-lens.nvim",
  event = "LspAttach",
  keys = {
    { "<leader>cl", function() require("lsp-lens").toggle() end,   desc = "LSP Lens: Toggle" },
    { "<leader>cL", function() require("lsp-lens").refresh() end,  desc = "LSP Lens: Refresh" },
  },
  opts = {
    enable = true,
    include_declaration = true,     -- mostra contagem considerando declarações
    sections = {
      definition   = true,          -- exibe “def” (defs)
      references   = true,          -- exibe “ref” (referências)
      implements   = true,          -- exibe “impl” (implementações)
      git_authors  = false,         -- pode habilitar se quiser autor por linha
    },
    ignore_filetype = {
      "TelescopePrompt", "snacks_dashboard", "oil", "NvimTree", "Trouble",
    },
  },
  config = function(_, opts)
    local lens = require("lsp-lens")
    lens.setup(opts)

    -- Refresh ao mexer no buffer (bom para Java, Python, TS/JS, Go, C/C++)
    local grp = vim.api.nvim_create_augroup("LspLensRefresh", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave", "TextChanged", "LspAttach" }, {
      group = grp,
      callback = function()
        pcall(lens.refresh)
      end,
    })
  end,
}

