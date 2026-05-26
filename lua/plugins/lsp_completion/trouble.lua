return {
  "folke/trouble.nvim",
  event = "LspAttach",
  cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    focus = false,
    auto_preview = false,
    warn_no_results = false,
    win = {
      type = "split",
      position = "bottom",
      size = 0.32,
      border = "single",
    },
    modes = {
      diagnostics = {
        auto_open = false,
        auto_close = false,
        win = {
          position = "bottom",
          size = 0.32,
        },
      },
      lsp = {
        focus = false,
      },
      symbols = {
        focus = false,
        win = {
          position = "right",
          size = 0.36,
        },
      },
      quickfix = {
        focus = false,
      },
      loclist = {
        focus = false,
      },
    },
  },
  keys = {
    {
      "<leader>xx",
      function()
        require("trouble").toggle({ mode = "diagnostics", focus = false })
      end,
      desc = "Trouble diagnostics",
    },
    {
      "<leader>xX",
      function()
        require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 }, focus = false })
      end,
      desc = "Trouble buffer diagnostics",
    },
    {
      "<leader>xs",
      function()
        require("trouble").toggle({ mode = "symbols", focus = false })
      end,
      desc = "Trouble symbols",
    },
    {
      "<leader>xq",
      function()
        require("trouble").toggle({ mode = "quickfix", focus = false })
      end,
      desc = "Trouble quickfix",
    },
    {
      "<leader>xL",
      function()
        require("trouble").toggle({ mode = "loclist", focus = false })
      end,
      desc = "Trouble loclist",
    },
    {
      "<leader>xl",
      function()
        require("trouble").toggle({ mode = "lsp", focus = false })
      end,
      desc = "Trouble LSP locations",
    },
  },
}
