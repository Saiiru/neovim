-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                 KORA QUANTUM SEARCH ENGINE - TELESCOPE                  ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- ═════════════════════════════════════════════════════════════════════════
--  TELESCOPE - QUANTUM SEARCH ENGINE
-- ═════════════════════════════════════════════════════════════════════════
--
-- TELESCOPE (BUSCA DE ARQUIVOS):
-- <leader>ff                   -- Buscar arquivos no projeto
-- <leader>fg                   -- Busca texto nos arquivos (live grep)
-- <leader>fb                   -- Lista buffers abertos
-- <leader>fh                   -- Busca na documentação (help)
-- <leader>fr                   -- Arquivos recentes
-- <leader>fc                   -- Trocar tema de cor
-- <leader>sk                   -- Ver todos os atalhos (keymaps)
-- <leader>sc                   -- Lista comandos disponíveis
-- <leader>sd                   -- Diagnósticos do projeto
--
-- No Telescope:
-- <C-j>/<C-k>                  -- Navegar pelos resultados
-- <C-x>                        -- Abrir em split horizontal
-- <C-v>                        -- Abrir em split vertical
-- <C-t>                        -- Abrir em nova aba
-- <Tab>                        -- Marcar múltiplos arquivos
-- <C-q>                        -- Enviar selecionados para quickfix

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                 KORA QUANTUM SEARCH ENGINE - TELESCOPE                  ║
-- ║                    INTEGRATED WITH TROUBLE MATRIX                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- ═════════════════════════════════════════════════════════════════════════
--  TELESCOPE - QUANTUM SEARCH ENGINE
-- ═════════════════════════════════════════════════════════════════════════
--
-- TELESCOPE (BUSCA DE ARQUIVOS):
-- <leader>ff                   -- Buscar arquivos no projeto
-- <leader>fg                   -- Busca texto nos arquivos (live grep)
-- <leader>fb                   -- Lista buffers abertos
-- <leader>fh                   -- Busca na documentação (help)
-- <leader>fr                   -- Arquivos recentes
-- <leader>fc                   -- Trocar tema de cor
-- <leader>sk                   -- Ver todos os atalhos (keymaps)
-- <leader>sc                   -- Lista comandos disponíveis
-- <leader>sd                   -- Diagnósticos do projeto
--
-- TELESCOPE + TROUBLE INTEGRATION:
-- <leader>ft                   -- Find files -> send to Trouble
-- <leader>gt                   -- Live grep -> send to Trouble
-- <leader>dt                   -- Diagnostics -> send to Trouble
-- <leader>lt                   -- LSP symbols -> send to Trouble
--
-- No Telescope:
-- <C-j>/<C-k>                  -- Navegar pelos resultados
-- <C-x>                        -- Abrir em split horizontal
-- <C-v>                        -- Abrir em split vertical
-- <C-t>                        -- Abrir em nova aba
-- <Tab>                        -- Marcar múltiplos arquivos
-- <C-q>                        -- Enviar selecionados para quickfix
-- <C-T>                        -- Enviar para Trouble (NEW)

