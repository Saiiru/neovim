local keys = {}

-- stylua: ignore start
for i = 1, 9 do
  table.insert(keys, { 
    "<leader>b" .. i, 
    "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", 
    desc = "Navigate to Buffer " .. i .. " 🚀" 
  })
end

table.insert(keys, { "<leader>.", "<Cmd>BufferLinePick<CR>", desc = "Pick a Buffer 🔮" })

table.insert(keys, { 
  "<leader>bS", 
  "<Cmd>BufferLineSortByDirectory<CR>", 
  desc = "Sort Buffers By Directory 🏙️" 
})
table.insert(keys, { 
  "<leader>bs", 
  "<Cmd>BufferLineSortByExtension<CR>", 
  desc = "Sort Buffers By Extension 💾" 
})

table.insert(keys, { 
  "<space><", 
  "<cmd>BufferLineMovePrev<cr>", 
  desc = "Move Buffer Left ⬅️" 
})
table.insert(keys, { 
  "<space>>", 
  "<cmd>BufferLineMoveNext<cr>", 
  desc = "Move Buffer Right ➡️" 
})
-- stylua: ignore end

return {
  "akinsho/bufferline.nvim",
  keys = keys,
  opts = {
    options = {
      modified_icon = "", -- Keep the same, looks sleek
      color_icons = true, -- Keep the neon-style icons for each buffer
      separator_style = { "▏", "▏" }, -- Using a more sharp separator for a futuristic look
      always_show_bufferline = true, -- Keep the buffer line visible all the time
      show_buffer_icons = true, -- Show buffer icons
      show_buffer_close_icons = false, -- No close icons for a sleeker look
      hover = {
        enabled = true,
        delay = 200, -- Hover delay for that subtle cyberpunk "hover effect"
        reveal = { "close" }, -- Show close button on hover only
      },
      -- Cyberpunk colors and styles
      diagnostics = "nvim_lsp", -- Diagnostics from LSP
      custom_filter = function(buf, buf_num, buf_name)
        -- Optionally, you could use this function to filter certain buffers
        -- based on their names, etc. For now, just return true to show all
        return true
      end,
      highlights = {
        fill = { bg = "#1F1F1F" }, -- Dark background
        background = { fg = "#9B9B9B", bg = "#1F1F1F" }, -- Dimmed background
        buffer_visible = { fg = "#8c8c8c", bg = "#1F1F1F" }, -- Light gray for inactive buffers
        buffer_selected = { fg = "#C1F5FF", bg = "#2D2D2D", bold = true }, -- Light blue neon on active buffer
        separator = { fg = "#555555", bg = "#1F1F1F" }, -- Neutral separator color
        separator_visible = { fg = "#1F1F1F", bg = "#1F1F1F" }, -- Invisible when buffer not selected
        separator_selected = { fg = "#2D2D2D", bg = "#2D2D2D" }, -- Invisible in selected buffer
        modified = { fg = "#FF9E3D", bg = "#1F1F1F" }, -- Orange for modified buffers
        modified_visible = { fg = "#FF9E3D", bg = "#1F1F1F" }, -- Visible modified buffers
        modified_selected = { fg = "#FF9E3D", bg = "#2D2D2D" }, -- Modified selected buffer
      },
    },
  },
}
