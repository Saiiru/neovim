-- ~/.config/nvim/lua/kora/plugins/overseer.lua
-- Overseer + which-key groups v3/v2
return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerRunCmd", "OverseerQuickAction", "OverseerToggle", "OverseerOpen" },
  opts = {
    templates = {
      "builtin", "python", "node", "go", "rust", "java", "spring", "arduino",
      {
        name = "Run in External Terminal",
        builder = function()
          local ok, runner = pcall(require, "kora.runner")
          if not ok then return nil end
          local ext = runner.external and runner.external("run") or nil
          if not ext then return nil end
          return { cmd = { "sh", "-c", ext }, name = "External Runner" }
        end,
        condition = {
          callback = function()
            local ok, runner = pcall(require, "kora.runner")
            return ok and type(runner.cmd) == "function" and runner.cmd("run") ~= nil
          end,
        },
      },
    },
  },
  config = function(_, opts)
    local ok, overseer = pcall(require, "overseer")
    if not ok then return end
    overseer.setup(opts)

    local map, o = vim.keymap.set, { noremap = true, silent = true }
    map("n", "<leader>rr", "<cmd>OverseerRun<cr>",                 vim.tbl_extend("force", o, { desc = "Run Task" }))
    map("n", "<leader>rl", "<cmd>OverseerRunCmd<cr>",              vim.tbl_extend("force", o, { desc = "Run Last/Ad-hoc" }))
    map("n", "<leader>rp", "<cmd>OverseerQuickAction open<cr>",    vim.tbl_extend("force", o, { desc = "Open Output" }))
    map("n", "<leader>re", function()
      local okr, runner = pcall(require, "kora.runner"); if okr and runner.external then runner.external("run") end
    end, vim.tbl_extend("force", o, { desc = "External Runner" }))

    map("n", "<leader>bb", function()
      local okr, runner = pcall(require, "kora.runner")
      if okr and runner.run_task then runner.run_task("build") else vim.cmd("OverseerRunCmd build") end
    end, vim.tbl_extend("force", o, { desc = "Build Project" }))

    map("n", "<leader>tt", function()
      local okr, runner = pcall(require, "kora.runner")
      if okr and runner.run_task then runner.run_task("test") else vim.cmd("OverseerRunCmd test") end
    end, vim.tbl_extend("force", o, { desc = "Test Project" }))

    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      if wk.add then
        wk.add({
          { "<leader>r", group = "Run" },
          { "<leader>b", group = "Build" },
          { "<leader>t", group = "Test/Tabs" },
        })
      else
        wk.register({
          r = { name = "Run" },
          b = { name = "Build" },
          t = { name = "Test/Tabs" },
        }, { prefix = "<leader>" })
      end
    end
  end,
}

