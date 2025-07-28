-- Telescope Configuration - Search and Discovery Matrix
-- ====================================================

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod
    
    -- Custom Action Matrix
    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")
    
    -- Custom actions
    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        trouble.toggle("quickfix")
      end,
    })

    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        
        file_ignore_patterns = {
          "^.git/",
          "^./.git/",
          "^node_modules/",
          "^vendor/",
          "%.lock",
        },

        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-x>"] = actions.send_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-c>"] = actions.close,
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
          },
          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + custom_actions.open_trouble_qflist,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["?"] = actions.which_key,
          },
        },

        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },

        selection_strategy = "reset",
        sorting_strategy = "ascending",
        scroll_strategy = "cycle",
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" },
      },

      pickers = {
        -- Files
        find_files = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
          hidden = false,
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },

        live_grep = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        grep_string = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        -- Buffers
        buffers = {
          theme = "dropdown",
          layout_config = {
            width = 0.75,
            height = 0.6,
          },
          ignore_current_buffer = true,
          sort_lastused = true,
          sort_mru = true,
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer,
            },
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },

        -- LSP
        lsp_references = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        lsp_definitions = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        lsp_declarations = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        lsp_implementations = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        diagnostics = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        -- Git
        git_files = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        git_commits = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        git_bcommits = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        git_status = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        -- Treesitter
        treesitter = {
          theme = "dropdown",
          layout_config = {
            width = 0.75,
            height = 0.6,
          },
        },

        -- Help
        help_tags = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        -- Man pages
        man_pages = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        -- Oldfiles
        oldfiles = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        -- Commands
        commands = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        -- Command history
        command_history = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        -- Search history
        search_history = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        -- Marks
        marks = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        -- Registers
        registers = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        -- Keymaps
        keymaps = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },

        -- Spell suggest
        spell_suggest = {
          theme = "ivy",
          layout_config = {
            height = 0.4,
          },
        },
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        
        file_browser = {
          theme = "ivy",
          hijack_netrw = true,
          mappings = {
            ["i"] = {
              -- your custom insert mode mappings
            },
            ["n"] = {
              -- your custom normal mode mappings
            },
          },
        },
        
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({
            winblend = 10,
            width = 0.5,
            previewer = false,
            shorten_path = false,
          }),
        },
      },
    })

    -- Load Extensions - Enhancement Modules
    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")
    telescope.load_extension("ui-select")

    -- Telescope Keymaps - Search Control Matrix
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- File Operations
    keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", vim.tbl_extend("force", opts, { desc = "Fuzzy find files in cwd" }))
    keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", vim.tbl_extend("force", opts, { desc = "Find string in cwd" }))
    keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", vim.tbl_extend("force", opts, { desc = "Find string under cursor in cwd" }))
    keymap("n", "<leader>fr", "<cmd>Telescope resume<cr>", vim.tbl_extend("force", opts, { desc = "Resume previous search" }))
    keymap("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", vim.tbl_extend("force", opts, { desc = "Find diagnostics" }))
    keymap("n", "<leader>fs", "<cmd>Telescope treesitter<cr>", vim.tbl_extend("force", opts, { desc = "Find treesitter symbols" }))

    -- Additional search functions
    keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", vim.tbl_extend("force", opts, { desc = "Find string under cursor" }))
    keymap("n", "<leader>ft", "<cmd>Telescope help_tags<cr>", vim.tbl_extend("force", opts, { desc = "Find help tags" }))
    keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", vim.tbl_extend("force", opts, { desc = "Find keymaps" }))
    keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", vim.tbl_extend("force", opts, { desc = "Find recent files" }))
    keymap("n", "<leader>fm", "<cmd>Telescope marks<cr>", vim.tbl_extend("force", opts, { desc = "Find marks" }))
    keymap("n", "<leader>fR", "<cmd>Telescope registers<cr>", vim.tbl_extend("force", opts, { desc = "Find registers" }))

    -- Git operations
    keymap("n", "<leader>gf", "<cmd>Telescope git_files<cr>", vim.tbl_extend("force", opts, { desc = "Find git files" }))
    keymap("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", vim.tbl_extend("force", opts, { desc = "Find git commits" }))
    keymap("n", "<leader>gC", "<cmd>Telescope git_bcommits<cr>", vim.tbl_extend("force", opts, { desc = "Find git commits for current buffer" }))
    keymap("n", "<leader>gs", "<cmd>Telescope git_status<cr>", vim.tbl_extend("force", opts, { desc = "Find git status" }))

    -- File browser
    keymap("n", "<leader>fB", "<cmd>Telescope file_browser<cr>", vim.tbl_extend("force", opts, { desc = "Open file browser" }))
  end,
}
