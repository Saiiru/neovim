-- Deubgger configuration
return {
  {
    -- Debug adapter protocol support
    "mfussenegger/nvim-dap",
    lazy = true,
    enabled = true,
    keys = {

      { "<F3>",    mode = "n", "<cmd>DapVirtualTextForceRefresh<cr>",                                                desc = "Refresh Virtual Text" },
      { "<F4>",    mode = "n", "<cmd>lua require('dap').run_last()<cr>",                                             desc = "Run Last" },
      { "<F5>",    mode = "n", "<cmd>lua require('dap').continue()<cr>",                                             desc = "Continue" },
      { "<F6>",    mode = "n", "<cmd>lua require('dap').run_to_cursor()<cr>",                                        desc = "Run To Cursor" },
      { "<F7>",    mode = "n", "<cmd>lua require('dap').pause()<cr>",                                                desc = "Pause" },
      { "<F8>",    mode = "n", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "Conditional Breakpoint" },
      { "<F9>",    mode = "n", "<cmd>lua require('dap').toggle_breakpoint()<cr>",                                    desc = "le Breakpoint" },
      { "<F10>",   mode = "n", "<cmd>lua require('dap').step_out()<cr>",                                             desc = "Step Out" },
      { "<C-F10>", mode = "n", "<cmd>lua require('dap').step_into()<cr>",                                            desc = "Step In" },
      { "<F12>",   mode = "n", "<cmd>lua require('dap').step_over()<cr>",                                            desc = "Step Overer" }
    },
    dependencies = {
      {
        "nvim-neotest/nvim-nio",
      },
      {
        -- Debugger GUI
        "rcarriga/nvim-dap-ui",
        keys ={
        { '<leader>k', mode = 'n', "<cmd>lua require('dapui').eval()<CR>", desc = "Eval" },
        { "<F2>", mode = "n", "<cmd>lua require('dapui').toggle()<cr>", desc = "Dap UI" },
      },

        config = function()
          local dap = require("dap")
          local dapui = require("dapui")

          dapui.setup({
            icons = { expanded = "▾", collapsed = "▸" },
            mappings = {
              -- Use a table to apply multiple mappings
              expand = { "<CR>", "<2-LeftMouse>" },
              open = "o",
              remove = "d",
              edit = "e",
              repl = "r",
              toggle = "t",
            },
            expand_lines = vim.fn.has("nvim-0.7"),
            layouts = {
              {
                elements = {
                  -- Elements can be strings or table with id and size keys.
                  { id = "scopes", size = 0.25 },
                  "breakpoints",
                  "stacks",
                  "watches",
                },
                size = 40, -- 40 columns
                position = "left",
              },
              {
                elements = {
                  { id = "repl",    size = 0.50 },
                  { id = "console", size = 0.50 },
                },
                size = 0.25, -- 25% of total lines
                position = "bottom",
              },
            },
            floating = {
              max_height = nil,  -- These can be integers or a float between 0 and 1.
              max_width = nil,   -- Floats will be treated as percentage of your screen.
              border = "single", -- Border style. Can be "single", "double" or "rounded"
              mappings = {
                close = { "q", "<Esc>" },
              },
            },
            windows = { indent = 1 },
            render = {
              max_type_length = nil, -- Can be integer or nil.
            }
          })

          dap.defaults.fallback.exception_breakpoints = { 'raised', 'uncaught' }
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        end,
      },
      {
        -- Debugger virtual text
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          commented = false,
          virt_text_pos = "eol",
          all_frames = false,
          virt_lines = false,
          virt_text_win_col = nil,
        }
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        lazy = true,
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_installation = true,

          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},

          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
          },
        },
      },
      {
        "LiadOz/nvim-dap-repl-highlights",
        config = true
      },
    }
  },
}
