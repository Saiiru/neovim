-- =============================================================================
--  Telescope — busca poderosa com integrações cuidadosas
--  -----------------------------------------------------------------------------
--  Decisões:
--   - Carrega extensões com pcall, evitando erro caso não estejam instaladas.
--   - Defaults ajustados p/ performance e UX (fzf-native, live grep com args).
--   - Keymaps ficam aqui (keys = {}), não no core, p/ lazy-load correto.
-- =============================================================================
return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  branch = "master", -- estável: '0.1.x'; master corrige avisos recentes do Neovim
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = function() return vim.fn.executable("make") == 1 end },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    -- extensões opcionais (descomente se usar):
    "debugloop/telescope-undo.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    -- "AckslD/nvim-neoclip.lua",
  },

  -- Keymaps do líder (Find) — ficam aqui para lazy-load
  keys = (function()
    local builtin = require("telescope.builtin")
    local lga = function() return require("telescope").extensions.live_grep_args.live_grep_args() end

    local function smart_files()
      local gitdir = vim.fn.finddir(".git", ".;")
      if gitdir ~= "" then
        builtin.git_files({ show_untracked = true })
      else
        builtin.find_files()
      end
    end

    return {
      -- Arquivos / Projetos
      { "<leader>ff", smart_files,                                         desc = "Find files (smart git)" },
      { "<leader>fF", function() builtin.find_files({ hidden = true }) end,desc = "Find files (hidden)" },
      { "<leader>fr", builtin.oldfiles,                                    desc = "Recent files" },
      { "<leader>fm", builtin.marks,                                       desc = "Marks" },
      { "<leader>fR", builtin.registers,                                   desc = "Registers" },

      -- Grep
      { "<leader>fg", lga,                                                 desc = "Live grep (args)" },
      { "<leader>f/", function()
          builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false }))
        end,                                                               desc = "Fuzzy in current buffer" },

      -- LSP (somente pickers; integra com LSP já carregado)
      { "<leader>fs", builtin.lsp_document_symbols,                        desc = "LSP document symbols" },
      { "<leader>fS", builtin.lsp_workspace_symbols,                       desc = "LSP workspace symbols" },

      -- Git
      { "<leader>gc", builtin.git_commits,                                 desc = "Git commits" },
      { "<leader>gC", builtin.git_bcommits,                                desc = "Git commits (buffer)" },
      { "<leader>gs", builtin.git_status,                                  desc = "Git status" },
      { "<leader>gb", builtin.git_branches,                                desc = "Git branches" },

      -- Diversos
      { "<leader>fk", builtin.keymaps,                                     desc = "Keymaps" },
      { "<leader>fh", builtin.help_tags,                                   desc = "Help tags" },
      { "<leader>fp", builtin.pickers,                                     desc = "Previous pickers" },
      { "<leader>f.", builtin.resume,                                      desc = "Resume last picker" },
    }
  end)(),

  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local conf = require("telescope.config")

    -- Extend vimgrep arguments (ripgrep)
    local vimgrep_arguments = vim.deepcopy(conf.values.vimgrep_arguments)
    -- incluímos ocultos, mas filtramos .git
    table.insert(vimgrep_arguments, "--hidden")
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")

    -- Integração opcional com Trouble (se instalado)
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
            ["<C-u>"] = false,                   -- deixe <C-u> p/ limpador de linha do insert nativo
            ["<C-d>"] = actions.delete_buffer,   -- em buffers picker
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<C-t>"] = with_trouble(actions.select_default), -- abre no Trouble se presente
            ["<Esc>"] = actions.close,
            -- multiselect: <Tab> marca; <CR> abre todos marcados
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

    -- Carrega extensões com pcall para evitar erro se ausentes
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "live_grep_args")
    pcall(telescope.load_extension, "undo")
    pcall(telescope.load_extension, "file_browser")
    -- pcall(telescope.load_extension, "neoclip")
  end,
}

