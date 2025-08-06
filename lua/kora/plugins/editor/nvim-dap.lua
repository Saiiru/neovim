
  -- ═════════════════════════════════════════════════════════════════════════
  --  DEBUG ADAPTER PROTOCOL - DEBUGGING MATRIX
  -- ═════════════════════════════════════════════════════════════════════════
-- DEBUG ADAPTER PROTOCOL (DAP):
-- <F5>                         -- Iniciar/continuar debug
-- <F1>                         -- Step into (entrar na função)
-- <F2>                         -- Step over (pular linha)
-- <F3>                         -- Step out (sair da função)
-- <leader>b                    -- Toggle breakpoint
-- <leader>B                    -- Breakpoint condicional
-- <F7>                         -- Toggle debug UI
--
-- No debug UI:
-- <CR>                         -- Expandir/entrar item
-- o                            -- Abrir item
-- d                            -- Remover item
-- e                            -- Editar valor
-- r                            -- REPL (console interativo)
-- t                            -- Toggle item
  return {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "nvim-neotest/nvim-nio" },
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
          require("mason-nvim-dap").setup({
            ensure_installed = {
              "codelldb", "python", "js-debug-adapter", "java-debug-adapter",
            },
            automatic_setup = true,
            automatic_installation = true,
          })
        end,
      },
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = " Debug: Start/Continue" },
      { "<F1>", function() require("dap").step_into() end, desc = " Debug: Step Into" },
      { "<F2>", function() require("dap").step_over() end, desc = " Debug: Step Over" },
      { "<F3>", function() require("dap").step_out() end, desc = " Debug: Step Out" },
      { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = " Debug: Toggle Breakpoint" },
      { "<leader>B", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = " Debug: Set Breakpoint" },
      { "<F7>", function() require("dapui").toggle() end, desc = " Debug: Toggle UI" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Virtual text inline comments
      require("nvim-dap-virtual-text").setup({
        commented = true,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value
          else
            return variable.name .. ' = ' .. variable.value
          end
        end,
      })

      -- DAP UI configuration
      dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      -- Auto open/close UI hooks
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      -- Adapter configurations
      -- Python
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.exepath("python") or "python",
        args = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
          end,
        },
      }

      -- C/C++/Rust
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.exepath("codelldb"),
          args = { "--port", "${port}" },
        },
      }
      local codelldb_conf = {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      }
      dap.configurations.cpp = { codelldb_conf }
      dap.configurations.c = { codelldb_conf }
      dap.configurations.rust = { codelldb_conf }

      -- Go
      dap.adapters.go = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.exepath("dlv"),
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }
      dap.configurations.go = {
        {
          type = "go",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
      }

      -- JavaScript/TypeScript
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }
      for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  }