return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  version = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    "debugloop/telescope-undo.nvim",
    "nvim-telescope/telescope-project.nvim",
    "nvim-telescope/telescope-github.nvim",
    "AckslD/nvim-neoclip.lua",
    "aaronhallaert/advanced-git-search.nvim",
    "nvim-telescope/telescope-media-files.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-dap.nvim",
    "jvgrootveld/telescope-zoxide",
    -- Trouble integration
    "folke/trouble.nvim",
  },
  config = function()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local trouble = require("trouble.sources.telescope")

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🔗 TELESCOPE + TROUBLE INTEGRATION ACTIONS
    -- ═══════════════════════════════════════════════════════════════════════════
    local function send_to_trouble_and_close(prompt_bufnr)
      trouble.open(prompt_bufnr)
    end

    local function send_to_trouble_keep_open(prompt_bufnr)
      trouble.open(prompt_bufnr)
      -- Don't close telescope, useful for comparing results
    end

    -- Enhanced multi-select with Trouble integration
    local select_one_or_multi = function(prompt_bufnr)
      local picker = action_state.get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()
      if not vim.tbl_isempty(multi) then
        actions.close(prompt_bufnr)
        for _, j in pairs(multi) do
          if j.path ~= nil then
            vim.cmd("edit " .. vim.fn.fnameescape(j.path))
          end
        end
      else
        actions.select_default(prompt_bufnr)
      end
    end

    -- Smart quickfix with diagnostics integration
    local function smart_send_to_qflist(prompt_bufnr)
      actions.send_selected_to_qflist(prompt_bufnr)
      actions.open_qflist(prompt_bufnr)

      -- Auto-open Trouble if sending diagnostics to qflist
      local picker = action_state.get_current_picker(prompt_bufnr)
      if picker.prompt_title and picker.prompt_title:match("Diagnostic") then
        vim.defer_fn(function()
          vim.cmd("Trouble qflist toggle")
        end, 100)
      end
    end

    local telescope = require("telescope")
    local telescopeConfig = require("telescope.config")
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
    table.insert(vimgrep_arguments, "--hidden")
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")

    telescope.setup({
      defaults = {
        vimgrep_arguments = vimgrep_arguments,
        prompt_prefix = "   ",
        selection_caret = " ",
        multi_icon = " ",
        entry_prefix = "  ",
        path_display = { "truncate" },
        color_devicons = true,
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.6,
            results_width = 0.8,
          },
          vertical = { mirror = false },
          width = 0.95,
          height = 0.85,
          preview_cutoff = 120,
        },
        sorting_strategy = "ascending",
        scroll_strategy = "cycle",
        selection_strategy = "reset",
        results_title = false,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-q>"] = smart_send_to_qflist,
            ["<C-T>"] = send_to_trouble_and_close, -- NEW: Send to Trouble
            ["<M-T>"] = send_to_trouble_keep_open, -- NEW: Send to Trouble (keep open)
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<esc>"] = actions.close,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<CR>"] = select_one_or_multi,
            ["<C-d>"] = actions.delete_buffer,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
          },
          n = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-T>"] = send_to_trouble_and_close, -- NEW: Send to Trouble
            ["<M-T>"] = send_to_trouble_keep_open, -- NEW: Send to Trouble (keep open)
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["q"] = actions.close,
            ["<esc>"] = actions.close,
            ["<C-d>"] = actions.delete_buffer,
            ["<CR>"] = select_one_or_multi,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["?"] = actions.which_key,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          theme = "ivy",
          previewer = false,
        },
        live_grep = {
          theme = "ivy",
          additional_args = function(opts)
            return { "--hidden" }
          end,
        },
        buffers = {
          theme = "ivy",
          sort_mru = true,
          previewer = false,
          mappings = {
            i = { ["<C-d>"] = actions.delete_buffer },
            n = { ["dd"] = actions.delete_buffer },
          },
        },
        oldfiles = { theme = "dropdown", previewer = false },
        colorscheme = {
          enable_preview = true,
          theme = "dropdown",
        },
        lsp_document_symbols = {
          theme = "dropdown",
          symbol_width = 40,
        },
        lsp_workspace_symbols = {
          theme = "dropdown",
          symbol_width = 40,
        },
        lsp_references = {
          theme = "cursor",
          initial_mode = "normal",
        },
        lsp_definitions = {
          theme = "cursor",
          initial_mode = "normal",
        },
        keymaps = { theme = "dropdown" },
        commands = { theme = "dropdown" },
        diagnostics = {
          theme = "ivy",
          bufnr = nil, -- All buffers
          severity_limit = vim.diagnostic.severity.HINT,
        },
        git_commits = { theme = "ivy" },
        git_status = { theme = "ivy" },
        help_tags = { theme = "dropdown" },
        man_pages = { theme = "dropdown" },
        marks = { theme = "dropdown" },
        registers = { theme = "dropdown" },
        spell_suggest = { theme = "cursor" },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        ["ui-select"] = require("telescope.themes").get_dropdown({
          previewer = false,
          winblend = 10,
          layout_config = { width = 0.5 },
        }),
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = { preview_height = 0.8 },
          mappings = {
            i = {
              ["<CR>"] = require("telescope-undo.actions").restore,
              ["<C-y>"] = require("telescope-undo.actions").yank_additions,
              ["<C-d>"] = require("telescope-undo.actions").yank_deletions,
            },
            n = {
              ["<CR>"] = require("telescope-undo.actions").restore,
              ["y"] = require("telescope-undo.actions").yank_additions,
              ["d"] = require("telescope-undo.actions").yank_deletions,
            },
          },
        },
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
              ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({
                postfix = " --iglob ",
              }),
            },
          },
        },
        project = {
          base_dirs = {
            "~/workspace",
            "~/Work",
            "~/dotfiles",
            { "~/dev", max_depth = 2 },
          },
          hidden_files = true,
          theme = "dropdown",
        },
      },
    })

    -- ═══════════════════════════════════════════════════════════════════════════
    -- SAFE EXTENSION LOADING - NEURAL ERROR PROTECTION
    -- ═══════════════════════════════════════════════════════════════════════════
    local function safe_load_extension(name)
      local ok, _ = pcall(telescope.load_extension, name)
      if not ok then
        print("⚠️ Failed to load telescope extension: " .. name)
      end
    end

    -- Core extensions (sempre funcionam)
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")

    -- Optional extensions (com proteção)
    safe_load_extension("live_grep_args")
    safe_load_extension("undo")
    safe_load_extension("neoclip")
    safe_load_extension("advanced_git_search")
    safe_load_extension("zoxide")
    safe_load_extension("media_files")
    safe_load_extension("file_browser")
    safe_load_extension("dap")
    safe_load_extension("gh")
    safe_load_extension("project")

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🤖 AI-ENHANCED TELESCOPE FUNCTIONS
    -- ═══════════════════════════════════════════════════════════════════════════
    local function telescope_with_ai_context()
      local builtin = require("telescope.builtin")

      -- Get current context for AI
      local current_file = vim.fn.expand("%:t")
      local current_ft = vim.bo.filetype
      local current_dir = vim.fn.expand("%:h")

      -- Smart grep based on context
      local grep_prompt = ""
      if current_ft == "lua" then
        grep_prompt = "function\\|local\\|require"
      elseif current_ft == "javascript" or current_ft == "typescript" then
        grep_prompt = "function\\|const\\|import"
      elseif current_ft == "python" then
        grep_prompt = "def\\|class\\|import"
      elseif current_ft == "go" then
        grep_prompt = "func\\|type\\|import"
      end

      require("telescope").extensions.live_grep_args.live_grep_args({
        default_text = grep_prompt,
        prompt_title = "🤖 AI Context Search (" .. current_ft .. ")",
      })
    end

    local function find_similar_files()
      local current_file = vim.fn.expand("%:t")
      local extension = vim.fn.expand("%:e")
      local basename = vim.fn.expand("%:t:r")

      require("telescope.builtin").find_files({
        prompt_title = "🔍 Similar Files",
        default_text = extension ~= "" and "*." .. extension or basename,
      })
    end

    local function smart_diagnostics()
      local builtin = require("telescope.builtin")
      local diagnostics = vim.diagnostic.get(0)

      if #diagnostics > 0 then
        builtin.diagnostics({
          bufnr = 0,
          prompt_title = "📋 Current Buffer Diagnostics",
        })
      else
        builtin.diagnostics({
          prompt_title = "📋 Workspace Diagnostics",
        })
      end
    end

    -- ═══════════════════════════════════════════════════════════════════════════
    -- KEYMAPS - NEURAL COMMAND MATRIX
    -- ═══════════════════════════════════════════════════════════════════════════
    local builtin = require("telescope.builtin")

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 📁 CORE FILE OPERATIONS
    -- ═══════════════════════════════════════════════════════════════════════════
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "🔍 Find Files" })
    vim.keymap.set("n", "<leader>fg", function()
      require("telescope").extensions.live_grep_args.live_grep_args()
    end, { desc = "🔍 Live Grep (Args)" })
    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "🔍 Find Word Under Cursor" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "📄 Buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "❓ Help" })
    vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "🕐 Recent Files" })
    vim.keymap.set("n", "<leader>fc", builtin.colorscheme, { desc = "🎨 Colorscheme" })

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🔗 TELESCOPE + TROUBLE INTEGRATION
    -- ═══════════════════════════════════════════════════════════════════════════
    vim.keymap.set("n", "<leader>ft", function()
      builtin.find_files({
        attach_mappings = function(_, map)
          map("i", "<CR>", function(prompt_bufnr)
            send_to_trouble_and_close(prompt_bufnr)
          end)
          return true
        end,
      })
    end, { desc = "🔍 Find Files → Trouble" })

    vim.keymap.set("n", "<leader>gt", function()
      require("telescope").extensions.live_grep_args.live_grep_args({
        attach_mappings = function(_, map)
          map("i", "<CR>", function(prompt_bufnr)
            send_to_trouble_and_close(prompt_bufnr)
          end)
          return true
        end,
      })
    end, { desc = "🔍 Live Grep → Trouble" })

    vim.keymap.set("n", "<leader>dt", function()
      builtin.diagnostics({
        attach_mappings = function(_, map)
          map("i", "<CR>", function(prompt_bufnr)
            send_to_trouble_and_close(prompt_bufnr)
          end)
          return true
        end,
      })
    end, { desc = "🚨 Diagnostics → Trouble" })

    vim.keymap.set("n", "<leader>lt", function()
      builtin.lsp_document_symbols({
        attach_mappings = function(_, map)
          map("i", "<CR>", function(prompt_bufnr)
            send_to_trouble_and_close(prompt_bufnr)
          end)
          return true
        end,
      })
    end, { desc = "🔖 LSP Symbols → Trouble" })

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🛠️ UTILITIES & SYSTEM
    -- ═══════════════════════════════════════════════════════════════════════════
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "🗝️ Keymaps" })
    vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "⚡ Commands" })
    vim.keymap.set("n", "<leader>sd", smart_diagnostics, { desc = "🚨 Smart Diagnostics" })
    vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "🏷️ Marks" })
    vim.keymap.set("n", "<leader>sr", builtin.registers, { desc = "📋 Registers" })
    vim.keymap.set("n", "<leader>sp", builtin.spell_suggest, { desc = "📝 Spell Suggest" })

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🧠 LSP OPERATIONS
    -- ═══════════════════════════════════════════════════════════════════════════
    vim.keymap.set(
      "n",
      "<leader>ls",
      builtin.lsp_document_symbols,
      { desc = "🔖 Document Symbols" }
    )
    vim.keymap.set(
      "n",
      "<leader>lS",
      builtin.lsp_workspace_symbols,
      { desc = "🏢 Workspace Symbols" }
    )
    vim.keymap.set("n", "<leader>ld", builtin.lsp_definitions, { desc = "📍 Definitions" })
    vim.keymap.set("n", "<leader>lr", builtin.lsp_references, { desc = "🔗 References" })
    vim.keymap.set(
      "n",
      "<leader>li",
      builtin.lsp_implementations,
      { desc = "⚙️ Implementations" }
    )
    vim.keymap.set(
      "n",
      "<leader>lT",
      builtin.lsp_type_definitions,
      { desc = "🏷️ Type Definitions" }
    )

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🌿 GIT OPERATIONS
    -- ═══════════════════════════════════════════════════════════════════════════
    vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "🌿 Git Commits" })
    vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "🌿 Git Status" })
    vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "🌿 Git Branches" })
    vim.keymap.set("n", "<leader>gh", builtin.git_bcommits, { desc = "🌿 Buffer Commits" })

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🤖 AI-ENHANCED FUNCTIONS
    -- ═══════════════════════════════════════════════════════════════════════════
    vim.keymap.set(
      "n",
      "<leader>fa",
      telescope_with_ai_context,
      { desc = "🤖 AI Context Search" }
    )
    vim.keymap.set("n", "<leader>fs", find_similar_files, { desc = "🔍 Find Similar Files" })

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🔨 ADVANCED EXTENSIONS
    -- ═══════════════════════════════════════════════════════════════════════════
    vim.keymap.set("n", "<leader>zn", function()
      if pcall(require, "telescope.extensions.neoclip") then
        require("telescope").extensions.neoclip.default()
      else
        print("⚠️ Neoclip extension not available")
      end
    end, { desc = "📋 Clipboard History" })

    vim.keymap.set("n", "<leader>zu", function()
      if pcall(require, "telescope.extensions.undo") then
        require("telescope").extensions.undo.undo()
      else
        print("⚠️ Undo extension not available")
      end
    end, { desc = "🔄 Undo Tree" })

    vim.keymap.set("n", "<leader>zp", function()
      if pcall(require, "telescope.extensions.project") then
        require("telescope").extensions.project.project()
      else
        print("⚠️ Project extension not available")
      end
    end, { desc = "📁 Projects" })

    vim.keymap.set("n", "<leader>zm", function()
      if pcall(require, "telescope.extensions.media_files") then
        require("telescope").extensions.media_files.media_files()
      else
        print("⚠️ Media files extension not available")
      end
    end, { desc = "🎬 Media Files" })

    vim.keymap.set("n", "<leader>zf", function()
      if pcall(require, "telescope.extensions.file_browser") then
        require("telescope").extensions.file_browser.file_browser({
          path = "%:p:h",
          cwd = vim.fn.expand("%:p:h"),
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
        })
      else
        print("⚠️ File browser extension not available")
      end
    end, { desc = "📁 File Browser" })

    vim.keymap.set("n", "<leader>zd", function()
      if pcall(require, "telescope.extensions.dap") then
        require("telescope").extensions.dap.commands()
      else
        print("⚠️ DAP extension not available")
      end
    end, { desc = "🐛 DAP Commands" })

    vim.keymap.set("n", "<leader>zg", function()
      if pcall(require, "telescope.extensions.gh") then
        require("telescope").extensions.gh.issues()
      else
        print("⚠️ GitHub extension not available")
      end
    end, { desc = "🐙 GitHub Issues" })

    vim.keymap.set("n", "<leader>zz", function()
      if pcall(require, "telescope.extensions.zoxide") then
        require("telescope").extensions.zoxide.list()
      else
        print("⚠️ Zoxide extension not available")
      end
    end, { desc = "⚡ Zoxide Jump" })

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🎯 QUICK ACCESS & UTILITIES
    -- ═══════════════════════════════════════════════════════════════════════════

    -- Fast in-buffer search with dropdown
    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
        layout_config = { width = 0.7 },
        prompt_title = "🔍 Search in " .. vim.fn.expand("%:t"),
      }))
    end, { desc = "🔍 Fuzzy search in buffer" })

    -- Resume last telescope session
    vim.keymap.set("n", "<leader>f.", builtin.resume, { desc = "🔄 Resume last search" })

    -- Search in directory of current file
    vim.keymap.set("n", "<leader>fd", function()
      builtin.find_files({
        cwd = vim.fn.expand("%:p:h"),
        prompt_title = "🔍 Find in " .. vim.fn.expand("%:h"),
      })
    end, { desc = "🔍 Find in current directory" })

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🎮 CONDITIONAL COMMANDS BASED ON CONTEXT
    -- ═══════════════════════════════════════════════════════════════════════════
    vim.api.nvim_create_user_command("TelescopeProjectFiles", function()
      local is_git_repo =
        vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):match("true")
      if is_git_repo then
        builtin.git_files({ show_untracked = true })
      else
        builtin.find_files()
      end
    end, { desc = "Smart project files (git-aware)" })

    vim.keymap.set(
      "n",
      "<leader>fF",
      "<cmd>TelescopeProjectFiles<cr>",
      { desc = "🎯 Smart Project Files" }
    )

    -- ═══════════════════════════════════════════════════════════════════════════
    -- 🎨 ENHANCED AUTOCMDS
    -- ═══════════════════════════════════════════════════════════════════════════
    vim.api.nvim_create_autocmd("User", {
      pattern = "TelescopePreviewerLoaded",
      callback = function()
        vim.wo.number = true
        vim.wo.wrap = true
      end,
    })
  end,
}

