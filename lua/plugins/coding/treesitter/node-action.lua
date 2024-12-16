return {
  "ckolkey/ts-node-action", -- Plugin for performing actions on TypeScript nodes
  dependencies = { "nvim-treesitter" }, -- Requires nvim-treesitter for AST analysis
  vscode = true, -- Ensures the plugin emulates some Visual Studio Code behaviors

  -- Plugin options (empty for now but could be expanded later)
  opts = {},

  -- Key mappings
  keys = {
    {
      "J", -- Keybinding for the action
      "<cmd>NodeAction<cr>", -- Executes the NodeAction command
      mode = "n", -- Normal mode only
      desc = "Perform Node Action", -- Descriptive name for the keybinding
    },

    -- Optional: Add more key mappings for other actions as needed
    -- Example:
    -- {
    --   "<leader>na",
    --   "<cmd>NodeAction<cr>",
    --   mode = "n",
    --   desc = "Trigger Node Action"
    -- },
  },
}
