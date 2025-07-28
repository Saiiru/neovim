-- Treesitter Configuration - Syntax Analysis Matrix
-- =================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      local treesitter = require("nvim-treesitter.configs")

      treesitter.setup({
        -- Language Installation Matrix
        ensure_installed = {
          "c",
          "cpp",
          "lua",
          "vim",
          "vimdoc",
          "elixir",
          "javascript",
          "typescript",
          "html",
          "css",
          "scss",
          "python",
          "json",
          "yaml",
          "toml",
          "markdown",
          "markdown_inline",
          "bibtex",
          "go",
          "gomod",
          "gosum",
          "rust",
          "zig",
          "nim",
          "nix",
          "haskell",
          "purescript",
          "typst",
          "gdscript",
          "templ",
          "bash",
          "fish",
          "dockerfile",
          "gitignore",
          "gitcommit",
          "sql",
          "graphql",
          "regex",
          "comment",
          "jsdoc",
          "tsx",
          "php",
          "java",
          "kotlin",
          "scala",
          "ruby",
          "perl",
          "r",
          "julia",
          "matlab",
          "dart",
          "objc",
          "proto",
          "make",
          "cmake",
          "ninja",
          "meson",
        },

        -- Installation Configuration
        auto_install = true,
        sync_install = false,
        ignore_install = {},

        -- Module Configuration Matrix
        modules = {},

        -- Syntax Highlighting Protocol
        highlight = {
          enable = true,
          use_languagetree = true,
          additional_vim_regex_highlighting = false,
          
          -- Disable for specific filetypes or large files
          disable = function(lang, buf)
            -- Disable HTML highlighting (can be problematic)
            if lang == "html" then
              return true
            end
            
            -- Disable for large files
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },

        -- Smart Indentation Matrix
        indent = {
          enable = true,
          disable = { "yaml", "python" }, -- These can be problematic
        },

        -- Incremental Selection Enhancement
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },

        -- Text Objects Enhancement
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["uc"] = "@comment.outer",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
              ["]l"] = "@loop.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
              ["]L"] = "@loop.outer",
              ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
              ["[l"] = "@loop.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
              ["[L"] = "@loop.outer",
              ["[A"] = "@parameter.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },

        -- Folding Enhancement
        fold = {
          enable = false, -- We use indent folding instead
        },

        -- Autopairs Integration
        autopairs = {
          enable = true,
        },

        -- Playground (for debugging)
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,
          persist_queries = false,
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },

        -- Query Linter
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = {"BufWrite", "CursorHold"},
        },
      })

      -- Context Configuration - Enhanced Scope Awareness
      require("treesitter-context").setup({
        enable = true,
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })

      -- Custom parser registration for specialized filetypes
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      
      -- Templ parser configuration
      parser_config.templ = {
        install_info = {
          url = "https://github.com/vrischmann/tree-sitter-templ.git",
          files = {"src/parser.c", "src/scanner.c"},
          branch = "master",
        },
      }

      -- Register templ filetype
      vim.treesitter.language.register('templ', 'templ')

      -- Custom highlighting queries for enhanced syntax support
      local function setup_custom_highlights()
        vim.api.nvim_set_hl(0, "@keyword.return", { link = "Keyword" })
        vim.api.nvim_set_hl(0, "@keyword.function", { link = "Keyword" })
        vim.api.nvim_set_hl(0, "@keyword.operator", { link = "Operator" })
        vim.api.nvim_set_hl(0, "@variable.builtin", { link = "Special" })
        vim.api.nvim_set_hl(0, "@constant.builtin", { link = "Special" })
        vim.api.nvim_set_hl(0, "@function.builtin", { link = "Special" })
        vim.api.nvim_set_hl(0, "@type.builtin", { link = "Type" })
        vim.api.nvim_set_hl(0, "@namespace", { link = "Include" })
        vim.api.nvim_set_hl(0, "@property", { link = "Identifier" })
        vim.api.nvim_set_hl(0, "@field", { link = "Identifier" })
        vim.api.nvim_set_hl(0, "@parameter", { link = "Identifier" })
        vim.api.nvim_set_hl(0, "@constructor", { link = "Special" })
        vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "Delimiter" })
        vim.api.nvim_set_hl(0, "@punctuation.delimiter", { link = "Delimiter" })
        vim.api.nvim_set_hl(0, "@tag", { link = "Tag" })
        vim.api.nvim_set_hl(0, "@tag.attribute", { link = "Identifier" })
        vim.api.nvim_set_hl(0, "@tag.delimiter", { link = "Delimiter" })
      end

      -- Apply custom highlights after colorscheme loads
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = setup_custom_highlights,
      })

      -- Apply highlights immediately
      setup_custom_highlights()

      -- Context keymaps
      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { silent = true, desc = "Go to context" })
    end,
  },
}
