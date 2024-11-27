local get_git_diff = function(staged)
  local cmd = staged and "git diff --staged" or "git diff"
  local handle = io.popen(cmd)
  if not handle then return "" end
  local result = handle:read("*a")
  handle:close()
  return result
end

local prompts = {
  Explain = "Explain how this code works.",
  Review = "Review this code and suggest improvements.",
  Tests = "Generate unit tests for the following code.",
  Refactor = "Refactor this code to improve readability.",
  FixCode = "Fix this code to work as intended.",
  FixError = "Explain this error and provide a solution.",
  BetterNamings = "Provide better names for these variables and functions.",
  Documentation = "Generate documentation for this code.",
}

local M = {
  { import = "sairu.plugins.extras.copilot-vim" },
  { import = "sairu.plugins.extras.codecompanion" },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    version = "1.9.1",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      show_help = "yes",
      prompts = prompts,
      debug = false,
      disable_extra_info = "no",
      hide_system_prompt = "yes",
      proxy = "",
    },
    build = function()
      vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    event = "VeryLazy",
    keys = {
      { "<leader>ah", function() require("CopilotChat.code_actions").show_help_actions() end, desc = "CopilotChat - Help actions" },
      { "<leader>ap", function() require("CopilotChat.code_actions").show_prompt_actions() end, desc = "CopilotChat - Prompt actions" },
      { "<leader>ap", ":lua require('CopilotChat.code_actions').show_prompt_actions(true)<CR>", mode = "x", desc = "CopilotChat - Prompt actions" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
      { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
      { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
      { "<leader>av", ":CopilotChatVisual", mode = "x", desc = "CopilotChat - Open in vertical split" },
      { "<leader>ax", ":CopilotChatInPlace<cr>", mode = "x", desc = "CopilotChat - Run in-place code" },
      { "<leader>ai", function()
          local input = vim.fn.input("Ask Copilot: ")
          if input ~= "" then vim.cmd("CopilotChat " .. input) end
        end, desc = "CopilotChat - Ask input" },
      { "<leader>am", function()
          local diff = get_git_diff()
          if diff ~= "" then
            vim.fn.setreg('"', diff)
            vim.cmd("CopilotChat Write commit message for the change with commitizen convention.")
          end
        end, desc = "CopilotChat - Generate commit message for all changes" },
      { "<leader>aM", function()
          local diff = get_git_diff(true)
          if diff ~= "" then
            vim.fn.setreg('"', diff)
            vim.cmd("CopilotChat Write commit message for the change with commitizen convention.")
          end
        end, desc = "CopilotChat - Generate commit message for staged changes" },
      { "<leader>aq", function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then vim.cmd("CopilotChatBuffer " .. input) end
        end, desc = "CopilotChat - Quick chat" },
      { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
      { "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
      { "<leader>aF", "<cmd>CopilotChatFixError<cr>", desc = "CopilotChat - Fix Error" },
      { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
      { "<leader>av", "<cmd>CopilotChatVsplitToggle<cr>", desc = "CopilotChat - Toggle Vsplit" },
    },
  },
}

return M
