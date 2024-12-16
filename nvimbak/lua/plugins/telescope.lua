local Lsp = require "utils.lsp"

local function symbols_filter(entry, ctx)
  if ctx.symbols_filter == nil then
    ctx.symbols_filter = Lsp.get_kind_filter(ctx.bufnr) or false
  end
  if ctx.symbols_filter == false then
    return true
  end
  return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

local M = {
  {
    "ahmedkhalf/project.nvim",
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
  },
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    opts = {
      hls = {
        border = "FloatBorder",
        cursorline = "Visual",
        cursorlinenr = "Visual",
        backdrop = "FzfLuaBackdrop",
      },
      fzf_colors = false,
      fzf_opts = {
        ["--history"] = vim.fn.stdpath "data" .. "/fzf-lua-history",
        ["--info"] = false,
        ["--border"] = false,
        ["--preview-window"] = false,
        ["--no-scrollbar"] = true,
      },
      winopts = {
        width = 0.8,
        height = 0.8,
        row = 0.5,
        col = 0.5,
        preview = {
          layout = "flex",
          flip_columns = 130,
          scrollchars = { "┃", "" },
        },
        backdrop = 60,
      },
      files = {
        multiprocess = true,
        git_icons = false,
        file_icons = false,
      },
      grep = {
        multiprocess = true,
      },
      git = {
        files = {
          multiprocess = true,
        },
        status = {
          winopts = {
            preview = { vertical = "down:70%", horizontal = "right:70%" },
          },
        },
        commits = { winopts = { preview = { vertical = "down:60%" } } },
        bcommits = { winopts = { preview = { vertical = "down:60%" } } },
        branches = {
          winopts = {
            preview = { vertical = "down:75%", horizontal = "right:75%" },
          },
        },
      },
      defaults = {
        formatter = { "path.filename_first", 2 },
      },
      lsp = {
        symbols = {
          symbol_hl = function(s)
            return "TroubleIcon" .. s
          end,
          symbol_fmt = function(s)
            return s:lower() .. "\t"
          end,
          child_prefix = false,
          path_shorten = 1,
        },
        code_actions = {
          winopts = {
            preview = { layout = "reverse-list", horizontal = "right:75%" },
          },
        },
      },
    },
    config = function(_, options)
      local fzf_lua = require "fzf-lua"
      local actions = require "fzf-lua.actions"
      local config = require "fzf-lua.config"

      config.defaults.actions.files["alt-."] = actions.toggle_hidden
      config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open

      fzf_lua.setup(options)
      fzf_lua.register_ui_select(function(_, items)
        local min_h, max_h = 0.60, 0.80
        local h = (#items + 4) / vim.o.lines
        if h < min_h then
          h = min_h
        elseif h > max_h then
          h = max_h
        end
        return { winopts = { height = h, width = 0.80, row = 0.40 } }
      end)

      vim.lsp.handlers["textDocument/codeAction"] = fzf_lua.lsp_code_actions
      vim.lsp.handlers["textDocument/definition"] = function()
        fzf_lua.lsp_definitions { jump_to_single_result = true, ignore_current_line = true }
      end
      vim.lsp.handlers["textDocument/declaration"] = fzf_lua.lsp_declarations
      vim.lsp.handlers["textDocument/typeDefinition"] = fzf_lua.lsp_typedefs
      vim.lsp.handlers["textDocument/implementation"] = fzf_lua.lsp_implementations
      vim.lsp.handlers["textDocument/documentSymbol"] = fzf_lua.lsp_document_symbols
      vim.lsp.handlers["workspace/symbol"] = fzf_lua.lsp_workspace_symbols
      vim.lsp.handlers["callHierarchy/incomingCalls"] = fzf_lua.lsp_incoming_calls
      vim.lsp.handlers["callHierarchy/outgoingCalls"] = fzf_lua.lsp_outgoing_calls
    end,
    keys = {
      { "<esc>", "<cmd>close<cr>", ft = "fzf", mode = "t", nowait = true },
      { "<c-j>", "<Down>", ft = "fzf", mode = "t", nowait = true },
      { "<c-k>", "<Up>", ft = "fzf", mode = "t", nowait = true },
      { "<C-g>", "<cmd> :FzfLua grep_project<CR>", desc = "Find Grep" },
      {
        "<C-g>",
        function()
          local root_dir = require("utils.root").get()
          local fzf_lua = require "fzf-lua"
          fzf_lua.grep_visual {
            cwd = root_dir,
            rg_opts = "--column --hidden --smart-case --color=always --no-heading --line-number -g '!{.git,node_modules}/'",
            multiprocess = true,
          }
        end,
        desc = "Search Grep in visual selection",
        mode = "v",
      },
      {
        "<leader>sw",
        function()
          local root_dir = require("utils.root").git()
          local fzf_lua = require "fzf-lua"
          fzf_lua.grep_visual {
            cwd = root_dir,
            rg_opts = "--column --hidden --smart-case --color=always --no-heading --line-number -g '!{.git,node_modules}/'",
            multiprocess = true,
          }
        end,
        desc = "Search word in visual selection (git root)",
        mode = "v",
      },
      {
        "<leader>fg",
        "<cmd> :FzfLua grep_project --cmd 'git grep --line-number --column --color=always'<CR>",
        desc = "Find Git Grep",
      },
      { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Find Buffers" },
      { "<leader>,", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
      {
        "<leader>fr",
        function()
          local root_dir = require("utils.root").git()
          require("fzf-lua").oldfiles { cwd = root_dir }
        end,
        desc = "Find Recent Files",
      },
      { "<leader>fR", "<cmd> :FzfLua resume<CR>", desc = "Resume Fzf" },
      {
        "<leader>fl",
        function()
          local root_dir = require("utils.root").git()
          local fzf_lua = require "fzf-lua"
          fzf_lua.live_grep {
            cwd = root_dir,
            rg_opts = "--column --hidden --smart-case --color=always --no-heading --line-number -g '!{.git,node_modules}/'",
            multiprocess = true,
          }
        end,
        desc = "Find Live Grep (including hidden files)",
      },
      {
        "<C-e>",
        function()
          local root_dir = require("utils.root").get()
          require("fzf-lua").files {
            cwd = root_dir,
            cwd_prompt = false,
          }
        end,
        desc = "Find Files at project directory",
      },
      {
        "<leader><space>",
        function()
          local root_dir = require("utils.root").git()
          require("fzf-lua").files {
            cwd = root_dir,
            cwd_prompt = false,
          }
        end,
        desc = "Find Files at project directory",
      },
      {
        "<leader>/",
        function()
          local root_dir = require("utils.root").get()
          require("fzf-lua").live_grep { cwd = root_dir, multiprocess = true }
        end,
        desc = "Grep Files at current directory",
      },
      {
        "<leader>ff",
        function()
          local root_dir = require("utils.root").git()
          require("fzf-lua").git_files { cwd = root_dir }
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fc",
        function()
          require("fzf-lua").files { cwd = "~/.config/nvim" }
        end,
        desc = "Find Neovim Configs",
      },
      { "<leader>sb", "<cmd> :FzfLua grep_curbuf<CR>", desc = "Search Current Buffer" },
      { "<leader>sB", "<cmd> :FzfLua lines<CR>", desc = "Search Lines in Open Buffers" },
      {
        "<leader>sw",
        function()
          local root_dir = require("utils.root").git()
          require("fzf-lua").grep_cword { cwd = root_dir, multiprocess = true }
        end,
        desc = "Search word under cursor (git root)",
      },
      {
        "<leader>sW",
        function()
          local root_dir = require("utils.root").git()
          require("fzf-lua").grep_cWORD { cwd = root_dir, multiprocess = true }
        end,
        desc = "Search WORD under cursor (git root)",
      },
      {
        "<leader>gs",
        function()
          local root_dir = require("utils.root").git()
          require("fzf-lua").git_status { cwd = root_dir }
        end,
        desc = "Git Status",
      },
      { "<leader>gc", "<cmd> :FzfLua git_commits<CR>", desc = "Git Commits" },
      { "<leader>gb", "<cmd> :FzfLua git_branches<CR>", desc = "Git Branches" },
      { "<leader>gB", "<cmd> :FzfLua git_bcommits<CR>", desc = "Git Buffer Commits" },
      { "<leader>sa", "<cmd> :FzfLua commands<CR>", desc = "Find Actions" },
      { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
      { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
      { "<leader>s:", "<cmd> :FzfLua command_history<CR>", desc = "Find Command History" },
      {
        "<leader>ss",
        function()
          require("fzf-lua").lsp_document_symbols {
            regex_filter = symbols_filter,
          }
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("fzf-lua").lsp_live_workspace_symbols {
            regex_filter = symbols_filter,
          }
        end,
        desc = "Goto Symbol (Workspace)",
      },
      { "<leader>si", "<cmd> :FzfLua lsp_incoming_calls<CR>", desc = "LSP Incoming Calls" },
      { "<leader>so", "<cmd> :FzfLua lsp_outgoing_calls<CR>", desc = "LSP Outgoing Calls" },
      { "<leader>sk", "<cmd> :FzfLua keymaps<CR>", desc = "Search Keymaps" },
      { "<leader>sm", "<cmd> :FzfLua marks<CR>", desc = "Search Marks" },
      { "<leader>sc", "<cmd> :FzfLua colorschemes<CR>", desc = "Search colorschemes" },
      { "<leader>sh", "<cmd> :FzfLua help_tags<CR>", desc = "Search Help" },
      { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Search Jumplist" },
      { "<leader>sq", "<cmd> :FzfLua quickfix<CR>", desc = "Search Quickfix" },
      {
        "<leader>fp",
        function()
          local fzf_lua = require "fzf-lua"
          local ok, _ = pcall(require, "project_nvim")
          if not ok then
            vim.notify("Project.nvim is not installed", vim.log.levels.ERROR, { title = "Fzf Lua" })
            return
          end
          local history = require "project_nvim.utils.history"
          local results = history.get_recent_projects()
          fzf_lua.fzf_exec(results, {
            actions = {
              ["default"] = {
                function(selected)
                  fzf_lua.files { cwd = selected[1] }
                end,
              },
            },
          })
        end,
        desc = "Search Recent Projects",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      {
        "<leader>st",
        function()
          require("todo-comments.fzf").todo()
        end,
        desc = "Todo",
      },
      {
        "<leader>sT",
        function()
          require("todo-comments.fzf").todo { keywords = { "TODO", "FIX", "FIXME" } }
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },
}

return M
