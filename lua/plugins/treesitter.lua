-- Configuração do nvim-treesitter
return {
  -- Primeiro bloco para nvim-treesitter e dependências
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-endwise", -- Incluindo a dependência adicional
    },
    build = ":TSUpdate",
    opts = {
      -- Garantir que as linguagens que você deseja sejam instaladas
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
        "vim",
      },

      -- Habilitar destaque de sintaxe, indentação e seleção incremental
      highlight = { enable = true },
      indent = { enable = true },

      -- Configuração de seleção incremental
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<c-space>",
          node_incremental = "<c-space>",
          scope_incremental = "<c-s>",
          node_decremental = "<c-backspace>",
        },
      },

      -- Configuração de objetos de texto
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Pular automaticamente para o próximo objeto de texto
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
          set_jumps = true,
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

      -- Configuração do endwise para adicionar automaticamente blocos
      endwise = {
        enable = true,
      },
    },
  },
}
