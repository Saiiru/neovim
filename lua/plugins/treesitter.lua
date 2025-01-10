return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "RRethy/nvim-treesitter-endwise",
  },
  opts = {
    endwise = {
      enable = true,
    },
  },
  config = function()
    -- Configure Treesitter
    -- See `:help nvim-treesitter`
    require("nvim-treesitter.configs").setup({
      -- Ensure the languages you want are installed
      ensure_installed = {
        "go",
        "lua",
        "python",
        "rust",
        "typescript",
        "regex",
        "bash",
        "markdown",
        "markdown_inline",
        "kdl",
        "sql",
        "org",
        "terraform",
        "html",
        "css",
        "javascript",
        "yaml",
        "json",
        "toml",
        "c",
        "cpp",
        "vimdoc",
        "vim", -- Additional languages from the first config
      },

      -- Additional configurations
      modules = {}, -- Required field
      sync_install = true, -- Required field
      ignore_install = {}, -- Required field
      auto_install = false, -- Required field

      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<c-space>",
          node_incremental = "<c-space>",
          scope_incremental = "<c-s>",
          node_decremental = "<c-backspace>",
        },
      },
      textobjects = {
        select = {
          enable = true, -- Changed to true for enabling selection
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ii"] = "@conditional.inner",
            ["ai"] = "@conditional.outer",
            ["at"] = "@comment.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[]"] = "@class.outer",
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
    })
  end,
}
