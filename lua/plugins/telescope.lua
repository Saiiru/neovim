local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
  },
}

function M.config()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local icons = require("icons") -- Adjust this to match your icon configuration.
  local wk = require("which-key")

  -- Register keymaps with "Telescope" group and nerd icon
  wk.add({
    ["<leader>f"] = { name = icons.ui.Telescope .. " Telescope" }, -- Group with icon
    ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find Files" },
    ["<leader>fb"] = { "<cmd>Telescope git_branches<cr>", "Git Branches" },
    ["<leader>fc"] = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    ["<leader>fp"] = { function() telescope.extensions.projects.projects() end, "Projects" },
    ["<leader>ft"] = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    ["<leader>fh"] = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
    ["<leader>fl"] = { "<cmd>Telescope resume<cr>", "Resume Search" },
    ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
  })

  -- Telescope setup
  telescope.setup({
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
      colorscheme = { enable_preview = true },
      lsp_references = { theme = "dropdown", initial_mode = "normal" },
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
    },
  })

  -- Load extensions
  telescope.load_extension("fzf")
end

return M

