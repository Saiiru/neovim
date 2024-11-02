-- Defina a função dap_setup antes de usá-la
function dap_setup()
  local status, dap = pcall(require, 'dap')
  if not status then return end

  local status_ui, dapui = pcall(require, 'dapui')
  if not status_ui then return end

  local status_telescope, telescope = pcall(require, "telescope")
  if not status_telescope then return end

  -- Carregar a extensão do telescope
  telescope.load_extension("dap")

  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
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
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          "repl",
        },
        size = 0.25,
        position = "bottom",
      },
    },
    controls = {
      enabled = true,
      element = "repl",
      icons = {
        pause = "",
        play = "",
        step_into = "",
        step_over = "",
        step_out = "",
        step_back = "",
        run_last = "↻",
        terminate = "□",
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
    windows = { indent = 1 },
    render = {
      max_type_length = nil,
      max_value_lines = 100,
    },
  })

  dap.adapters = {
    codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/adapter/codelldb',
        args = { '--port', '${port}' }
      }
    }
  }

  dap.configurations.rust = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
  }
end

-- Configuração dos plugins
return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      dap_setup()
    end,
    keys = {
      { "<leader>6", ":lua require'dap'.continue()<CR>", desc = "Continue" },
      { "<leader>7", ":lua require'dap'.step_over()<CR>", desc = "Step Over" },
      { "<leader>8", ":lua require'dap'.step_into()<CR>", desc = "Step Into" },
      { "<leader>9", ":lua require'dap'.step_out()<CR>", desc = "Step Out" },
      { "<leader>;", ":lua require'dap'.toggle_breakpoint()<CR>", desc = "Toggle Breakpoint" },
      { "<leader>'", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", desc = "Set Conditional Breakpoint" },
      { "<leader>i", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", desc = "Set Log Point" },
      { "<leader>d", ":lua require'dapui'.toggle()<CR>", desc = "Toggle DAP UI" },
      { "<leader><leader>d", ":lua require'dapui'.eval()<CR>", desc = "Evaluate Expression" },
    },
    dependencies = { "rcarriga/nvim-dap-ui", 'nvim-telescope/telescope.nvim' },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter' },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  -- {
  --   'simrat39/rust-tools.nvim',
  --   ft = { 'rust' },
  -- }

}

