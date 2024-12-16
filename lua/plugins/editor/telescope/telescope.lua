local symbols_prefix = "<leader>ss"
local symbols_workspace_prefix = "<leader>sS"
local actions = require "telescope.actions"

return {
  { import = "lazyvim.plugins.extras.editor.telescope" },
  {
    "nvim-telescope/telescope.nvim",
    -- stylua: ignore
    keys = {
      {
        symbols_prefix .. "a",
        function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Struct", "Trait", "Field", "Property", "Enum", "Constant" } }) end,
        desc = "All",
      },
      { symbols_prefix .. "c", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Class" } }) end, desc = "Class" },
      { symbols_prefix .. "f", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Function" } }) end, desc = "Function" },
      { symbols_prefix .. "m", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Method" } }) end, desc = "Method" },
      { symbols_prefix .. "C", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Constructor" } }) end, desc = "Constructor" },
      { symbols_prefix .. "e", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Enum" } }) end, desc = "Enum" },
      { symbols_prefix .. "i", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Interface" } }) end, desc = "Interface" },
      { symbols_prefix .. "M", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Module" } }) end, desc = "Module" },
      { symbols_prefix .. "s", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Struct" } }) end, desc = "Struct" },
      { symbols_prefix .. "t", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Trait" } }) end, desc = "Trait" },
      { symbols_prefix .. "F", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Field" } }) end, desc = "Field" },
      { symbols_prefix .. "p", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Property" } }) end, desc = "Property" },
      { symbols_prefix .. "v", function() require("telescope.builtin").lsp_document_symbols({ symbols = { "Variable", "Parameter" } }) end, desc = "Variable" },
      {
        symbols_workspace_prefix .. "a",
        function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Struct", "Trait", "Field", "Property", "Enum", "Constant" } }) end,
        desc = "All",
      },
      { symbols_workspace_prefix .. "c", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Class" } }) end, desc = "Class" },
      { symbols_workspace_prefix .. "f", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Function" } }) end, desc = "Function" },
      { symbols_workspace_prefix .. "m", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Method" } }) end, desc = "Method" },
      { symbols_workspace_prefix .. "C", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Constructor" } }) end, desc = "Constructor" },
      { symbols_workspace_prefix .. "e", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Enum" } }) end, desc = "Enum" },
      { symbols_workspace_prefix .. "i", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "interface" } }) end, desc = "interface" },
      { symbols_workspace_prefix .. "M", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Module" } }) end, desc = "Module" },
      { symbols_workspace_prefix .. "s", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Struct" } }) end, desc = "Struct" },
      { symbols_workspace_prefix .. "t", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Trait" } }) end, desc = "Trait" },
      { symbols_workspace_prefix .. "F", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Field" } }) end, desc = "Field" },
      { symbols_workspace_prefix .. "p", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Property" } }) end, desc = "Property" },
      { symbols_workspace_prefix .. "v", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "Variable", "Parameter" } }) end, desc = "Variable" },
      { "<leader>sA", require("telescope.builtin").treesitter, desc = "Treesitter Symbols" },
      { "<leader>sP", "<cmd>Telescope builtin<cr>", desc = "Pickers (Telescope)" },
      { "<leader>fh", require("telescope.builtin").find_files, desc = "Find Files (hidden)" },
      { "<leader><c-space>", require("telescope.builtin").find_files, desc = "Find Files (hidden)" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
      { "<leader>S", "<cmd>Telescope spell_suggest<cr>", desc = "Spelling" },
      { "<leader>gs", false },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<S-esc>"] = actions.close,
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
            ["<c-l>"] = require("telescope.actions.layout").cycle_layout_next,
            ["<a-l>"] = require("telescope.actions.layout").cycle_layout_prev,
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<C-Tab>"] = require("telescope.actions").select_tab_drop,
            ["<M-h>"] = require("telescope.actions").results_scrolling_left,
            ["<M-l>"] = require("telescope.actions").results_scrolling_right,
          },
        },
        file_ignore_patterns = {
          ".gitignore",
          "node_modules",
          "build",
          "dist",
          "yarn.lock",
          "*.git/*",
          "*/tmp/*",
        },
      },
      pickers = {
        find_files = {
          hidden = false,
        },
        buffers = {
          layout_config = {
            height = 0.7,
            width = 0.7,
          },
          mappings = {
            i = {
              ["<c-r>"] = require("telescope.actions").delete_buffer,
            },
          },
        },
        spell_suggest = {
          layout_config = {
            prompt_position = "top",
            height = 0.3,
            width = 0.25,
          },
          sorting_strategy = "ascending",
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {},
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { symbols_prefix, group = "goto symbols", icon = " " },
        { symbols_workspace_prefix, group = "goto symbols (Workspace)", icon = " " },
      },
    },
  },
}
