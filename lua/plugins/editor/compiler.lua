return {
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},

    -- Key bindings for the Compiler plugin
    keys = {
      { "<F3>", "<cmd>CompilerOpen<CR>", desc = "Open Compiler" },
      {
        "<S-F3>",
        function()
          vim.cmd "CompilerStop"
          vim.cmd "CompilerRedo"
        end,
        desc = "Redo Compiler",
      },
      { "<F4>", "<cmd>CompilerToggleResults<CR>", desc = "Toggle Compiler Results" },
    },
  },

  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerClearCache",
    },

    opts = {
      -- Configure the task list window
      task_list = {
        direction = "bottom", -- Position the task list at the bottom of the window
        min_height = 15, -- Minimum height for the task list
        max_height = 15, -- Maximum height for the task list
        default_detail = 1, -- Default task detail level
      },
    },
  },
}
