return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 200,
    win = { border = "rounded" },
    layout = { align = "center" },
    icons = {
      group = " ",
      separator = "  ",
      rules = false,
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.add({
      { "<leader>f", group = "Find " },
      { "<leader>c", group = "Code 󰅩" },
      { "<leader>d", group = "Diagnostics 󰒡" },
      { "<leader>x", group = "Trouble 󱇧" },
      { "<leader>g", group = "Git 󰊢" },
      { "<leader>t", group = "Test/DAP 󰙨" },
      { "<leader>m", group = "Format 󰉢" },
      { "<leader>u", group = "UI 󱎕" },
      { "<leader>w", group = "Worktree 󰘬" },
      { "<leader>p", group = "Project 󰂺" },
      { "<leader>a", group = "AI 󰚩" },
      { "<leader>e", group = "Explorer 󰙅" },
    })
  end,
}

