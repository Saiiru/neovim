return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",
  opts = {
    indent = {
      char = "┃", -- Use a thinner character for a smoother look
      tab_char = "▏",
    },
    scope = {
      enabled = true, -- Enable scopes for better visibility
      highlight = "Visual", -- Highlight the scope in a specific group (change as needed)
    },
    -- stylua: ignore
    exclude = {
      filetypes = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason' },
    },
  },
}
