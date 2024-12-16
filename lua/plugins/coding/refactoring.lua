return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" }, -- Utilities for Lua functions
    { "nvim-treesitter/nvim-treesitter" }, -- Treesitter for syntax parsing
  },
  opts = {
    -- Enable feedback messages
    show_success_message = true,
    -- You could add more options here if needed (e.g., custom popup messages)
  },
  -- Stylua: ignore formatting for keybindings section
  -- Keymaps for refactoring and debugging
  keys = {
    -- Refactoring: Select refactor action
    {
      "<leader>cR",
      function()
        require("refactoring").select_refactor()
      end,
      mode = { "n", "x", "v" },
      desc = "Select Refactor Action",
    },

    -- Debugging: Print variable value
    {
      "<leader>dv",
      function()
        require("refactoring").debug.print_var()
      end,
      mode = { "n", "x", "v" },
      desc = "Print Variable Value",
    },

    -- Debugging: Clean up printed variables
    {
      "<leader>dr",
      function()
        require("refactoring").debug.cleanup()
      end,
      desc = "Remove Printed Variables",
    },

    -- Add additional refactor options here
    -- You could add more refactoring options with similar key mappings
  },
}
