-- ~/.config/nvim/init.lua ou ~/.config/nvim/lua/plugins.lua

return {
  -- Plugin: Compiler.nvim
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},
    -- Mapeamentos recomendados
    keys = {
      { "<F6>", "<cmd>CompilerOpen<cr>", desc = "Open Compiler" },
      {
        "<S-F6>",
        function()
          vim.cmd("CompilerStop")
          vim.cmd("CompilerRedo")
        end,
        desc = "Redo Compiler",
      },
      { "<S-F7>", "<cmd>CompilerToggleResults<cr>", desc = "Toggle Compiler Results" },
    },
  },

  -- Plugin: Overseer.nvim
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
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
    },
  },
}
