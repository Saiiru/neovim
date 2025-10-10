-- lua/plugins/ui/telescope.lua :: Fuzzy finder com integrações.

return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = function() return vim.fn.executable("make") == 1 end },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    "debugloop/telescope-undo.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },

  keys = (function()
    local builtin = require("telescope.builtin")
    local lga = function() return require("telescope").extensions.live_grep_args.live_grep_args() end

    -- Busca arquivos do git ou todos os arquivos se não estiver em um repositório git.
    local function smart_files()
      local gitdir = vim.fn.finddir(".git", ".;")
      if gitdir ~= "" then
        builtin.git_files({ show_untracked = true })
      else
        builtin.find_files()
      end
    end

    return {
      { "<leader>ff", smart_files, desc = "Find files (smart git)" },
      { "<leader>fF", function() builtin.find_files({ hidden = true }) end, desc = "Find files (hidden)" },
      { "<leader>fr", builtin.oldfiles, desc = "Recent files" },
      { "<leader>fm", builtin.marks, desc = "Marks" },
      { "<leader>fR", builtin.registers, desc = "Registers" },
      { "<leader>fg", lga, desc = "Live grep (args)" },
      { "<leader>f/", function()
          builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false }))
        end, desc = "Fuzzy in current buffer" },
      { "<leader>fs", builtin.lsp_document_symbols, desc = "LSP document symbols" },
      { "<leader>fS", builtin.lsp_workspace_symbols, desc = "LSP workspace symbols" },
      { "<leader>gc", builtin.git_commits, desc = "Git commits" },
      { "<leader>gC", builtin.git_bcommits, desc = "Git commits (buffer)" },
      { "<leader>gs", builtin.git_status, desc = "Git status" },
      { "<leader>gb", builtin.git_branches, desc = "Git branches" },
      { "<leader>fk", builtin.keymaps, desc = "Keymaps" },
      { "<leader>fh", builtin.help_tags, desc = "Help tags" },
      { "<leader>fp", builtin.pickers, desc = "Previous pickers" },
      { "<leader>f.", builtin.resume, desc = "Resume last picker" },
    }
  end)(),

  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local conf = require("telescope.config")

    local vimgrep_arguments = vim.deepcopy(conf.values.vimgrep_arguments)
    table.insert(vimgrep_arguments, "--hidden")
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")

    local trouble_ok, trouble_actions = pcall(function()
      return require("trouble.providers.telescope")
    end)

    local function with_trouble(action)
      if trouble_ok then return trouble_actions.open end
      return action
    end

    telescope.setup({
      defaults = {
        vimgrep_arguments = vimgrep_arguments,
        prompt_prefix = "   ",
        selection_caret = "❯ ",
        entry_prefix = "  ",
        path_display = { "truncate" },
        dynamic_preview_title = true,
        sorting_strategy = "ascending",
        layout_strategy = "flex",
        layout_config = {
          prompt_position = "top",
          width = 0.95,
          height = 0.90,
          horizontal = { preview_width = 0.55 },
          vertical   = { preview_height = 0.55 },
          flex = { flip_columns = 160 },
        },
        file_ignore_patterns = {
          "%.git/", "node_modules/", "target/", "dist/", "build/", ".venv/", "__pycache__/", ".next/",
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-u>"] = false,
            ["<C-d>"] = actions.delete_buffer,
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<C-t>"] = with_trouble(actions.select_default),
            ["<Esc>"] = actions.close,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<CR>"] = function(prompt_bufnr)
              local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
              local multi = picker:get_multi_selection()
              if not vim.tbl_isempty(multi) then
                actions.close(prompt_bufnr)
                for _, entry in ipairs(multi) do
                  if entry.path or entry.filename then
                    vim.cmd.edit(entry.path or entry.filename)
                  end
                end
              else
                actions.select_default(prompt_bufnr)
              end
            end,
          },
          n = {
            ["q"] = actions.close,
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<C-t>"] = with_trouble(actions.select_default),
          },
        },
        preview = {
          msg_bg_fillchar = " ",
          treesitter = true,
        },
      },

      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          previewer = false,
        },
        buffers = {
          sort_lastused = true,
          ignore_current_buffer = true,
          mappings = { i = { ["<C-d>"] = actions.delete_buffer } },
        },
        lsp_document_symbols = {
          symbol_width = 60,
          show_line = true,
          fname_width = 30,
          path_display = { "truncate" },
        },
      },

      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown({ previewer = false }) },
        ["undo"] = { use_delta = true, side_by_side = false, },
        ["file_browser"] = { grouped = true, hijack_netrw = true, },
      },
    })

    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "live_grep_args")
    pcall(telescope.load_extension, "undo")
    pcall(telescope.load_extension, "file_browser")
  end,
}

