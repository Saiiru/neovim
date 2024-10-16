return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
      { "nvim-telescope/telescope-ui-select.nvim" }
    },
    config = function()
      local builtin = require('telescope.builtin')
      local actions = require("telescope.actions")
      local icons = require("config.icons.icons")

      require("telescope").setup({
        defaults = {
          prompt_prefix = icons.ui.Telescope .. " ",
          selection_caret = icons.ui.Forward .. " ",
          entry_prefix = "   ",
          initial_mode = "insert",
          selection_strategy = "reset",
          path_display = { "smart" },
          color_devicons = true,
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
            n = {
              ["<esc>"] = actions.close,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["q"] = actions.close,
            },
          },
        },
        pickers = {
          live_grep = { theme = "dropdown" },
          grep_string = { theme = "dropdown" },
          find_files = { theme = "dropdown", previewer = false },
          buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
            mappings = {
              i = { ["<C-d>"] = actions.delete_buffer },
              n = { ["dd"] = actions.delete_buffer },
            },
          },
          planets = { show_pluto = true, show_moon = true },
          colorscheme = { enable_preview = true },
          lsp_references = {
            theme = "dropdown",
            initial_mode = "normal",
            sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
            attach_mappings = function(_, map)
              map('i', '<CR>', function(prompt_bufnr)
                local results = require("telescope.actions.state").get_selected_entry()
                local deduped_results = {} -- Your deduplication logic here
                -- Implement logic to deduplicate results if needed
                require("telescope.actions").close(prompt_bufnr)
                -- Open location in buffer
              end)
              return true
            end,
          },
          lsp_definitions = { theme = "dropdown", initial_mode = "normal" },
          lsp_declarations = { theme = "dropdown", initial_mode = "normal" },
          lsp_implementations = { theme = "dropdown", initial_mode = "normal" },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")

      -- Keymaps
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set('n', '<leader>bf', builtin.current_buffer_fuzzy_find, { desc = "Current Buffer Fuzzy Find" })
      vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = "LSP Document Symbols" })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help Tags" })
      vim.keymap.set('n', '<leader>ft', builtin.git_files, { desc = "Git Files" })
      vim.keymap.set('n', '<leader>cs', builtin.colorscheme, { desc = "Colorscheme" })
      vim.keymap.set('n', '<leader>ts', builtin.tagstack, { desc = "Tagstack" })
      vim.keymap.set('n', '<leader>mk', builtin.marks, { desc = "Marks" })
      vim.keymap.set('n', '<leader>bt', function() builtin.buffers(require('telescope.themes').get_dropdown{previewer = false}) end, { desc = "Buffer Dropdown" })
    end
  }
}
