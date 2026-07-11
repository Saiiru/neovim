return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "default" },
      completion = { documentation = { auto_show = true } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },
}
