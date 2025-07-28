-- ~/.config/nvim/lua/sairu/plugins/dap.lua
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
            "codelldb",
            "python",
            "js-debug-adapter",
            "java-debug-adapter",
          },
          automatic_setup = true,
          automatic_installation = true,
        })
      end,
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Virtual text inline comments
    require("nvim-dap-virtual-text").setup({ commented = true })

    -- DAP UI panel layout (sensory HUD)
    dapui.setup({
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
      floating = { border = "rounded" },
    })

    -- Auto open/close UI hooks on debug lifecycle events
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- Adapter configurations

    -- Python debug adapter
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
          return vim.fn.exepath("python3") or "python"
        end,
      },
    }

    -- C/C++/Rust via codelldb
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

    -- Go debug adapter via delve
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

    -- JS/TS adapter using vscode-js-debug (pwa-node)
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

    -- Keymap bindings — streamlined debug control matrix
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true, desc = "DAP" }

    keymap("n", "<F5>", dap.continue, vim.tbl_extend("force", opts, { desc = "Continue" }))
    keymap("n", "<F10>", dap.step_over, vim.tbl_extend("force", opts, { desc = "Step Over" }))
    keymap("n", "<F11>", dap.step_into, vim.tbl_extend("force", opts, { desc = "Step Into" }))
    keymap("n", "<F12>", dap.step_out, vim.tbl_extend("force", opts, { desc = "Step Out" }))
    keymap("n", "<leader>b", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "Toggle Breakpoint" }))
    keymap("n", "<leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, vim.tbl_extend("force", opts, { desc = "Conditional Breakpoint" }))
    keymap("n", "<leader>lp", function()
      dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end, vim.tbl_extend("force", opts, { desc = "Log Point" }))
    keymap("n", "<leader>dr", dap.repl.open, vim.tbl_extend("force", opts, { desc = "Open REPL" }))
    keymap("n", "<leader>dl", dap.run_last, vim.tbl_extend("force", opts, { desc = "Run Last" }))
  end,
}

