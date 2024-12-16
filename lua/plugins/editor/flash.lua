return {
  "folke/flash.nvim",
  opts = {}, -- No additional options defined, you can customize here if needed
  vscode = true, -- Set to true to enable vscode integration (if applicable)

  keys = {
    -- Keybinding for Flash jump in Normal, Visual, and Operator modes
    {
      "s",
      mode = { "n", "x", "o" }, -- Enable in Normal, Visual, and Operator modes
      function()
        require("flash").jump {
          search = {
            mode = function(str)
              -- Search for the exact word (avoiding partial matches)
              return "\\<" .. str
            end,
          },
        }
      end,
      desc = "Flash", -- Description of the action
    },

    -- Keybinding for jumping to the current word
    {
      "<leader>*",
      function()
        require("flash").jump {
          pattern = vim.fn.expand "<cword>", -- Jump to the word under the cursor
        }
      end,
      desc = "Jump With Current Word", -- Description of the action
    },
  },
}
