return {
  "tris203/precognition.nvim",
  config = function()
    -- Setup precognition with custom settings
    require("precognition").setup({
      -- Define the source for completions, such as treesitter or lsp
      sources = {
        "lsp", -- Uses LSP for completions
        "treesitter", -- Uses treesitter for syntax-aware completions
      },
      -- Activate context-aware completions
      context_aware = true,
      -- Option to trigger precognition on typing a specific key sequence
      trigger = "gd", -- For example, `gd` to trigger context-aware completion
      -- Configure visual elements for suggestions
      visual_style = {
        fg = "#FF79C6", -- Highlight color for text
        bg = "#282a36", -- Background color for context hints
        bold = true, -- Bold the completions
      },
      -- Make it interactive
      interactive = true,
    })
  end,
}
