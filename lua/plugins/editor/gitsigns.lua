return {
  "lewis6991/gitsigns.nvim",
  opts = {
    -- Options for current line blame
    current_line_blame_opts = {
      virt_text = true, -- Show blame information as virtual text
      virt_text_pos = "eol", -- Position the blame at the end of the line ('eol' | 'overlay' | 'right_align')
      delay = 5, -- Delay before displaying the blame information (in ms)
      ignore_whitespace = false, -- Include whitespace changes in the blame
    },
  },

  keys = {
    -- Toggle the line blame for the current line (keybinding: <leader>uB)
    {
      "<leader>uB",
      "<cmd>Gitsigns toggle_current_line_blame<CR>",
      desc = "Toggle Line Blame",
    },

    -- Toggle the visibility of deleted lines inline (keybinding: <leader>ghe)
    {
      "<leader>ghe",
      "<cmd>Gitsigns toggle_deleted<CR>",
      desc = "Deletions Inline",
    },
  },
}
