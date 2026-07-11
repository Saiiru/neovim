return {
{
    "VonHeikemen/fine-cmdline.nvim",
    enabled = true,
    lazy = true,
    event = "CmdlineEnter"
  },
{
    "folke/noice.nvim",
    lazy = true,
    event = "VeryLazy",
    enabled = true,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>nd", mode = "n", "<esc><cmd>NoiceDismiss<cr>", desc = "Dismiss Notifications", },
      { "<leader>ne", mode = "n", "<esc><cmd>NoiceErrors<cr>",  desc = "Error Notifications", },
      { "<leader>nh", mode = "n", "<esc><cmd>NoiceHistory<cr>", desc = "Old Notification", },
    },
    opts = {
      cmdline = {
        enabled = true,
      },
      popupmenu = {
        enabled = true,
        backend = "cmp"
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override      = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        messages      = {
          view_search = true,
        },
        documentation = {
          view = "hover",
        },
        progress      = {
          enabled = true,
          throttle = 1000 / 100,
          format = "lsp_progress",
          view = "mini"
        },
        signature     = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50
          }
        },
        hover         = {
          enabled = true,
          silent = false,
        }
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false,        -- use a classic bottom cmdline for search
        command_palette = false,      -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true,            -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
      views = {
        cmdline_popup = {
          border = {
            style = "none",
            padding = { 1, 2 },
          },

          filter_options = {},
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
        mini = {
          win_options = {
            winblend = 0
          },
        }
      },
      routes = {
        { filter = { find = "E21" },                                   skip = true },
        { filter = { find = "E162" },                                  skip = true },
        --{ filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
        { filter = { event = "msg_show", find = "search hit BOTTOM" }, skip = true },
        { filter = { event = "msg_show", find = "search hit TOP" },    skip = true },
        { filter = { event = "emsg", find = "E23" },                   skip = true },
        { filter = { event = "emsg", find = "E20" },                   skip = true },
        { filter = { find = "No signature help" },                     skip = true },
        { filter = { find = "E37" },                                   skip = true },
      },
    }
  }
}
