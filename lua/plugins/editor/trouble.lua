return {
  "folke/trouble.nvim",

  opts = {
    -- Define custom key mappings for the plugin
    keys = {
      -- Jump to the item (e.g., jump to the diagnostic or location)
      e = "jump",

      -- Fold/Unfold actions for diagnostics list
      l = "fold_open", -- Open a fold
      L = "fold_open_recursive", -- Open fold recursively
      h = "fold_close", -- Close a fold
      H = "fold_close_recursive", -- Close fold recursively
    },

    -- Modes configuration for specific use cases
    modes = {
      test = {
        -- Set mode to show diagnostics
        mode = "diagnostics",

        -- Preview configuration for diagnostics
        preview = {
          type = "split", -- Split window for preview
          relative = "win", -- Position relative to the current window
          position = "right", -- Position preview to the right
          size = 0.3, -- Set the size of the preview window (30% of the screen width)
        },
      },
    },
  },
}
