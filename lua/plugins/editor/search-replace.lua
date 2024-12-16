local prefix = "sr"

return {
  -- Search and Replace Plugin
  {
    "roobert/search-replace.nvim",
    opts = {
      default_replace_single_buffer_options = "gcI", -- options for replacing within a single buffer
      default_replace_multi_buffer_options = "egcI", -- options for replacing across multiple buffers
    },
    keys = {
      -- Visual Mode Bindings
      {
        prefix .. "b",
        "<CMD>SearchReplaceSingleBufferVisualSelection<CR>",
        desc = "Search Replace in Buffer (Visual)",
        mode = "v",
      },
      {
        prefix .. "v",
        "<CMD>SearchReplaceWithinVisualSelection<CR>",
        desc = "Search Replace in Visual Selection",
        mode = "v",
      },
      {
        prefix .. "w",
        "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>",
        desc = "Search Replace Word in Buffer (Visual)",
        mode = "v",
      },

      -- Normal Mode Bindings
      {
        prefix .. "B",
        "<CMD>SearchReplaceSingleBufferOpen<CR>",
        desc = "Search Replace in Buffer (Normal)",
        mode = "n",
      },
      {
        prefix .. "W",
        "<CMD>SearchReplaceSingleBufferCWord<CR>",
        desc = "Search Replace Word in Buffer (Normal)",
        mode = "n",
      },
      {
        prefix .. "E",
        "<CMD>SearchReplaceSingleBufferCWORD<CR>",
        desc = "Search Replace WORD in Buffer (Normal)",
        mode = "n",
      },
      {
        prefix .. "e",
        "<CMD>SearchReplaceSingleBufferCExpr<CR>",
        desc = "Search Replace Expression in Buffer (Normal)",
        mode = "n",
      },
    },
  },

  -- Which-key Integration
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { prefix, group = "replace", icon = " " }, -- Icon for replace functionality
      },
    },
  },

  -- Grug Far Plugin for File Search
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      {
        prefix .. "p", -- Prefix for opening project search
        function()
          local grug = require "grug-far"
          local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
          grug.grug_far {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil, -- Filter by file extension
            },
          }
        end,
        mode = { "n", "v" },
        desc = "Search Project Files",
      },
    },
  },
}
