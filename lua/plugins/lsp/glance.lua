return {
  -- nvim-lspconfig configuration
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- Add additional key mappings for Glance
      keys[#keys + 1] = { "gd", "<cmd>Glance definitions<cr>", desc = "Goto Definitions" }
      keys[#keys + 1] = { "gr", "<cmd>Glance references<cr>", desc = "Goto References" }
      keys[#keys + 1] = { "gy", "<cmd>Glance type_definitions<cr>", desc = "Goto Type Definitions" }
      keys[#keys + 1] = { "gI", "<cmd>Glance implementations<cr>", desc = "Goto Implementations" }

      return keys
    end,
  },

  -- Glance.nvim configuration
  {
    "dnlhc/glance.nvim",
    cmd = { "Glance" }, -- This triggers Glance when called
    event = "LspAttach", -- Activate on LSP attach event
    opts = {
      border = {
        enable = true, -- Enable window border for Glance results
      },
      use_trouble_qf = true, -- Use Trouble's quickfix window for Glance results
      hooks = {
        before_open = function(results, open, jump, method)
          -- Handle results before opening Glance window
          local uri = vim.uri_from_bufnr(0)
          if #results == 1 then
            local target_uri = results[1].uri or results[1].targetUri
            -- If result is in the same file, directly jump
            if target_uri == uri then
              jump(results[1])
            else
              open(results) -- Open Glance window if in a different file
            end
          else
            open(results) -- Open Glance window if there are multiple results
          end
        end,
      },
    },
  },
}
