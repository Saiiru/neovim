return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = function()
    local C = {
      signs = {
        add = { text = "" }, -- Icon for added lines
        change = { text = "" }, -- Icon for changed lines
        delete = { text = "" }, -- Icon for deleted lines
        topdelete = { text = "" }, -- Icon for top-line deletions
        changedelete = { text = "" }, -- Icon for changes with deletions
        untracked = { text = "" }, -- Icon for untracked files
      },
      current_line_blame_opts = {
        virt_text = true, -- Show blame info as virtual text
        virt_text_pos = "eol", -- Position blame at the end of the line
        delay = 500, -- Delay before showing blame
        ignore_whitespace = false, -- Include whitespace changes in blame
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Helper function to set keymaps with descriptions
        local function map(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
        end

        -- Navigation between hunks
        map("n", "]h", gs.next_hunk, "Next Hunk") -- Jump to the next hunk
        map("n", "[h", gs.prev_hunk, "Previous Hunk") -- Jump to the previous hunk

        -- Core Gitsigns actions under <leader>gh
        map("n", "<leader>ghs", gs.stage_hunk, "Stage Hunk") -- Stage the current hunk
        map("n", "<leader>ghr", gs.reset_hunk, "Reset Hunk") -- Reset the current hunk
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Entire Buffer") -- Stage all changes in the buffer
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Staged Hunk") -- Undo staging of the last hunk
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Entire Buffer") -- Reset all changes in the buffer
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk") -- Show a preview of the current hunk
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame Line") -- Show blame for the current line
        map("n", "<leader>ghB", gs.toggle_current_line_blame, "Toggle Line Blame") -- Toggle blame display
        map("n", "<leader>ghd", gs.diffthis, "Diff Current File") -- Show diff for the current file
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, "Diff Against Index") -- Diff against index

        -- Text object for selecting hunks
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk") -- Select the current hunk
      end,
    }
    return C
  end,
  config = function()
    -- Register Gitsigns in which-key with a group and icon
    require("which-key").add({
      { "<leader>gh", group = "Gitsigns", icon = "" }, -- Add Gitsigns group to which-key
    })
  end,
  keys = {
    -- Navigation between hunks
    {
      "]h",
      function()
        require("gitsigns").next_hunk()
      end,
      desc = "Next Hunk",
    },
    {
      "[h",
      function()
        require("gitsigns").prev_hunk()
      end,
      desc = "Previous Hunk",
    },

    -- Gitsigns actions with descriptions
    { "<leader>ghs", ":Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
    { "<leader>ghr", ":Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
    {
      "<leader>ghS",
      function()
        require("gitsigns").stage_buffer()
      end,
      desc = "Stage Entire Buffer",
    },
    {
      "<leader>ghu",
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      desc = "Undo Staged Hunk",
    },
    {
      "<leader>ghR",
      function()
        require("gitsigns").reset_buffer()
      end,
      desc = "Reset Entire Buffer",
    },
    {
      "<leader>ghp",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview Hunk",
    },
    {
      "<leader>ghb",
      function()
        require("gitsigns").blame_line({ full = true })
      end,
      desc = "Blame Line",
    },
    {
      "<leader>ghB",
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      desc = "Toggle Line Blame",
    },
    {
      "<leader>ghd",
      function()
        require("gitsigns").diffthis()
      end,
      desc = "Diff Current File",
    },
    {
      "<leader>ghD",
      function()
        require("gitsigns").diffthis("~")
      end,
      desc = "Diff Against Index",
    },
  },
}
