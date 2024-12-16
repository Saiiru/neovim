return {
  "brenoprata10/nvim-highlight-colors",
  event = "VeryLazy",
  opts = {
    ---Render style
    render = "background", -- Choose how colors are rendered

    -- Virtual symbol configuration
    virtual_symbol = "■",
    virtual_symbol_prefix = "",
    virtual_symbol_suffix = " ",
    virtual_symbol_position = "inline", -- Position for virtual symbols

    --- Highlight colors (enable or disable for various types)
    enable_hex = true, -- Enable hex color highlighting (e.g. '#FFFFFF')
    enable_short_hex = true, -- Enable short hex color highlighting (e.g. '#fff')
    enable_rgb = true, -- Enable RGB color highlighting (e.g. 'rgb(0 0 0)')
    enable_hsl = true, -- Enable HSL color highlighting (e.g. 'hsl(150deg 30% 40%)')
    enable_var_usage = true, -- Enable CSS variable highlighting (e.g. 'var(--testing-color)')
    enable_named_colors = true, -- Enable named color highlighting (e.g. 'red', 'green')
    enable_tailwind = true, -- Enable Tailwind CSS color highlighting (e.g. 'bg-blue-500')

    -- Custom colors for theme
    custom_colors = {
      { label = "%-%-theme%-primary%-color", color = "#0f1219" },
      { label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
    },

    -- Exclude filetypes or buftypes from highlighting
    exclude_filetypes = {
      -- Disable named color highlighting in these filetypes
      "markdown",
      "text",
      "javascript",
      "python", -- Add any filetypes you want to exclude named color highlighting
    },
    exclude_buftypes = {},

    -- Enable highlighting only in specific filetypes for named colors (CSS/SCSS, etc.)
    enable_named_colors_in_files = {
      "css",
      "scss",
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
  },
  -- Keybinding to toggle highlight colors
  keys = {
    {
      "<leader>uc",
      function()
        require("nvim-highlight-colors").toggle()
      end,
      desc = "Toggle Highlight Colors",
    },
  },
}
