return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    "debugloop/telescope-undo.nvim",
    "nvim-neoclip/neoclip.nvim",
    "andrew-george/telescope-themes",
    -- opcional (se tiver noice):
    { "folke/noice.nvim", optional = true },
    -- opcional (git avançado):
    { "aaronhallaert/advanced-git-search.nvim", dependencies = { "tpope/vim-fugitive" }, optional = true },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local conf = require("telescope.config").values

    -- ripgrep: inclui ocultos, exclui .git
    local vimgrep = { unpack(conf.vimgrep_arguments) }
    table.insert(vimgrep, "--hidden")
    table.insert(vimgrep, "--glob")
    table.insert(vimgrep, "!**/.git/*")

    local function select_one_or_multi(prompt_bufnr)
      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()
      if not vim.tbl_isempty(multi) then
        actions.close(prompt_bufnr)
        for _, entry in ipairs(multi) do
          if entry.path then vim.cmd("edit " .. vim.fn.fnameescape(entry.path)) end
        end
      else
        actions.select_default(prompt_bufnr)
      end
    end

    telescope.setup({
      defaults = {
        vimgrep_arguments = vimgrep,
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-j>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<CR>"] = select_one_or_multi,
          },
          n = {
            ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
      },
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
        undo = {
          use_delta = true,
          side_by_side = false,
          entry_format = "state #$ID, $STAT, $TIME",
        },
        themes = {
          enable_previewer = true,
          enable_live_preview = true,
          persist = {
            enabled = true,
            path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua",
          },
        },
      },
    })

    -- carregar extensões
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "live_grep_args")
    pcall(telescope.load_extension, "undo")
    pcall(telescope.load_extension, "neoclip")
    pcall(telescope.load_extension, "themes")
    pcall(telescope.load_extension, "noice")
    pcall(telescope.load_extension, "advanced_git_search")

    -- keymaps <leader>f*
    local builtin = require("telescope.builtin")
    local lga = require("telescope").extensions.live_grep_args

    local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc }) end
    map("<leader>ff", builtin.find_files, "Find Files")
    map("<leader>fg", lga.live_grep_args, "Live Grep (args)")
    map("<leader>fb", builtin.buffers, "Find Buffers")
    map("<leader>fo", builtin.oldfiles, "Recent Files")
    map("<leader>fw", builtin.grep_string, "Find Word under Cursor")
    map("<leader>fs", builtin.lsp_document_symbols, "Symbols (buffer)")
    map("<leader>fS", builtin.lsp_workspace_symbols, "Symbols (workspace)")
    map("<leader>fh", builtin.help_tags, "Help Tags")
    map("<leader>fk", builtin.keymaps, "Keymaps")
    map("<leader>f/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10, previewer = false, layout_config = { width = 0.7 },
      }))
    end, "Fuzzy in Buffer")
    map("<leader>fu", require("telescope").extensions.undo.undo, "Undo Tree")
    map("<leader>fy", require("telescope").extensions.neoclip.default, "Yanks (Neoclip)")
    map("<leader>ft", require("telescope").extensions.themes.themes, "Theme Switcher")
    map("<leader>fgc", builtin.git_commits, "Git Commits")
    map("<leader>fgb", builtin.git_bcommits, "Git Buffer Commits")
    map("<leader>fas", function() require("telescope").extensions.advanced_git_search.search_log_content() end, "Advanced Git Search")
  end,
}

