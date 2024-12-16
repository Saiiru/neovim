return {
  "nvim-neo-tree/neo-tree.nvim",
  optional = true, -- Optional plugin, can be lazy-loaded
  dependencies = {
    {
      "antosha417/nvim-lsp-file-operations",
      opts = {}, -- You can add specific options for the plugin here if necessary
    },
  },
  config = function()
    -- You can set up additional configuration for Neo-tree here if needed
    require("neo-tree").setup {
      -- Your configuration options for neo-tree
      filesystem = {
        follow_current_file = true, -- Follow the current file in the tree
        group_empty = true, -- Group empty directories together
      },
      window = {
        width = 30, -- Set the window width for neo-tree
        mappings = {
          ["<space>"] = "toggle_node", -- Space to toggle node
        },
      },
    }
  end,
}
