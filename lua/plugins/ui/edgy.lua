return {
  "folke/edgy.nvim",
  opts = {
    animate = { enabled = false }, -- Disable animations for a smoother, more immediate interaction
    theme = {
      -- Background and border color scheme matching cyberpunk vibes
      bg = "#1E1E1E", -- Dark background for the panels (cyberpunk-style)
      border = "#FF00FF", -- Neon pink borders for windows (futuristic look)
      fg = "#00FF00", -- Neon green foreground text (matches your aesthetic)
      prompt = "#00BFFF", -- Cyan for prompts (futuristic)
    },
    -- Customizing the highlight groups for a cyberpunk aesthetic
    highlights = {
      EdgePanel = { fg = "#00FF00", bg = "#1E1E1E", bold = true }, -- Green text on dark panel
      EdgeBorder = { fg = "#FF00FF", bg = "#1E1E1E", bold = true }, -- Pink border for panels
      EdgeTitle = { fg = "#FFFF00", bg = "#1E1E1E", bold = true }, -- Yellow title for that "alert" feel
    },
  },
}
