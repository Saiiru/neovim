local nvim_0_10 = vim.fn.has "nvim-0.10"
local prefix = "<leader>cl"

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- Configuração dos atalhos LSP
      local lsp_keys = {
        { prefix .. "r", "<cmd>LspRestart<cr>", desc = "Restart Lsp" },
        { prefix .. "s", "<cmd>LspStart<cr>", desc = "Start Lsp" },
        { prefix .. "S", "<cmd>LspStop<cr>", desc = "Stop Lsp" },
        { prefix .. "a", vim.lsp.buf.add_workspace_folder, desc = "Add workspace" },
        { prefix .. "r", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace" },
        { "<leader>cil", "<cmd>LspInfo<cr>", desc = "Lsp" },
      }

      -- Adicionando os atalhos ao mapeamento
      for _, key in ipairs(lsp_keys) do
        keys[#keys + 1] = key
      end
    end,
    opts = {
      diagnostics = {
        virtual_text = {
          float = {
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }, -- bordas do float
          },
        },
      },
      inlay_hints = { enabled = nvim_0_10 },
      codelens = { enabled = false },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              hint = { enable = nvim_0_10, setType = nvim_0_10 },
            },
          },
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>cl", group = "lsp", icon = " " },
      },
    },
  },
}
