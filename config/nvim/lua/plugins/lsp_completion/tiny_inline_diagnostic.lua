return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  priority = 1000,
  opts = {
    preset = "modern",
    transparent_bg = true,
    transparent_cursorline = false,
    signs = {
      diag = "󰙎",
    },
    options = {
      use_icons_from_diagnostic = false,
      show_source = {
        enabled = false,
        if_many = true,
      },
      throttle = 20,
      softwrap = 30,
      add_messages = {
        messages = true,
        display_count = true,
        use_max_severity = false,
        show_multiple_glyphs = false,
      },
      multilines = {
        enabled = true,
      },
      overflow = {
        mode = "wrap",
        padding = 1,
      },
      break_line = {
        enabled = false,
        after = 36,
      },
      virt_texts = {
        priority = 2048,
      },
      override_open_float = true,
    },
  },
}
