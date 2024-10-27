return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- Configuração de caracteres de preenchimento
    vim.opt.fillchars:append { diff = "╱" }

    -- Requerendo módulos
    local actions = require("diffview.actions")
    local diffview = require("diffview")
    local cb = require("diffview.config").diffview_callback

    -- Configuração do diffview
    diffview.setup({
      view = {
        default = { winbar_info = false },
        file_history = { winbar_info = false },
      },
      win_config = function()
        return {
          type = "split",
          position = "bottom",
          height = 14,
          relative = "win",
          win = vim.api.nvim_tabpage_list_wins(0)[1],
        }
      end,
      diff_binaries = false,
      use_icons = true, -- Requer nvim-web-devicons
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
      },
      file_panel = {
        listing_style = "tree",            -- Pode ser 'list' ou 'tree'
        tree_options = {
          flatten_dirs = true,             -- Flatten dirs que contêm apenas um único diretório
          folder_statuses = "only_folded", -- Status de pastas: 'never', 'only_folded' ou 'always'.
        },
      },
      enhanced_diff_hl = true,
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {
          first_parent = true, -- Seguir apenas o primeiro pai ao ver um commit de merge.
          all = true,          -- Incluir todos os refs.
          merges = false,
          reverse = false,
        },
      },
      hooks = {},                -- Para configuração de hooks
      key_bindings = {
        disable_defaults = true, -- Desativar mapeamentos padrão
        view = {
          ["<C-n>"] = cb("select_next_entry"),
          ["<C-p>"] = cb("select_prev_entry"),
          ["<CR>"] = cb("goto_file_edit"),
          ["<C-w><C-f>"] = cb("goto_file_split"),
          ["<C-w>gf"] = cb("goto_file_tab"),
          ["<leader>e"] = cb("focus_files"),
          ["<leader>b"] = cb("toggle_files"),
        },
        file_panel = {
          ["j"] = cb("next_entry"),
          ["<down>"] = cb("next_entry"),
          ["k"] = cb("prev_entry"),
          ["<up>"] = cb("prev_entry"),
          ["o"] = cb("select_entry"),
          ["<2-LeftMouse>"] = cb("select_entry"),
          ["-"] = cb("toggle_stage_entry"),
          ["S"] = cb("stage_all"),
          ["U"] = cb("unstage_all"),
          ["X"] = cb("restore_entry"),
          ["R"] = cb("refresh_files"),
          ["<S-Up>"] = actions.scroll_view(-20),
          ["<S-Down>"] = actions.scroll_view(20),
          ["<C-n>"] = cb("select_next_entry"),
          ["<C-p>"] = cb("select_prev_entry"),
          ["gf"] = cb("goto_file"),
          ["<cr>"] = cb("goto_file_tab"),
          ["i"] = cb("listing_style"),
          ["f"] = cb("toggle_flatten_dirs"),
          ["<leader>e"] = cb("focus_files"),
        },
        file_history_panel = {
          ["g!"] = cb("options"),
          ["<C-A-d>"] = cb("open_in_diffview"),
          ["zR"] = cb("open_all_folds"),
          ["zM"] = cb("close_all_folds"),
          ["j"] = cb("next_entry"),
          ["<down>"] = cb("next_entry"),
          ["k"] = cb("prev_entry"),
          ["<up>"] = cb("prev_entry"),
          ["<cr>"] = cb("select_entry"),
          ["o"] = cb("select_entry"),
          ["<2-LeftMouse>"] = cb("select_entry"),
          ["<C-n>"] = cb("select_next_entry"),
          ["<C-p>"] = cb("select_prev_entry"),
          ["gf"] = cb("goto_file"),
          ["<C-w><C-f>"] = cb("goto_file_split"),
          ["<C-w>gf"] = cb("goto_file_tab"),
          ["<leader>e"] = cb("focus_files"),
          ["<leader>b"] = cb("toggle_files"),
        },
        option_panel = {
          ["<tab>"] = cb("select"),
          ["q"] = cb("close"),
        },
      },
    })
  end
}
