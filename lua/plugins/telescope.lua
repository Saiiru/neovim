return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "AckslD/nvim-neoclip.lua",
      "debugloop/telescope-undo.nvim",
      "ThePrimeagen/harpoon",
      "joshmedeski/telescope-smart-goto.nvim",
      "exosyphon/telescope-color-picker.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "aaronhallaert/advanced-git-search.nvim",
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local telescopeConfig = require("telescope.config")

      -- Unified keymap format with [F]ind prefix
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
      vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "[F]ind [S]ymbols" })
      vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind [W]ord under Cursor" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
      vim.keymap.set("n", "<leader>fc", "<cmd>Telescope colors<CR>", { desc = "[F]ind [C]olors" })
      vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<CR>", { desc = "[F]ind [U]ndo History" })
      vim.keymap.set("n", "<leader>fi", "<cmd>AdvancedGitSearch<CR>", { desc = "[F]ind Git [I]nfo" })
      vim.keymap.set("n", "<leader>fZ", "<cmd>Zi<CR>", { desc = "[F]ind with [Z]oxide" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
      vim.keymap.set("n", "<leader>f/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[F]ind in Buffer" })

      -- Enhanced search configuration
      local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
      table.insert(vimgrep_arguments, "--hidden")
      table.insert(vimgrep_arguments, "--glob")
      table.insert(vimgrep_arguments, "!**/.git/*")

      telescope.setup({
        defaults = {
          vimgrep_arguments = vimgrep_arguments,
          path_display = { "truncate" },
          mappings = {
            n = {
              ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown(),
          undo = { entry_format = "state #$ID, $STAT, $TIME" },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      })

      -- Safe extension loading
      local extensions = {
        "fzf", "ui-select", "undo", "live_grep_args",
        "colors", "advanced_git_search", "neoclip", "smart_goto"
      }
      for _, ext in ipairs(extensions) do
        pcall(telescope.load_extension, ext)
      end
    end
  },

  

  {
    "exosyphon/telescope-color-picker.nvim",
    config = function()
      vim.keymap.set("n", "<leader>fc", "<cmd>Telescope colors<CR>", { desc = "[F]ind [C]olors" })
    end,
  },

  {
    "aaronhallaert/advanced-git-search.nvim",
    dependencies = {
      "tpope/vim-fugitive",
      "tpope/vim-rhubarb",
    },
  },
}
