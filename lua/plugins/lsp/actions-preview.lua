return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- Append key mappings for code actions and Glance commands
      table.insert(keys, {
        "<leader>ca",
        function()
          require("actions-preview").code_actions()
        end,
        mode = { "n", "v" },
        desc = "Code Action Preview",
      })
      table.insert(keys, { "gr", "<cmd>Glance references<cr>", desc = "Goto References" })
      table.insert(keys, { "gy", "<cmd>Glance type_definitions<cr>", desc = "Goto Type Definitions" })
      table.insert(keys, { "gI", "<cmd>Glance implementations<cr>", desc = "Goto Implementations" })

      -- Return updated opts (keys are modified externally)
      return { keys = keys }
    end,
  },
  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    opts = {
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.6,
          height = 0.7,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines)
            return max_lines - 15
          end,
        },
      },
    },
  },
}
