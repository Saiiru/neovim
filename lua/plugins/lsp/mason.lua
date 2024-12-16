return {
  "williamboman/mason.nvim",
  keys = {
    -- Disable <leader>cm keybinding
    { "<leader>cm", false, desc = "Disabled Keybinding" },

    -- Add <leader>cim to open Mason
    { "<leader>cim", "<cmd>Mason<cr>", desc = "Open Mason" },
  },
}
