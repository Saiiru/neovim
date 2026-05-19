-- ================================================================================================
-- TITLE : nvim-dap + nvim-dap-ui
-- ABOUT : Debugger base com UI automática para abrir/fechar painéis.
-- LINKS :
--   > dap    : https://github.com/mfussenegger/nvim-dap
--   > dap-ui : https://github.com/rcarriga/nvim-dap-ui
-- ================================================================================================

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "DAP REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI Toggle" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio", "mfussenegger/nvim-dap" },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)

      dap.listeners.before.attach.dapui_auto = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_auto = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_auto = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_auto = function()
        dapui.close()
      end
    end,
  },
}
