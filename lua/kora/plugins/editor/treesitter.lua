-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                    KORA EDITOR ENHANCEMENT MATRIX                       ║
-- ║                      NEURAL DEVELOPMENT TOOLS                           ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
-- TREESITTER (ANÁLISE SINTÁTICA):
-- :TSInstall <language>        -- Instalar parser para linguagem
-- :TSUpdate                    -- Atualizar todos os parsers
-- :TSPlayground                -- Playground para testar queries
-- <C-Space>                    -- Seleção incremental de código
-- <BS>                         -- Reduzir seleção (no visual mode)
-- [c                           -- Ir para contexto superior
-- -- TEXTOBJECTS (NAVEGAÇÃO INTELIGENTE):
-- af/if                        -- Função externa/interna
-- ac/ic                        -- Classe externa/interna
-- al/il                        -- Loop externo/interno
-- aa/ia                        -- Parâmetro externo/interno
-- ]m/[m                        -- Próxima/anterior função
-- ]]/[[                        -- Próxima/anterior classe
-- <leader>a                    -- Trocar parâmetro com próximo
return {
  -- ═════════════════════════════════════════════════════════════════════════
  --  TREESITTER - SYNTAX INTELLIGENCE MATRIX
  -- ═════════════════════════════════════════════════════════════════════════
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "bash", "c", "cpp", "css", "dart", "dockerfile", "fish", "gitignore",
        "go", "gomod", "gosum", "html", "java", "javascript", "jsdoc", "json",
        "jsonc", "kotlin", "lua", "luadoc", "luap", "markdown", "markdown_inline",
        "python", "query", "regex", "rust", "scss", "sql", "svelte", "toml",
        "tsx", "typescript", "vim", "vimdoc", "vue", "xml", "yaml", "zig",
      },
      
      auto_install = true,
      sync_install = false,
      ignore_install = {},
      
      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      
      indent = {
        enable = true,
        disable = { "yaml", "python" },
      },
      
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
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
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, {})
      end
      require("nvim-treesitter.configs").setup(opts)
      
      -- Context Configuration
      require("treesitter-context").setup({
        enable = true,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = 'outer',
        mode = 'cursor',
        separator = nil,
        zindex = 20,
      })
      
      -- Context keymap
      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { silent = true, desc = "Go to context" })
    end,
  }}
