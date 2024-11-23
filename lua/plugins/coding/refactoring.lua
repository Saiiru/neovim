return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>d", group = "debug", icon = "" },
        { "<leader>r", group = "refactoring", icon = "" },
      },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", vscode = true },
      { "nvim-treesitter/nvim-treesitter" },
    },
    opts = {
      -- Configurações gerais
      show_success_message = true,
      prompt_func_return_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
    },
    keys = {
      -- Menu de refatoração
      {
        "<leader>rm",
        function()
          require("refactoring").select_refactor()
        end,
        mode = { "n", "x" },
        desc = "Refactoring Menu",
      },
      {
        "<leader>re",
        function()
          require("refactoring").refactor("Extract Function")
        end,
        mode = "x",
        desc = "Extract Function",
      },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor("Extract Function To File")
        end,
        mode = "x",
        desc = "Extract Function To File",
      },
      {
        "<leader>rv",
        function()
          require("refactoring").refactor("Extract Variable")
        end,
        mode = "x",
        desc = "Extract Variable",
      },
      {
        "<leader>ri",
        function()
          require("refactoring").refactor("Inline Variable")
        end,
        mode = { "n", "x" },
        desc = "Inline Variable",
      },
      {
        "<leader>rI",
        function()
          require("refactoring").refactor("Inline Function")
        end,
        mode = "n",
        desc = "Inline Function",
      },
      {
        "<leader>rb",
        function()
          require("refactoring").refactor("Extract Block")
        end,
        mode = "n",
        desc = "Extract Block",
      },
      {
        "<leader>rB",
        function()
          require("refactoring").refactor("Extract Block To File")
        end,
        mode = "n",
        desc = "Extract Block To File",
      },
      -- Debugging
      {
        "<leader>dv",
        function()
          require("refactoring").debug.print_var({ show_success_message = true, below = true })
        end,
        mode = { "n", "x" },
        desc = "Print Variable Below",
      },
      {
        "<leader>dV",
        function()
          require("refactoring").debug.print_var({ show_success_message = true, below = false })
        end,
        mode = { "n", "x" },
        desc = "Print Variable Above",
      },
      {
        "<leader>dc",
        function()
          require("refactoring").debug.cleanup({ force = true, show_success_message = true })
        end,
        mode = "n",
        desc = "Clear Debugging",
      },
    },
  },
}
