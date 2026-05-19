return {
  "nvim-telescope/telescope.nvim",
  -- Telescope fica desligado por enquanto.
  -- Motivo: a versão atual quebrou preview com Treesitter (`ft_to_lang` nil).
  -- FzfLua assumiu busca, buffers, symbols, diagnostics, vim.ui.select e code actions.
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "debugloop/telescope-undo.nvim",
    "nvim-telescope/telescope-frecency.nvim",
  },
  opts = function()
    local actions = require("telescope.actions")
    local previewers = require("telescope.previewers")

    local bad_ext = {
      csv = true,
      lock = true,
      min = true,
    }

    local function safe_previewer(filepath, bufnr, opts)
      opts = opts or {}
      local expanded = vim.fn.expand(filepath)
      local stat = vim.uv.fs_stat(expanded)
      local ext = vim.fn.fnamemodify(expanded, ":e")

      if bad_ext[ext] or (stat and stat.size > 100 * 1024) then
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Preview disabled for large/generated file." })
        return
      end

      previewers.buffer_previewer_maker(expanded, bufnr, opts)
    end

    return {
      defaults = {
        buffer_previewer_maker = safe_previewer,
        path_display = { "filename_first" },
        layout_strategy = "flex",
        layout_config = {
          horizontal = { preview_width = 0.45 },
          vertical = { width = 0.9, height = 0.95, preview_height = 0.5, preview_cutoff = 0 },
          flex = { flip_columns = 140 },
        },
        mappings = {
          i = {
            ["<Esc>"] = actions.close,
            ["<C-q>"] = actions.send_to_qflist,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
          },
        },
      },
      pickers = {
        find_files = { theme = "ivy", layout_config = { height = 0.4 } },
        git_files = { theme = "ivy", layout_config = { height = 0.4 } },
        live_grep = { theme = "ivy", layout_config = { height = 0.4 } },
        buffers = { theme = "ivy", layout_config = { height = 0.4 } },
        keymaps = { theme = "ivy", layout_config = { height = 0.4 } },
        treesitter = { theme = "ivy", layout_config = { height = 0.4 } },
        help_tags = { theme = "ivy", layout_config = { height = 0.5 } },
        man_pages = { sections = { "1", "2", "3" }, theme = "ivy", layout_config = { height = 0.4 } },
      },
      extensions = {
        frecency = {
          auto_validate = false,
          matcher = "fuzzy",
          path_display = { "shorten" },
        },
        undo = { side_by_side = true },
      },
    }
  end,
}
