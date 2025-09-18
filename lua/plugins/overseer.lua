-- lua/plugins/overseer.lua
return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerOpen","OverseerClose","OverseerToggle","OverseerInfo","OverseerRun","OverseerRunCmd","OverseerBuild","OverseerQuickAction","OverseerTaskAction","OverseerSaveBundle","OverseerLoadBundle","OverseerDeleteBundle","OverseerClearCache" },
    keys = {
      { "<F3>", function() require("overseer").run_template({ name = "Java: Auto (Gradle/Maven/Javac) [tmux/local]", params = { task = "run", skip_tests = true, where = "auto" } }) end, desc = "Run (auto)" },
      { "<S-F3>", function() require("overseer").run_template({ name = "Java: Auto (Gradle/Maven/Javac) [tmux/local]", params = { task = "build", skip_tests = true, where = "auto" } }) end, desc = "Build (auto)" },
      { "<F4>", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle list" },
      { "<leader>RB", "<cmd>OverseerBuild<cr>", desc = "Task: Build from templates" },
      { "<leader>Rr", function() pcall(require("overseer").run_last) end, desc = "Task: Run last" },
      { "<leader>Rs", function() pcall(require("overseer").stop_all) end, desc = "Task: Stop all" },
    },
    opts = {
      strategy = { "terminal", direction = "horizontal", open_on_start = true, close_on_exit = false },
      task_list = { direction = "bottom", min_height = 12, max_height = 16, default_detail = 1, bindings = { q = "Close", ["<esc>"] = "Close" } },
      templates = { "builtin" }, -- não listar custom aqui
      components = { "default", { "on_output_summarize", max_lines = 4 }, "on_exit_set_status", { "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } } },
    },
    config = function(_, opts)
      require("overseer").setup(opts)
      -- Carregar templates custom (registram e pronto)
      pcall(require, "overseer.template.langs.runner.templates")
      vim.api.nvim_create_user_command("OverseerReloadKora", function()
        package.loaded["overseer.template.langs.runner.templates"] = nil
        require("overseer").clear_cache()
        pcall(require, "overseer.template.langs.runner.templates")
        vim.notify("Kora templates reloaded")
      end, {})
    end,
  },
  { "Zeioth/compiler.nvim", dependencies = { "stevearc/overseer.nvim" }, cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo", "CompilerStop" }, opts = { compile_on_save = false }, keys = {
      { "<leader>co", "<cmd>CompilerOpen<cr>", desc = "Compiler: Open panel" },
      { "<leader>cr", function() vim.cmd "CompilerStop" vim.cmd "CompilerRedo" end, desc = "Compiler: Redo last" },
      { "<leader>ct", "<cmd>CompilerToggleResults<cr>", desc = "Compiler: Toggle results" },
    }, },
}
