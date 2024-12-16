return {
  -- LazyVim DAP core import
  { import = "lazyvim.plugins.extras.dap.core" },

  -- DAP Plugin Configuration
  {
    "mfussenegger/nvim-dap",
    opts = {
      defaults = {
        fallback = {
          external_terminal = {
            command = "/usr/bin/kitty",
            args = { "--class", "kitty-dap", "--hold", "--detach", "nvim-dap", "-c", "DAP" },
          },
        },
      },
    },
    -- Key mappings for DAP functionality
    -- stylua: ignore
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step out" },
      { "<F2>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle breakpoint" },
      { "<S-F2>", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    },
  },

  -- Neotest Plugin Configuration (Optional)
  {
    "nvim-neotest/neotest",
    optional = true,
    -- Key mapping for running the last test with DAP strategy
    -- stylua: ignore
    keys = {
      { "<leader>tL", function() require("neotest").run.run_last({ strategy = "dap" }) end, desc = "Debug Last Test" },
    },
  },
}
