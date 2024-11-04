return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "echasnovski/mini.bufremove",
        version = "*",
        config = function()
          require("mini.bufremove").setup({
            silent = true,
          })
        end,
      },
    },
    config = function()
      local bufferline = require("bufferline")

      bufferline.setup({
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          show_buffer_close_icons = false,
          always_show_bufferline = true,
          style_preset = bufferline.style_preset.no_italic,
          numbers = function(opts)
            return string.format("%s", opts.ordinal)
          end,
          custom_filter = function(buf_number)
            return vim.bo[buf_number].filetype ~= "qf" -- Filter out Quickfix buffers
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "EcovimNvimTreeTitle",
              text_align = "center",
              separator = true,
            },
          },
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and "🚨 " or "⚠️ "
            return " " .. icon .. count
          end,
          highlights = {
            fill = {
              guibg = "#0f0f0f", -- Dark background
            },
            background = {
              guibg = "#282c34", -- Background color for inactive buffers
            },
            buffer_visible = {
              guibg = "#1e1e1e", -- Color for visible buffers
            },
            close_button = {
              guifg = "#ff5555", -- Color for close button
              guibg = "#282c34", -- Background color for close button
            },
            close_button_visible = {
              guifg = "#50fa7b", -- Color for visible close button
              guibg = "#282c34", -- Background color for visible close button
            },
            modified = {
              guifg = "#bd93f9", -- Color for modified buffer
              guibg = "#282c34", -- Background color for modified buffer
            },
            separator = {
              guifg = "#6272a4", -- Color for separators
              guibg = "#282c34", -- Background color for separators
            },
            separator_visible = {
              guifg = "#ff79c6", -- Color for visible separators
              guibg = "#282c34", -- Background color for visible separators
            },
            indicator_selected = {
              guifg = "#ffb86c", -- Color for the selected buffer indicator
              guibg = "#44475a", -- Background color for selected buffer
            },
          },
        },
      })
    end,
    keys = {
      -- Numbered Buffer Navigation
      { "<Space>1", "<cmd>BufferLineGoToBuffer 1<CR>" },
      { "<Space>2", "<cmd>BufferLineGoToBuffer 2<CR>" },
      { "<Space>3", "<cmd>BufferLineGoToBuffer 3<CR>" },
      { "<Space>4", "<cmd>BufferLineGoToBuffer 4<CR>" },
      { "<Space>5", "<cmd>BufferLineGoToBuffer 5<CR>" },
      { "<Space>6", "<cmd>BufferLineGoToBuffer 6<CR>" },
      { "<Space>7", "<cmd>BufferLineGoToBuffer 7<CR>" },
      { "<Space>8", "<cmd>BufferLineGoToBuffer 8<CR>" },
      { "<Space>9", "<cmd>BufferLineGoToBuffer 9<CR>" },
      { "<A-1>", "<cmd>BufferLineGoToBuffer 1<CR>" },
      { "<A-2>", "<cmd>BufferLineGoToBuffer 2<CR>" },
      { "<A-3>", "<cmd>BufferLineGoToBuffer 3<CR>" },
      { "<A-4>", "<cmd>BufferLineGoToBuffer 4<CR>" },
      { "<A-5>", "<cmd>BufferLineGoToBuffer 5<CR>" },
      { "<A-6>", "<cmd>BufferLineGoToBuffer 6<CR>" },
      { "<A-7>", "<cmd>BufferLineGoToBuffer 7<CR>" },
      { "<A-8>", "<cmd>BufferLineGoToBuffer 8<CR>" },
      { "<A-9>", "<cmd>BufferLineGoToBuffer 9<CR>" },

      -- Buffer Management Commands
      { "<Leader>bb", "<cmd>BufferLineMovePrev<CR>", desc = "Move back" },
      { "<Leader>bl", "<cmd>BufferLineCloseLeft<CR>", desc = "Close Left" },
      { "<Leader>br", "<cmd>BufferLineCloseRight<CR>", desc = "Close Right" },
      { "<Leader>bn", "<cmd>BufferLineMoveNext<CR>", desc = "Move next" },
      { "<Leader>bp", "<cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
      { "<Leader>bP", "<cmd>BufferLineTogglePin<CR>", desc = "Pin/Unpin Buffer" },
      { "<Leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", desc = "Sort by directory" },
      { "<Leader>bse", "<cmd>BufferLineSortByExtension<CR>", desc = "Sort by extension" },
      { "<Leader>bsr", "<cmd>BufferLineSortByRelativeDirectory<CR>", desc = "Sort by relative dir" },
    },
  },
}
