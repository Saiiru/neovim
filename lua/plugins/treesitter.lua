return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "andymass/vim-matchup",
  },
  config = function()
    local parsers = require("nvim-treesitter.parsers")
    
    -- Function to disable certain features based on language and buffer
    local function disable_function(lang, bufnr)
      bufnr = bufnr or 0
      if lang == "help" or (lang == "clojure" and string.find(vim.fn.expand("%"), "conjure%-")) then
        return true
      end
      return false
    end

    -- Treesitter setup
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "javascript", "typescript", "go", "vue", "clojure", "lua", "css", "bash", "json",
        "sql", "dockerfile", "html", "python", "scss", "rust", "markdown", "hcl",
        "astro", "tsx", "terraform"
      },
      highlight = {
        enable = true,
        disable = disable_function,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "v",
          node_decremental = "V",
        },
      },
      autotag = {
        enable = true,
      },
      matchup = {
        enable = true,
        disable = { "json", "csv" },
      },
      playground = {
        enable = true,
        updatetime = 25,
        persist_queries = false,
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "All of a function definition" },
            ["if"] = { query = "@function.inner", desc = "Inner part of a function definition" },
            ["ac"] = { query = "@comment.outer", desc = "All of a comment" },
          },
          selection_modes = {
            ['@function.outer'] = 'V', -- linewise
          },
          include_surrounding_whitespace = true,
        },
      },
      rainbow = {
        enable = true,
        disable = vim.tbl_filter(function(p) return not (p == "clojure") end, parsers.available_parsers()),
      },
    })

    -- Registering markdown with MDX
    vim.treesitter.language.register("markdown", "mdx")

    -- Optional: Set delimiter colors (customize as needed)
    -- local colors = require("colorscheme")
    -- vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = colors.carpYellow })
    -- vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = colors.lightBlue })
    -- vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = colors.springGreen })
    -- vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = colors.oniViolet })
    -- vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', { fg = colors.crystalBlue })
  end,
}

