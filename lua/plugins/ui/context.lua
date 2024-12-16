return {
  "haringsrob/nvim_context_vt",
  event = "LazyFile",
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    prefix = "󱞷", -- Cyberpunk-related icon (for context display)
    highlight = "NonText", -- Neon-like non-text highlighting
    min_rows = 7, -- Context displayed after 7 lines
    disable_ft = { "markdown", "css" }, -- Disabling context for certain filetypes
    disable_virtual_lines_ft = { "yaml" }, -- No virtual lines in YAML files
    -- Customize highlight groups for the context's virtual text
    highlights = {
      default = { fg = "#00FF00", bg = "#1E1E1E", bold = true }, -- Neon green text with dark background
      error = { fg = "#FF00FF", bg = "#1E1E1E", bold = true }, -- Neon pink for errors
      warning = { fg = "#FFFF00", bg = "#1E1E1E", bold = true }, -- Yellow neon for warnings
      info = { fg = "#00BFFF", bg = "#1E1E1E", bold = true }, -- Cyan for info
    },
  },
  keys = {
    {
      "<leader>ux",
      "<cmd>NvimContextVtToggle<CR>",
      desc = "Toggle Context 🕹️", -- Added a cyberpunk icon for the toggle
    },
  },
}
