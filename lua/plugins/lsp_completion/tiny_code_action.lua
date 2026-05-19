return {
  "rachartier/tiny-code-action.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
  },
  opts = {
    backend = "vim",
    picker = {
      "fzf-lua",
      opts = {
        winopts = {
          width = 0.74,
          height = 0.72,
          preview = {
            layout = "vertical",
            vertical = "down:55%",
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>ca",
      function()
        require("tiny-code-action").code_action()
      end,
      desc = "Code action",
    },
  },
}
