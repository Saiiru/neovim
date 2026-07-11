return {
  
  {
    -- Telescope
    "nvim-telescope/telescope.nvim",
    version = false,
    enabled = false,
    lazy = true,
    cmd = "Telescope",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    keys = {
      { "<leader>fC",        mode = "n", "<esc><cmd>Telescope commands<cr>",        desc = "Command" },
      { "<leader>fH",        mode = "n", "<esc><cmd>Telescope command_history<cr>", desc = "Recent Command" },
      { "<leader>fS",        mode = "n", "<esc><cmd>Telescope search_history<cr>",  desc = "in Search History" },
      { "<leader>fT",        mode = "n", "<esc><cmd>Telescope treesitter<cr>",      desc = "Treesitter Symbol" },
      { "<leader>fa",        mode = "n", "<esc><cmd>Telescope aerial<cr>",          desc = "Symbols" },
      { "<leader>fb",        mode = "n", "<esc><cmd>Telescope buffers<cr>",         desc = "Buffer" },
      { "<leader>fe",        mode = "n", "<esc><cmd>Telescope file_browser<cr>",    desc = "in File Browser" },
      { "<leader>ff",        mode = "n", "<esc><cmd>Telescope find_files<cr>",      desc = "File" },
      { "<leader>fg",        mode = "n", "<esc><cmd>Telescope live_grep<cr>",       desc = "String in Files" },
      { "<leader>fh",        mode = "n", "<esc><cmd>Telescope harpoon marks<cr>",   desc = "Harpooned Files" },
      { "<leader>fj",        mode = "n", "<esc><cmd>Telescope jumplist<cr>",        desc = "in Jumplist" },
      { "<leader>fk",        mode = "n", "<esc><cmd>Telescope keymaps<cr>",         desc = "Keymaps" },
      { "<leader>fm",        mode = "n", "<esc><cmd>Telescope marks<cr>",           desc = "in Marks" },
      { "<leader>fn",        mode = "n", "<esc><cmd>Telescope notify<cr>",          desc = "Notification" },
      { "<leader>fo",        mode = "n", "<esc><cmd>Telescope oldfiles<cr>",        desc = "Recent Files" },
      { "<leader>fr",        mode = "n", "<esc><cmd>Telescope registers<cr>",       desc = "in Registers" },
      { "<leader>fs",        mode = "n", "<esc><cmd>Telescope luasnip<cr>",         desc = "Snippet" },
      { "<leader>fx",        mode = "n", "<esc><cmd>Telescope quickfix<cr>",        desc = "Send To QuickFix" },
      { "<leader>fR",        mode = "n", "<esc><cmd>Telescope reloader<cr>",        desc = "Reloader" },
      { "<leader>fu",        mode = "n", "<esc><cmd>Telescope undo<cr>",            desc = "Search Undo" },
      { "<leader><leader>o", mode = "n", "<esc><cmd>Telescope smart_open<cr>",      desc = "Smart Open" },
      { "<leader><leader>f", mode = "n", "<esc><Cmd>Telescope<cr>",                 desc = "Telescope" },
      { "<C-p>",             mode = "n", "<esc><Cmd>Telescope buffers<cr>",         desc = "Open Buffer" },
    },
    opts = function()
      local actions = require("telescope.actions")
      local themes = require("telescope.themes")
      local z_utils = require("telescope._extensions.zoxide.utils")
      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end

      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end

      local get_selected_window = function()
        local wins = vim.api.nvim_list_wins()
        table.insert(wins, 1, vim.api.nvim_get_current_win())
        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == "" then
            return win
          end
        end
      end

      return {
        defaults = {
          file_ignore_patterns = {
            "%.git/*",
            "*/tmp/*",
            "*-lock.json",
            "node_modules/*",
          },
          path_display = {
            "filename_first"
          },
          sorting_strategy = "ascending",
          winblend = 0,
          layout_strategy = "vertical",
          layout_config = {
            height = 0.7,
            width = 0.8,
            prompt_position = "top",

          },
          prompt_prefix = "  ",
          selection_caret = "   ",
          -- get_selection_window = get_selected_window,
          mappings = {
            i = {
              ["<C-j>o"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<C-t>"] = open_with_trouble,
              ["<A-t"] = open_selected_with_trouble,
              ["<esc>"] = actions.close,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ["<C-t>"] = open_with_trouble,
              ["<A-t"] = open_selected_with_trouble,
              ["<esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
          },
        },
        pickers = {
          command_history = {
            -- theme = "dropdown"
          },
          harpoon = {
            -- theme = "dropdown"
          },
          marks = {
            -- theme = "dropdown"
          },
          find_files = {
            -- theme = "dropdown"
          },
          buffers = {
            -- theme = "dropdown"
          },
          live_grep = {
            -- theme = "dropdown"
          },
          spell_suggest = {
            theme = "cursor"
          },
          luasnip = {
            theme = "cursor"
          },
        },
        extensions = {
          zoxide = {
            prompt_title = "[ Walking on the shoulders of TJ ]",
            mappings = {
              default = {
                after_action = function(selection)
                  print("Update to (" .. selection.z_score .. ") " .. selection.path)
                end
              },
              ["<C-s>"] = {
                before_action = function(selection) print("before C-s") end,
                action = function(selection)
                  vim.cmd.edit(selection.path)
                end
              },
              -- Opens the selected entry in a new split
              ["<C-q>"] = { action = z_utils.create_basic_command("split") },
            },
          },
          aerial = {
            show_nesting = true,
            theme = "dropdown"
          },
          file_browser = {
            theme = "dropdown"
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            themes.get_dropdown({}),
          },
          frecency = {
            db_root = vim.fn.stdpath("data"),
            ignore_patterns = { "*.git/*", "*/tmp/*" },
            workspaces = {
              ["work"] = os.getenv("HOME") .. "/Work/Projects",
              ["personal"] = os.getenv('HOME') .. "/Code",
              ["conf"] = os.getenv('HOME') .. "/.config",
              ["data"] = os.getenv('HOME') .. "/.local/share"
            }
          },
          lazy = {
            -- Optional theme (the extension doesn't set a default theme)
            theme = "ivy",
            -- Whether or not to show the icon in the first column
            show_icon = true,
            -- Mappings for the actions
            mappings = {
              open_in_browser = "<C-o>",
              open_in_file_browser = "<M-b>",
              open_in_find_files = "<C-f>",
              open_in_live_grep = "<C-g>",
              open_in_terminal = "<C-t>",
              open_plugins_picker = "<C-b>", -- Works only after having called first another action
              open_lazy_root_find_files = "<C-r>f",
              open_lazy_root_live_grep = "<C-r>g",
            },
            git_diffs = {
              git_command = { "git", "log", "--oneline", "--decorate", "--all", "." } -- list result
            },
            project = {
              base_dirs = {
                { path = "~/Work/Projects", max_depth = 3 },
                { path = "~/Code",          max_depth = 2 }
              },
              hidden_files = false,
              theme = "dropdown",
              order_by = "asc",
              search_by = "title",
            },
            tasks = {
              theme = "ivy",
              env = {
                cargo = {
                  -- Example environment used when running cargo projects
                  RUST_LOG = "debug",
                  -- ...
                },
                -- ...
              },
              binary = {
                -- Example binary used when running python projects
                python = "python3",
                -- ...
              },
              -- NOTE: environment and commands may be modified for each task separately from the picker

              -- other picker setup values
            },
            -- Configuration that will be passed to the window that hosts the terminal
            -- For more configuration options check 'nvim_open_win()'
            terminal_opts = {
              relative = "editor",
              style = "minimal",
              border = "rounded",
              title = "Telescope lazy",
              title_pos = "center",
              width = 0.5,
              height = 0.5,
            },
            -- Other telescope configuration options
          },
        },
      }
    end
  },
  
  {
    "nvim-telescope/telescope-frecency.nvim",
    lazy = true,
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },
  {
    "nvim-telescope/telescope-github.nvim",
    lazy = true,
    config = function()
      require('telescope').load_extension('gh')
    end
  },
  {
    "HUAHUAI23/telescope-dapzzzz",
    lazy = true,
    config = function()
      require("telescope").load_extension("i23")
    end
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    lazy = true,
    keys = {
      { "<leader>fdb", mode = "n", "<esc><Cmd>Telescope dap list_breakpoints<cr>", desc = "DAP Commands" },
      { "<leader>fdc", mode = "n", "<esc><Cmd>Telescope dap configurations<cr>",   desc = "DAP Commands" },
      { "<leader>fdd", mode = "n", "<esc><Cmd>Telescope dap commands<cr>",         desc = "DAP Commands" },
      { "<leader>fdv", mode = "n", "<esc><Cmd>Telescope dap variables<cr>",        desc = "DAP Commands" },
    },
    config = function()
      require("telescope").load_extension('dap')
    end
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    lazy = true,
    build = "make",
    config = function()
      require("telescope").load_extension('fzf')
    end
  },
  {
    "jvgrootveld/telescope-zoxide",
    lazy = true
  },
  {
    "LinArcX/telescope-env.nvim",
    lazy = true,
    config = function()
      require("telescope").load_extension("env")
    end
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    lazy = true,
    config = function()
      require("telescope").load_extension("file_browser")
    end
  },
  {
    "nvim-telescope/telescope-project.nvim",
    lazy = true,
    config = function()
      require 'telescope'.load_extension('project')
    end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    lazy = true,
    config = function()
      require("telescope").load_extension("ui-select")
    end
  },
  {
    "xiyaowong/telescope-emoji.nvim",
    lazy = true,
    keys = {
      { "<leader>fe", mode = "n", "<esc><cmd>Telescope emoji<cr>", desc = "Emoji" },
    },
    config = function()
      require("telescope").load_extension("emoji")
    end
  },
  {
    "ghassan0/telescope-glyph.nvim",
    lazy = true,
    keys = {
      { "<leader>fG", mode = "n", "<esc><cmd>Telescope glyph<cr>", desc = "Icon" },
    },
    config = function()
      require("telescope").load_extension("glyph")
    end
  },
  {
    "tsakirist/telescope-lazy.nvim",
    lazy = true,
    config = function()
      require("telescope").load_extension("lazy")
    end
  },
  {
    lazy = true,
    "benfowler/telescope-luasnip.nvim",
    config = function()
      require("telescope").load_extension("luasnip")
    end
  },
  {
    'barrett-ruth/telescope-http.nvim',
    dependencies = {
      'savq/paq-nvim'
    },
    lazy = true,
    config = function()
      require("telescope").load_extension("http")
    end
  },
  {
    'olacin/telescope-cc.nvim',
    lazy = true,
    config = function()
      require('telescope').load_extension('cc')
    end
  },
  {
    "ahmedkhalf/project.nvim",
    lazy = true,
    config = function()
      require 'telescope'.extensions.projects.projects {}
    end
  },
  {
    "paopaol/telescope-git-diffs.nvim",
    lazy = true,
    config = function()
      require("telescope").load_extension("git_diffs")
    end

  },
  {
    "LinArcX/telescope-ports.nvim",
    lazy = true,
    config = function()
      require("telescope").load_extension("ports")
    end
  },
  {
    "lpoto/telescope-tasks.nvim",
    lazy = true,
    config = function()
      require("telescope").load_extension("tasks")
    end
  },
  {
    "debugloop/telescope-undo.nvim",
    lazy = true,
    keys = {
      { "<leader>fu", mode = "n", "<esc><cmd>Telescope undo_list<cr>", desc = "Undo List" }
    },
    config = function()
      require("telescope").load_extension("undo")
    end
  },
  {
    "aznhe21/actions-preview.nvim",
    lazy = true,
    keys = {
      { "<leader>fa", mode = "n", "<esc><cmd>lua require('actions-preview').code_actions<cr>", desc = "Code Actions" }
    },
    config = function()
      require("telescope").load_extension("actions-preview")
    end
  },
  {
    'dawsers/telescope-file-history.nvim',
    lazy = true,
    config = function()
      require('telescope').load_extension('file_history')
    end
  },
  {
    'olacin/telescope-gitmoji.nvim',
    lazy = true,
    keys = {
      { "<leader>fE", mode = "n", "<esc><cmd>Telescope gitmoji<cr>", desc = "Gitmoji" }
    },
    config = function()
      require('telescope').load_extension('gitmoji')
    end

  },
  {
    "cappyzawa/telescope-terraform.nvim",
    enabled = false,
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim",
      "ANGkeith/telescope-terraform-doc.nvim" },
    ft = { "terraform", "tf", "tfvars" },
    
    keys = {
      { "<leader>ftd", mode = "n", "<esc><cmd>Telescope terraform<cr>", desc = "Terraform" }
    },
    config = function()
      require('telescope').load_extension('terraform')
    end
  },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    lazy = true,
    config = function()
      require("telescope").load_extension("smart_open")
    end,
    dependencies = {
      "kkharji/sqlite.lua",
      -- Only required if using match_algorithm fzf
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
  },
}