--[[
# 🚀 TELESCOPE ENHANCED CHEATSHEET (KORA Quantum Search Engine)

## 📁 Core File Operations
| Key            | Action                      | Theme/Layout           |
|----------------|----------------------------|------------------------|
| `<leader>ff`   | Find Files                 | ivy (no preview)       |
| `<leader>fg`   | Live Grep (with args)      | ivy                    |
| `<leader>fw`   | Find Word Under Cursor     | default                |
| `<leader>fb`   | Buffers                    | ivy (no preview)       |
| `<leader>fr`   | Recent Files               | dropdown (no preview)  |
| `<leader>fc`   | Colorscheme                | dropdown (with preview)|
| `<leader>fd`   | Find in Current Directory  | default                |
| `<leader>fF`   | Smart Project Files        | git-aware              |
| `<leader>f.`   | Resume Last Search         | previous picker        |

## 🔗 Telescope + Trouble Integration (NEW!)
| Key            | Action                      | Integration            |
|----------------|----------------------------|------------------------|
| `<leader>ft`   | Find Files → Trouble       | Send results to Trouble|
| `<leader>gt`   | Live Grep → Trouble        | Send results to Trouble|
| `<leader>dt`   | Diagnostics → Trouble      | Send results to Trouble|
| `<leader>lt`   | LSP Symbols → Trouble      | Send results to Trouble|

## 🔧 Utilities & System
| Key            | Action                      | Theme/Layout           |
|----------------|----------------------------|------------------------|
| `<leader>sk`   | Keymaps                    | dropdown               |
| `<leader>sc`   | Commands                   | dropdown               |
| `<leader>sd`   | Smart Diagnostics          | ivy/dropdown           |
| `<leader>sm`   | Marks                      | dropdown               |
| `<leader>sr`   | Registers                  | dropdown               |
| `<leader>sp`   | Spell Suggest              | cursor                 |
| `<leader>fh`   | Help Tags                  | dropdown               |
| `<leader>/`    | Fuzzy search in buffer     | dropdown (no preview)  |

## 🧠 LSP Operations (Enhanced)
| Key            | Action                      | Theme/Layout           |
|----------------|----------------------------|------------------------|
| `<leader>ls`   | Document Symbols           | dropdown               |
| `<leader>lS`   | Workspace Symbols          | dropdown               |
| `<leader>ld`   | Definitions                | cursor                 |
| `<leader>lr`   | References                 | cursor                 |
| `<leader>li`   | Implementations            | cursor                 |
| `<leader>lT`   | Type Definitions           | cursor                 |

## 🌿 Git Operations (Enhanced)
| Key            | Action                      | Theme/Layout           |
|----------------|----------------------------|------------------------|
| `<leader>gc`   | Git Commits                | ivy                    |
| `<leader>gs`   | Git Status                 | ivy                    |
| `<leader>gb`   | Git Branches               | ivy                    |
| `<leader>gh`   | Buffer Git History         | ivy                    |

## 🤖 AI-Enhanced Functions (NEW!)
| Key            | Action                      | Description            |
|----------------|----------------------------|------------------------|
| `<leader>fa`   | AI Context Search          | Smart grep by filetype |
| `<leader>fs`   | Find Similar Files         | Based on extension     |

## 🔨 Advanced Extensions
| Key            | Action                      | Extension              |
|----------------|----------------------------|------------------------|
| `<leader>zn`   | Clipboard History          | neoclip                |
| `<leader>zu`   | Undo Tree                  | undo                   |
| `<leader>zp`   | Projects                   | project                |
| `<leader>zm`   | Media Files                | media_files            |
| `<leader>zf`   | File Browser               | file_browser           |
| `<leader>zd`   | DAP Commands               | dap                    |
| `<leader>zg`   | GitHub Issues              | gh                     |
| `<leader>zz`   | Zoxide Jump                | zoxide                 |

## 🎮 Navigation inside Telescope (Enhanced)
| Key              | Action                    |
|------------------|---------------------------|
| `<C-j>/<C-k>`    | Next/prev result          |
| `<Tab>/<S-Tab>`  | Mark/unmark result        |
| `<C-q>`          | Send to quickfix          |
| `<C-T>`          | Send to Trouble (close)   |
| `<M-T>`          | Send to Trouble (keep)    |
| `<C-x>`          | Open in horizontal split  |
| `<C-v>`          | Open in vertical split    |
| `<C-t>`          | Open in new tab           |
| `<CR>`           | Open (multi if marked)    |
| `<C-d>`          | Delete buffer (buffers)   |
| `<C-u>/<C-d>`    | Scroll preview up/down    |
| `<esc>`          | Close picker              |
| `?`              | Show help (normal mode)   |

## 🎨 Smart Features
- **Context-aware**: Different behavior based on current file/project
- **Git integration**: Automatic git-file detection
- **AI-enhanced**: Smart search patterns by filetype
- **Trouble integration**: Seamless workflow with diagnostics
- **Performance**: Smart loading and error protection
- **Themes**: Optimized layouts for different use cases

## 🛡️ Error Protection
- Extensions load with `pcall` protection
- Safe fallbacks for missing extensions
- LSP builtins used instead of problematic extensions
- Clear error messages when extensions fail
- Graceful degradation for missing dependencies

## 🎨 Themes Used
- **ivy**: File operations, git, grep (compact, bottom)
- **dropdown**: Utils, help, symbols (centered popup)
- **cursor**: LSP navigation (minimal overlay)
- **default**: Full-featured with preview

]]
