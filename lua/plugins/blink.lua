return {
  { "hrsh7th/nvim-cmp", enabled = false },
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "v0.*",
    dependencies = {
      { "L3MON4D3/LuaSnip", version="v2.*",
        build = (function() if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then return end return "make install_jsregexp" end)(),
        dependencies = {
          { "rafamadriz/friendly-snippets", config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
              require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
            end },
        },
      },
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown" } },
      { "folke/lazydev.nvim", ft = { "lua" } },
      { "fang2hou/blink-copilot" },
    },
    opts = {
      keymap = {
        preset = "none",
        ["<C-Space>"] = { "show","show_documentation","hide_documentation" },
        ["<C-g>"] = { "hide","fallback" },
        ["<CR>"] = { "accept","fallback" },
        ["<Up>"] = { "select_prev","fallback" }, ["<Down>"] = { "select_next","fallback" },
        ["<C-p>"] = { "select_prev","fallback" }, ["<C-n>"] = { "select_next","fallback" },
        ["<C-b>"] = { "scroll_documentation_up","fallback" },
        ["<C-f>"] = { "scroll_documentation_down","fallback" },
        ["<M-s>"] = { "show_signature","hide_signature","fallback" },
        ["<A-j>"] = { "snippet_forward","fallback" }, ["<A-k>"] = { "snippet_backward","fallback" },
        ["<Tab>"] = false, ["<S-Tab>"] = false,
      },
      appearance = { nerd_font_variant = "mono", use_nvim_cmp_as_default = true },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = { border = "rounded", scrollbar = false },
        documentation = { auto_show = true, auto_show_delay_ms = 120, window = { border = "rounded" } },
        ghost_text = { enabled = false },
      },
      signature = { enabled = true },
      snippets = { preset = "luasnip" },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      sources = {
        default = { "lazydev","lsp","path","snippets","buffer","copilot","markdown" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
          markdown = { name = "RenderMarkdown", module = "render-markdown.integ.blink", fallbacks = { "lsp" } },
          copilot = { name = "copilot", module = "blink-copilot", async = true, score_offset = 100 },
        },
      },
      cmdline = { enabled = false },
      enabled = function()
        return not vim.tbl_contains({ "copilot-chat" }, vim.bo.filetype)
          and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
      end,
    },
    opts_extend = { "sources.default","sources.completion.enabled_providers" },
  },
}