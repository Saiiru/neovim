
return {
  {
    "simrat39/symbols-outline.nvim",
    keys = {
      { "<leader>ol", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" },

    },
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    lazy = true,
    config = true,
    enabled = true
  },
  {
    -- LSP Symbol Drawer
    "stevearc/aerial.nvim",
    keys = {
      lazy = true,
      { "<leader><leader>A", mode = "n", "<esc><cmd>AerialToggle<cr>", desc = "Symbols (Aerial)" },
    },
    cmd = { "AerialToggle", "AerialOpen" },
    opts = {
      backends = {
        "lsp",
        "treesitter",
        "markdown",
        "man",
      },
      attach_mode = "window",
      close_automatic_events = {
        "unsupported",
        "switch_buffer",
        "unfocus",
      },
      default_bindings = true,
      layout = {
        default_direction = "prefer_right",
        min_width = 30,
        max_width = 50,
      },
      post_jump_cmd = "normal! zz",
      lsp = {
        diagnostics_trigger_update = true,
        update_when_errors = true,
      },
    }
  },
{
  "bassamsdata/namu.nvim",
  opts = {
    menu_symbols = { 
      enable = true,
      options = {
      },
    colorscheme = {
        enable = false,
        options = {
          -- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
          persist = true, -- very efficient mechanism to Remember selected colorscheme
          write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
        },
      },
      ui_select = { enable = false }, -- vim.ui.select() wrapper
  },
},
  keys = {
    { "<leader>ss", "<cmd>Namu symbols<cr>", desc = "Jump to LSP symbol"}
  }
}

}
