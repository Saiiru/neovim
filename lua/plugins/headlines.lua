return {
  "lukas-reineke/headlines.nvim",
  enabled = true, -- Enable the plugin
  dependencies = {
    "nvim-lua/plenary.nvim", -- Ensure plenary.nvim is loaded for some utilities
  },
  opts = {
    -- Define headline highlights for various levels of headers
    headline_highlights = {
      h1 = "Headline1", -- Style for # Heading 1
      h2 = "Headline2", -- Style for ## Heading 2
      h3 = "Headline3", -- Style for ### Heading 3
      h4 = "Headline4", -- Style for #### Heading 4
      h5 = "Headline5", -- Style for ##### Heading 5
      h6 = "Headline6", -- Style for ###### Heading 6
    },
    -- Default autoclose for buffers with long lines of text (e.g., markdown)
    autoclose = true, -- Automatically close buffers
    threshold = 900, -- Customize threshold for how long a file needs to be before activating
  },
  config = function()
    -- Customize highlight groups to style the headlines
    vim.cmd([[
      highlight Headline1 guifg=#FF6347 guibg=#1e1e1e gui=bold
      highlight Headline2 guifg=#FFD700 guibg=#1e1e1e gui=italic
      highlight Headline3 guifg=#00FA9A guibg=#1e1e1e gui=underline
      highlight Headline4 guifg=#6495ED guibg=#1e1e1e gui=bold,italic
      highlight Headline5 guifg=#FF8C00 guibg=#1e1e1e gui=italic
      highlight Headline6 guifg=#9ACD32 guibg=#1e1e1e gui=underline
    ]])
  end,
  -- Lazy loading based on file types
  ft = { "markdown", "org", "text", "rst", "nroff", "html", "latex" }, -- Add filetypes for broader support
}
