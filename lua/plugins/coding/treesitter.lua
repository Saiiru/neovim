-- lua/plugins/coding/treesitter.lua

return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
  },
  opts = {
    highlight = {
      enable = true,
      disable = { "latex" },
    },
    indent = {
      enable = true,
      disable = { "python" },
    },
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
      "rust",
      "go",
      "java",
      "dockerfile",
      "gitignore",
      "prisma",
      "svelte",
      "graphql",
      "css",
      "qmljs",
    },
    auto_install = true,
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = "<leader>i",
        node_decremental = "<bs>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },
        selection_modes = {
          ["@parameter.outer"] = "v",
          ["@function.outer"] = "V",
          ["@class.outer"] = "<C-v>",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = { query = "@class.outer", desc = "Next class start" },
          ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
        goto_next = { ["]d"] = "@conditional.outer" },
        goto_previous = { ["[d"] = "@conditional.outer" },
      },
      swap = {
        enable = true,
        swap_next = { ["<leader>a"] = "@parameter.inner" },
        swap_previous = { ["<leader>A"] = "@parameter.inner" },
      },
    },
  },
  config = function(_, opts)
    vim.filetype.add({
      extension = {
        ino = "arduino",
        pde = "arduino",
      },
    })

    require("nvim-treesitter").setup(opts)

    local ok_repeat, repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
    if ok_repeat then
      vim.keymap.set({ "n", "x", "o" }, ";", repeat_move.repeat_last_move_next, { desc = "Repeat TS Move Next" })
      vim.keymap.set(
        { "n", "x", "o" },
        ",",
        repeat_move.repeat_last_move_previous,
        { desc = "Repeat TS Move Previous" }
      )
      vim.keymap.set({ "n", "x", "o" }, "f", repeat_move.builtin_f, { desc = "f repeatable" })
      vim.keymap.set({ "n", "x", "o" }, "F", repeat_move.builtin_F, { desc = "F repeatable" })
      vim.keymap.set({ "n", "x", "o" }, "t", repeat_move.builtin_t, { desc = "t repeatable" })
      vim.keymap.set({ "n", "x", "o" }, "T", repeat_move.builtin_T, { desc = "T repeatable" })
    end
  end,
}
