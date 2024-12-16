local prefix = "<leader>db"

return {
  -- DAP Plugin Configuration with Persistent Breakpoints
  {
    "mfussenegger/nvim-dap",
    optional = true,
    vscode = false,
    dependencies = {
      "Weissle/persistent-breakpoints.nvim",
      vscode = false,
      event = "LazyFile",
      -- Keymaps for breakpoint management
      keys = {
        { prefix .. "d", "<cmd>PBClearAllBreakpoints<cr>", desc = "Delete All Breakpoints" },
        { prefix .. "B", "<cmd>PBSetConditionalBreakpoint<cr>", desc = "Breakpoint Condition" },
        { prefix .. "b", "<cmd>PBToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
        { "<F2>", "<cmd>PBToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
      },
      opts = {
        load_breakpoints_event = { "BufReadPost" },
      },
    },
    -- Disable default key mappings from nvim-dap
    keys = {
      { "<F2>", false },
      { "<leader>dB", false },
    },
  },

  -- Which-key Plugin Configuration for Breakpoints
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { prefix, group = "breakpoints", icon = " " }, -- Adding icon and group for clarity
      },
    },
  },
}
