return {
  {
    "stevearc/oil.nvim", -- Oil.nvim plugin for file management
    opts = { -- Plugin options (currently empty)
      -- You can add your specific options here in the future
    },
    keys = { -- Key mappings for the plugin
      {
        "-", -- Key to open parent directory
        function() -- Function to execute on key press
          require("oil").open() -- Open the parent directory using Oil
        end,
        desc = "Open parent directory", -- Description for the key mapping
      },
    },
    dependencies = { -- Dependencies for the plugin
      "nvim-tree/nvim-web-devicons", -- Required for file icons
    },
  },
}
