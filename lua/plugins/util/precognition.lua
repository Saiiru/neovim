return {
  "tris203/precognition.nvim",
  config = function()
    require("precognition").setup {
      sources = {
        "lsp", -- Use LSP for accurate suggestions
        "treesitter", -- Syntax-aware completions via Treesitter
      },

      context_aware = true, -- Enable contextual suggestions

      trigger = "<leader>cy", -- Keybinding for triggering completions

      visual_style = {
        fg = "#00FF9C", -- Neon green for highlighted text
        bg = "#1A1B27", -- Dark background for contrast
        bold = true, -- Emphasize completions
        italic = true, -- Futuristic touch
        underline = true, -- Neon underline effect
      },

      interactive = true, -- Dynamically adjust suggestions

      performance = {
        debounce_time = 100, -- Faster response times
        max_suggestions = 10, -- Limit to keep UI clean
        lazy_load = true, -- Load on demand for efficiency
      },

      futuristic = {
        animations = true, -- Smooth suggestion transitions
        glow_effect = {
          enable = true,
          intensity = 0.8, -- Neon glow brightness
          color = "#FF007C", -- Magenta glow for contrast
        },
      },
    }
  end,
}
