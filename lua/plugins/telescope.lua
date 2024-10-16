local icons = require("config.icons.icons")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-lua/popup.nvim" },
      { "cljoly/telescope-repo.nvim" },
      { "ThePrimeagen/git-worktree.nvim" },
      { "nvim-telescope/telescope-media-files.nvim" }, -- Adicionando o plugin necessário
    },
    config = function()
      local builtin = require('telescope.builtin')
      local actions = require("telescope.actions")

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
          layout_config = {
            horizontal = {
              preview_cutoff = 120,
            },
            prompt_position = "top",
          },
          file_sorter = require('telescope.sorters').get_fzy_sorter,
          file_previewer = require('telescope.previewers').vim_buffer_cat.new,
          grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
          qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
          sorting_strategy = "ascending",
          mappings = {
            i = {
              ["<C-x>"] = false,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<C-s>"] = actions.cycle_previewers_next,
              ["<C-a>"] = actions.cycle_previewers_prev,
              ["<ESC>"] = actions.close,
            },
            n = {
              ["<esc>"] = actions.close,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["q"] = actions.close,
              ["<C-s>"] = actions.cycle_previewers_next,
              ["<C-a>"] = actions.cycle_previewers_prev,
            }
          }
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
                local deduped_results = {} -- Sua lógica de deduplicação aqui
                require("telescope.actions").close(prompt_bufnr)
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
          media_files = { -- Configurando preview de imagens
            filetypes = { "png", "jpg", "mp4", "webm", "pdf" },
            find_cmd = "rg",
          },
        },
      })

      -- Carregando extensões
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
      require('telescope').load_extension('repo')
      require('telescope').load_extension('git_worktree')
      require("telescope").load_extension("media_files") -- Carregando media_files corretamente

      -- Keymaps reformulados
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })        -- Find Files
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep" })         -- Live Grep
      vim.keymap.set('n', '<leader>fb', builtin.current_buffer_fuzzy_find, { desc = "Fuzzy Find in Current Buffer" })  -- Fuzzy Find Current Buffer
      vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = "LSP Document Symbols" })  -- LSP Document Symbols
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help Tags" })          -- Help Tags
      vim.keymap.set('n', '<leader>fgit', builtin.git_files, { desc = "Git Files" })       -- Git Files
      vim.keymap.set('n', '<leader>cs', builtin.colorscheme, { desc = "Colorscheme" })    -- Colorscheme
      vim.keymap.set('n', '<leader>tb', function() builtin.buffers(require('telescope.themes').get_dropdown{previewer = false}) end, { desc = "Buffers Dropdown" }) -- Buffer Dropdown
      vim.keymap.set('n', '<leader>mk', builtin.marks, { desc = "Marks" })                 -- Marks
      vim.keymap.set('n', '<C-p>', "<CMD>lua require('plugins.telescope.pickers').project_files()<CR>", { desc = "Project Files" }) -- Project Files
      vim.keymap.set('n', '<Leader>pf', "<CMD>lua require('plugins.telescope.pickers').project_files({ default_text = vim.fn.expand('<cword>'), initial_mode = 'normal' })<CR>", { desc = "Project Files with Current Word" }) -- Project Files with Current Word
      vim.keymap.set('n', '<Leader>pw', "<CMD>lua require('telescope.builtin').grep_string({ initial_mode = 'normal' })<CR>", { desc = "Grep String" }) -- Grep String
      vim.keymap.set('n', '<Leader>sb', "<CMD>lua require('plugins.telescope.pickers').buffer_search()<CR>", { desc = "Buffer Search" }) -- Buffer Search
    end
  }
}
