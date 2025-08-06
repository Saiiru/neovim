
  -- ═════════════════════════════════════════════════════════════════════════
  --  INDENT GUIDES - STRUCTURE VISUALIZATION
  -- ═════════════════════════════════════════════════════════════════════════
  return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { 
        char = "│",
        tab_char = "│",
      },
      scope = { 
        char = "│", 
        highlight = "IblScope",
        show_start = true,
        show_end = true,
      },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
          "lazy", "mason", "notify", "toggleterm", "lazyterm",
        },
      },
    },
  }
