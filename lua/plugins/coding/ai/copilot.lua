return {
  { import = "lazyvim.plugins.extras.ai.copilot-chat" },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-CR>",
          accept_line = "<A-l>",
          accept_word = "<A-k>",
          next = "<A-]>",
          prev = "<A-[>",
          dismiss = "<A-c>",
        },
      },
    },
    keys = {
      { "<leader>cI", "<cmd>Copilot toggle<cr>", desc = "Toggle IA (Copilot)" },
    },
  },
}
