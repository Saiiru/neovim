return {
  "HiPhish/rainbow-delimiters.nvim",
  event = "BufRead",
  config = function()
    -- Setup for rainbow delimiters with cyberpunk colors
    require("rainbow-delimiters").setup {
      -- Custom color scheme: Neon-like shades for the brackets
      rainbow_colors = {
        "#ff00ff", -- Magenta
        "#00ffff", -- Cyan
        "#00ff00", -- Green
        "#ff0000", -- Red
        "#ffff00", -- Yellow
        "#0000ff", -- Blue
        "#ff7f00", -- Orange
      },

      -- Set a soft, futuristic highlight for the delimiters
      highlight = {
        -- Add neon-like glow effect (or glow-styled highlight)
        style = "bold", -- Bold makes it stand out without being too harsh
      },

      -- Optional: Make the delimiter colors fade smoothly
      fade = true,

      -- Enable brackets highlighting
      show_trailing_blankline_indent = false,
      max_file_lines = 10000, -- For performance, especially with large files
    }
  end,
}
