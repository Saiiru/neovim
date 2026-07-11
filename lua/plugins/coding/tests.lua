return {
  { "nvim-neotest/nvim-nio", lazy = false },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rcasia/neotest-bash",
      "nvim-neotest/neotest-python",
    },
    lazy = true,
    cmd = { "Neotest" },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Test nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file" },
      { "<leader>ta", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Test all in cwd" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test output panel" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Test watch file" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Test stop" },
    },
    config = function()
      local adapters = {}
      local ok_python, neotest_python = pcall(require, "neotest-python")
      if ok_python then
        table.insert(adapters, neotest_python({
          dap = nil,
          runner = "pytest",
          python = vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or nil,
        }))
      end
      local ok_bash, neotest_bash = pcall(require, "neotest-bash")
      if ok_bash then table.insert(adapters, neotest_bash) end

      require("neotest").setup({
        adapters = adapters,
        discovery = { enabled = true, concurrent = 1 },
        running = { concurrent = true },
        summary = { enabled = true, animated = false, follow = true, expand_errors = true },
        output = { enabled = true, open_on_run = "short" },
        output_panel = { enabled = true, open = "botright split | resize 15" },
        quickfix = { enabled = true, open = false },
        status = { enabled = true, signs = true, virtual_text = false },
        icons = {
          passed = "",
          failed = "",
          running = "󰜎",
          skipped = "",
          unknown = "",
        },
      })
    end,
  },
}
