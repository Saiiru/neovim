return {
  "folke/noice.nvim",
  opts = function(_, opts)
    -- Skipping unimportant notifications
    table.insert(opts.routes, {
      filter = {
        event = "notify",
        find = "No information available",
      },
      opts = {
        skip = true,
      },
    })

    -- Apply the border to LSP documentation, making it visually sleek
    opts.presets.lsp_doc_border = true

    -- Remove the bottom search area for a more streamlined look
    opts.presets.bottom_search = false

    -- Additional custom styling
    opts.ui = {
      -- Customize the background color for floating windows
      win_options = {
        winblend = 15, -- Make the floating window semi-transparent
      },
      -- Add sleek transition animations (subtle but techy)
      animate = true,
    }
  end,
}
