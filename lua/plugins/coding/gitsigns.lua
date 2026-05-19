-- ================================================================================================
-- TITLE : gitsigns.nvim
-- ABOUT : Sinais, hunks e ações Git diretamente no buffer.
-- NOTE  : Ações de hunk usam prefixo `<leader>gh` para não conflitar com Fugitive.
-- ================================================================================================

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_line_blame = false,
    numhl = true,
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
      end

      -- Navegação rápida entre hunks.
      map("n", "]h", gs.next_hunk, "Next Git Hunk")
      map("n", "[h", gs.prev_hunk, "Previous Git Hunk")

      -- Ações de hunk. Prefixo explícito para ficar fácil no which-key.
      map("n", "<leader>ghs", gs.stage_hunk, "Stage Hunk")
      map("n", "<leader>ghr", gs.reset_hunk, "Reset Hunk")
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
      map("n", "<leader>ghb", function()
        gs.blame_line({ full = true })
      end, "Blame Line")
      map("n", "<leader>ghd", gs.diffthis, "Diff This")
      map("n", "<leader>ghD", function()
        gs.diffthis("~")
      end, "Diff This ~")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Git Hunk")

      -- Toggles visuais.
      map("n", "<leader>ght", gs.toggle_current_line_blame, "Toggle Blame Line")
      map("n", "<leader>ghl", gs.toggle_linehl, "Toggle Line Highlight")
      map("n", "<leader>ghw", gs.toggle_word_diff, "Toggle Word Diff")
      map("n", "<leader>ghx", gs.toggle_deleted, "Toggle Deleted")
      map("n", "<leader>ghR", gs.refresh, "Refresh Git Signs")
    end,
  },
}
