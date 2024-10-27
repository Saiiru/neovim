return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              width = 0.95,
              height = 0.85,
              preview_width = 0.6,
              prompt_position = "top",
            },
          },
          find_command = {
            "rg",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          prompt_prefix = "  ",
          selection_caret = "  ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          path_display = { "smart" },
          winblend = 10,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          mappings = {
            i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default + actions.center,
            },
            n = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              previewer = false,
            }),
          },
        },
      })

      -- Carrega as extensões
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")

      -- Definindo os keymaps para atalhos
      local keymap = vim.keymap.set
      keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "[F]ind [F]iles" })
      keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "[F]ind by [G]rep" })
      keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "[F]ind [B]uffers" })
      keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "[F]ind [H]elp" })
      keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "[F]ind [R]ecent Files" })
      keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "[F]ind [C]ursor String" })
      keymap("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "[F]ind [T]odos" })
      keymap("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "[F]ind [P]rojects" })
    end,
  },

  -- Extensão do ui-select
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
