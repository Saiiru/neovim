return {
  { import = "lazyvim.plugins.extras.coding.copilot" },
  { import = "lazyvim.plugins.extras.coding.copilot-chat" },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<A-CR>",
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
