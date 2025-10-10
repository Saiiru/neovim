return {
  "aznhe21/actions-preview.nvim",
  event = "LspAttach",
  opts = {
    telescope = {
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
        width = 0.6,
        height = 0.7,
        prompt_position = "top",
        preview_cutoff = 15,
        preview_height = function(_, _, max_lines) return math.floor(max_lines * 0.5) end,
      },
    },
  },
  config = function(_, opts)
    require("actions-preview").setup(opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", function()
      require("actions-preview").code_actions()
    end, { desc = "Code Actions (preview)" })
  end,
}

