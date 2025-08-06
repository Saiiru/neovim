-- ═════════════════════════════════════════════════════════════════════════
  --  GIT INTEGRATION - VERSION CONTROL MATRIX
  -- ═════════════════════════════════════════════════════════════════════════
-- GITSIGNS (CONTROLE DE VERSÃO):
-- ]h/[h                        -- Próximo/anterior hunk (mudança)
-- <leader>hs                   -- Stage hunk (adicionar mudança)
-- <leader>hr                   -- Reset hunk (descartar mudança)
-- <leader>hS                   -- Stage buffer completo
-- <leader>hu                   -- Undo stage hunk
-- <leader>hR                   -- Reset buffer completo
-- <leader>hp                   -- Preview hunk (visualizar mudança)
-- <leader>hb                   -- Blame line (quem mudou)
-- <leader>hB                   -- Toggle blame automático
-- <leader>hd                   -- Diff this (comparar arquivo)
-- ih                           -- Textobject para hunk (visual mode)
  return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        
        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next Hunk" })
        
        map("n", "[h", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev Hunk" })
        
        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, { desc = " Stage Hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = " Reset Hunk" })
        map("v", "<leader>hs", function() gs.stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end, { desc = " Stage Hunk" })
        map("v", "<leader>hr", function() gs.reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end, { desc = " Reset Hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = " Stage Buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = " Undo Stage Hunk" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = " Reset Buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = " Preview Hunk" })
        map("n", "<leader>hb", function() gs.blame_line{full=true} end, { desc = " Blame Line" })
        map("n", "<leader>hB", gs.toggle_current_line_blame, { desc = " Toggle Line Blame" })
        map("n", "<leader>hd", gs.diffthis, { desc = " Diff This" })
        map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = " Diff This ~" })
        
        -- Text object
        map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns Select Hunk" })
      end,
      watch_gitdir = {
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      max_file_length = 40000,
      preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
    },
  }
