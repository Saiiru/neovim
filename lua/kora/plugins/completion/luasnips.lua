
  -- ═════════════════════════════════════════════════════════════════════════
  --  SNIPPET ENGINE - CODE TEMPLATE MATRIX
  -- ═════════════════════════════════════════════════════════════════════════
  return {
    "L3MON4D3/LuaSnip",
    build = (function()
      return "make install_jsregexp"
    end)(),
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = function()
      return {}
    end,
    config = function(_, opts)
      local luasnip = require("luasnip")
      
      -- Enhanced snippet configuration
      luasnip.config.set_config(vim.tbl_extend("force", opts, {
        updateevents = "TextChanged,TextChangedI",
        ext_opts = {
          [require("luasnip.util.types").choiceNode] = {
            active = {
              virt_text = { { "●", "CyberdreamPurple" } },
            },
          },
        },
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
      }))
      
      -- Load snippet collections
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load()
      
      -- Custom snippet keymaps
      vim.keymap.set({"i"}, "<C-K>", function() 
        if luasnip.expandable() then
          luasnip.expand() 
        end
      end, {silent = true, desc = "Expand snippet"})
      
      vim.keymap.set({"i", "s"}, "<C-L>", function() 
        if luasnip.jumpable(1) then
          luasnip.jump(1) 
        end
      end, {silent = true, desc = "Jump forward"})
      
      vim.keymap.set({"i", "s"}, "<C-J>", function() 
        if luasnip.jumpable(-1) then
          luasnip.jump(-1) 
        end
      end, {silent = true, desc = "Jump backward"})
      
      vim.keymap.set({"i", "s"}, "<C-E>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, {silent = true, desc = "Change choice"})
      
      -- Add useful custom snippets
      luasnip.add_snippets("all", {
        luasnip.snippet("date", {
          luasnip.text_node(os.date("%Y-%m-%d"))
        }),
        luasnip.snippet("time", {
          luasnip.text_node(os.date("%H:%M:%S"))
        }),
        luasnip.snippet("datetime", {
          luasnip.text_node(os.date("%Y-%m-%d %H:%M:%S"))
        }),
      })
      
      -- Language-specific snippets
      luasnip.add_snippets("lua", {
        luasnip.snippet("req", {
          luasnip.text_node("local "),
          luasnip.insert_node(1, "module"),
          luasnip.text_node(" = require(\""),
          luasnip.insert_node(2, "module"),
          luasnip.text_node("\")")
        }),
        luasnip.snippet("fn", {
          luasnip.text_node("local function "),
          luasnip.insert_node(1, "name"),
          luasnip.text_node("("),
          luasnip.insert_node(2, "args"),
          luasnip.text_node(")"),
          luasnip.text_node({"", "  "}),
          luasnip.insert_node(0),
          luasnip.text_node({"", "end"})
        }),
      })
      
      luasnip.add_snippets("javascript", {
        luasnip.snippet("cl", {
          luasnip.text_node("console.log("),
          luasnip.insert_node(1),
          luasnip.text_node(")")
        }),
        luasnip.snippet("af", {
          luasnip.text_node("const "),
          luasnip.insert_node(1, "name"),
          luasnip.text_node(" = ("),
          luasnip.insert_node(2, "args"),
          luasnip.text_node(") => {"),
          luasnip.text_node({"", "  "}),
          luasnip.insert_node(0),
          luasnip.text_node({"", "}"})
        }),
      })
      
      luasnip.add_snippets("python", {
        luasnip.snippet("def", {
          luasnip.text_node("def "),
          luasnip.insert_node(1, "name"),
          luasnip.text_node("("),
          luasnip.insert_node(2, "args"),
          luasnip.text_node("):"),
          luasnip.text_node({"", "    "}),
          luasnip.insert_node(0)
        }),
        luasnip.snippet("class", {
          luasnip.text_node("class "),
          luasnip.insert_node(1, "Name"),
          luasnip.text_node(":"),
          luasnip.text_node({"", "    def __init__(self"}),
          luasnip.insert_node(2),
          luasnip.text_node("):"),
          luasnip.text_node({"", "        "}),
          luasnip.insert_node(0)
        }),
      })
      
      luasnip.add_snippets("go", {
        luasnip.snippet("iferr", {
          luasnip.text_node("if err != nil {"),
          luasnip.text_node({"", "    "}),
          luasnip.insert_node(0, "return err"),
          luasnip.text_node({"", "}"})
        }),
        luasnip.snippet("func", {
          luasnip.text_node("func "),
          luasnip.insert_node(1, "name"),
          luasnip.text_node("("),
          luasnip.insert_node(2, "args"),
          luasnip.text_node(") "),
          luasnip.insert_node(3, "returnType"),
          luasnip.text_node(" {"),
          luasnip.text_node({"", "    "}),
          luasnip.insert_node(0),
          luasnip.text_node({"", "}"})
        }),
      })
      
      luasnip.add_snippets("java", {
        luasnip.snippet("main", {
          luasnip.text_node("public static void main(String[] args) {"),
          luasnip.text_node({"", "    "}),
          luasnip.insert_node(0),
          luasnip.text_node({"", "}"})
        }),
        luasnip.snippet("sout", {
          luasnip.text_node("System.out.println("),
          luasnip.insert_node(1),
          luasnip.text_node(");")
        }),
      })
    end,
  }

