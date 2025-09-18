---@diagnostic disable: missing-fields
return {
  -- ===== nvim-ts-autotag (novo layout) =====
  {
    "windwp/nvim-ts-autotag",
    event = { "InsertEnter", "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
        per_filetype = {
          -- ajuste fino por ft se quiser (ex.: xml = { enable_close = false })
        },
        aliases = {
          templ = "html",
        },
      }
    end,
  },

  -- ===== nvim-autopairs =====
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      enable_check_bracket_line = true,
      map_cr = true, -- Blink <CR> -> fallback aqui quando menu estiver fechado
      disable_filetype = { "TelescopePrompt", "vim", "snacks_input", "oil", "neo-tree", "NvimTree" },
      ignored_next_char = "[%w%.%$]",
      fast_wrap = {
        map = "<M-w>",
        chars = { "{", "[", "(", '"', "'", "`" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = "$",
        keys = "arstneio",
        check_comma = true,
        highlight = "IncSearch",
        highlight_grey = "Comment",
      },
    },
    config = function(_, opts)
      local npairs = require "nvim-autopairs"
      npairs.setup(opts)

      local Rule = require "nvim-autopairs.rule"
      local conds = require "nvim-autopairs.conds"

      -- Espaços inteligentes em (), {}, []
      npairs.add_rules {
        Rule("%( ", " )")
          :with_pair(function()
            return false
          end)
          :with_move(function(o)
            return o.prev_char:match ".%)" ~= nil
          end)
          :use_key ")",
        Rule("%{ ", " }")
          :with_pair(function()
            return false
          end)
          :with_move(function(o)
            return o.prev_char:match ".%}" ~= nil
          end)
          :use_key "}",
        Rule("%[ ", " ]")
          :with_pair(function()
            return false
          end)
          :with_move(function(o)
            return o.prev_char:match ".%]" ~= nil
          end)
          :use_key "]",
      }

      -- Markdown/MDX/gitcommit: **negrito**, `inline`, ```bloco```
      npairs.add_rules {
        Rule("*", "*", { "markdown", "mdx", "gitcommit" })
          :with_pair(conds.before_regex "%S")
          :with_move(conds.none())
          :with_del(function(_, m)
            return m == "**"
          end),
        Rule("`", "`", { "markdown", "mdx", "gitcommit" }):with_pair(conds.not_after_regex "`"):with_move(conds.none()),
        Rule("```", "```", { "markdown", "mdx" }):with_move(function(o)
          return o.next_char == "`"
        end),
      }

      -- JS/TS: blocos /* */ e JSDoc /** */
      npairs.add_rules {
        Rule("/*", "*/", { "javascript", "typescript" }):with_move(function(o)
          return o.next_char == "*"
        end),
        Rule("/**", " */", { "javascript", "typescript" }):with_move(function(o)
          return o.next_char == " "
        end),
      }

      -- Python: """ """ e ''' '''
      npairs.add_rules {
        Rule('"""', '"""', "python"):with_move(function(o)
          return o.next_char == '"'
        end),
        Rule("'''", "'''", "python"):with_move(function(o)
          return o.next_char == "'"
        end),
      }

      -- Go: evita conflito com := ao abrir parênteses
      npairs.add_rule(Rule("(", ")", "go"):with_pair(conds.not_before_regex ":="))

      -- Rust: não parear ' em lifetimes (foo<'a>)
      npairs.add_rule(Rule("'", "'", "rust"):with_pair(conds.not_before_regex "[%w%)%]}]"):with_move(conds.none()))

      -- C/C++/Java/C#: genéricos <...> (evita << e não afeta TSX/HTML)
      npairs.add_rule(Rule("<", ">", { "c", "cpp", "java", "cs" }):with_pair(function(o)
        local prev = o.line:sub(o.col - 1, o.col - 1)
        local next2 = o.line:sub(o.col, o.col + 1)
        return prev:match "[%w_%)%]}]" ~= nil and next2 ~= "<"
      end):with_move(function(o)
        return o.next_char == ">"
      end))

      -- Aspas em geral: não duplica se há palavra à frente
      for _, q in ipairs { '"', "'", "`" } do
        npairs.add_rule(Rule(q, q):with_pair(conds.not_after_regex "[%w_]"):with_move(function(o)
          return o.next_char == q
        end))
      end

      -- (Opcional) ativar módulo autopairs do treesitter se usar essa chave
      pcall(function()
        local ts = require "nvim-treesitter.configs"
        if ts.setup then
          ts.setup { autopairs = { enable = true } }
        end
      end)

      -- Atalho extra pro fastwrap (além de <M-w> interno)
      vim.keymap.set("i", "<leader>aw", function()
        require("nvim-autopairs.fastwrap").show()
      end, { desc = "Autopairs: fast wrap" })
    end,
  },
}
