return {
  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    opts = { focus = true, warn_no_results = false },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Workspace)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (Buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    opts = {},
    config = function()
      local signs = {
        Error = " ", Warn = " ", Hint = "󰌵 ", Info = " ",
      }
      for type, icon in pairs(signs) do
        vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
      end
      vim.diagnostic.config({
        virtual_text = { spacing = 2, prefix = "●" },
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = true,
        update_in_insert = false,
      })
    end,
  },
}

