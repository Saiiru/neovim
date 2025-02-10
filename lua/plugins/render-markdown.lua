return {
  {
    "neovim/nvim-lspconfig",
   config = function()
      -- Configuração correta do LSP
      require("lspconfig").marksman.setup({})
    end
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>m", group = "markdown", icon = "" }, -- Config mantida
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "markdown", "markdown_inline" }
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.icons"
    },
    ft = { "markdown", "vimwiki", "mdx" },
    keys = {
      { "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Render Markdown" },
    },
    opts = {
      enabled = true,
      render_modes = { 'n', 'c' },
      indent = {
        enabled = false,
      },
      file_types = {
        'markdown',
        'vimwiki',
        'mdx',
      },
      heading = {
        enabled = true,
        sign = false,
        position = 'overlay',
        icons = { ' H1 ', ' H2 ', ' H3 ', ' H4 ', ' H5 ', ' H6 ' },
        width = 'block',
        left_margin = 0,
        left_pad = 0,
        right_pad = 2,
        min_width = 0,
        border = false,
        border_virtual = false,
        border_prefix = false,
        above = '',
        below = '',
        backgrounds = {
          'MarkviewHeading1',
          'MarkviewHeading2',
          'MarkviewHeading3',
          'MarkviewHeading4',
          'MarkviewHeading5',
          'MarkviewHeading6',
        },
        foregrounds = {
          'MarkviewHeading1',
          'MarkviewHeading2',
          'MarkviewHeading3',
          'MarkviewHeading4',
          'MarkviewHeading5',
          'MarkviewHeading6',
        },
      },
      code = {
        enabled = true,
        sign = false,
        style = 'full',
        position = 'left',
        language_pad = 1,
        width = 'block',
        left_margin = 0.5,
        left_pad = 3,
        right_pad = 3,
        border = 'thin',
        above = '▄',
        below = '▀',
        highlight = 'RenderMarkdownCode',
        highlight_inline = 'RenderMarkdownCodeInline'
      },
      callout = {
        note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
        tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
        important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
        warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
        caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
        abstract = { raw = '[!ABSTRACT]', rendered = '󰨸 Abstract', highlight = 'RenderMarkdownInfo' },
        summary = { raw = '[!SUMMARY]', rendered = '󰨸 Summary', highlight = 'RenderMarkdownInfo' },
        tldr = { raw = '[!TLDR]', rendered = '󰨸 Tldr', highlight = 'RenderMarkdownInfo' },
        info = { raw = '[!INFO]', rendered = '󰋽 Info', highlight = 'RenderMarkdownInfo' },
        todo = { raw = '[!TODO]', rendered = '󰗡 Todo', highlight = 'RenderMarkdownInfo' },
        hint = { raw = '[!HINT]', rendered = '󰌶 Hint', highlight = 'RenderMarkdownSuccess' },
        success = { raw = '[!SUCCESS]', rendered = '󰄬 Success', highlight = 'RenderMarkdownSuccess' },
        check = { raw = '[!CHECK]', rendered = '󰄬 Check', highlight = 'RenderMarkdownSuccess' },
        done = { raw = '[!DONE]', rendered = '󰄬 Done', highlight = 'RenderMarkdownSuccess' },
        question = { raw = '[!QUESTION]', rendered = '󰘥 Question', highlight = 'RenderMarkdownWarn' },
        help = { raw = '[!HELP]', rendered = '󰘥 Help', highlight = 'RenderMarkdownWarn' },
        faq = { raw = '[!FAQ]', rendered = '󰘥 Faq', highlight = 'RenderMarkdownWarn' },
        attention = { raw = '[!ATTENTION]', rendered = '󰀪 Attention', highlight = 'RenderMarkdownWarn' },
        failure = { raw = '[!FAILURE]', rendered = '󰅖 Failure', highlight = 'RenderMarkdownError' },
        fail = { raw = '[!FAIL]', rendered = '󰅖 Fail', highlight = 'RenderMarkdownError' },
        missing = { raw = '[!MISSING]', rendered = '󰅖 Missing', highlight = 'RenderMarkdownError' },
        danger = { raw = '[!DANGER]', rendered = '󱐌 Danger', highlight = 'RenderMarkdownError' },
        error = { raw = '[!ERROR]', rendered = '󱐌 Error', highlight = 'RenderMarkdownError' },
        bug = { raw = '[!BUG]', rendered = '󰨰 Bug', highlight = 'RenderMarkdownError' },
        example = { raw = '[!EXAMPLE]', rendered = '󰉹 Example', highlight = 'RenderMarkdownHint' },
        quote = { raw = '[!QUOTE]', rendered = '󱆨 Quote', highlight = 'RenderMarkdownQuote' },
        cite = { raw = '[!CITE]', rendered = '󱆨 Cite', highlight = 'RenderMarkdownQuote' },
      },
      bullet = {
        enabled = true,
        icons = { ' ', ' ', '◆', '◇' },
        left_pad = 2,
        right_pad = 0,
        highlight = 'WarningMsg',
      },
      latex = { enabled = false }
    }
  },
  {
    "previm/previm",
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>PrevimOpen<cr>", desc = "Abrir Preview no Zen-Twilight" },
    },
    config = function()
      vim.g.previm_open_cmd = "zen-twilight" -- Comando do seu browser
      vim.g.previm_enable_realtime = 1       -- Preview automático
      vim.g.previm_custom_preview_path = '/tmp/previm' -- Diretório temporário
    end,
  },
}
