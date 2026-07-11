return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      snippets = { preset = "default" },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
        menu = { border = "single" },
      },
      signature = { enabled = true, window = { border = "single" } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      cmdline = { enabled = true },
    },
  },
}
