return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- From first config
    delay = 0,
    icons = {
      mappings = vim.g.have_nerd_font,
      keys = vim.g.have_nerd_font and {} or {
        Up = '<Up> ',
        Down = '<Down> ',
        Left = '<Left> ',
        Right = '<Right> ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '<CR> ',
        Esc = '<Esc> ',
        ScrollWheelDown = '<ScrollWheelDown> ',
        ScrollWheelUp = '<ScrollWheelUp> ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '<Space> ',
        Tab = '<Tab> ',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
        F9 = '<F9>',
        F10 = '<F10>',
        F11 = '<F11>',
        F12 = '<F12>',
      },
      -- From second config
      rules = false,
      separator = "➜",
      group = "",
    },
    -- Groups from first config's spec
    spec = {
      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
 { "<leader>m", group = "markdown", icon = "" },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    },
    -- From second config's setup
    show_keys = false,
    show_help = false,
    layout = {
      align = "center",
    },
    win = {
      border = "double",
      title = false,
      padding = { 1, 1 },
      no_overlap = true,
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    -- Additional groups from second config
    wk.add({
      { "<leader>f", group = "Telescope", icon = "󰱼 "  },
      { "<leader>s", group = "Sessions" },  -- Overrides spec's '[S]earch'
      { "<leader>e", group = "File Tree" },
      { "<leader>u", group = "Undotree" },
      { "<leader>l", group = "LSP" },
      { "<leader>o", group = "Options Commands" },
      { "<leader>b", group = "Buffer" },
      { "<leader>p", group = "Pane" },
      { "<leader>t", group = "Terminal" },  -- Overrides spec's '[T]oggle'
      { "<leader>g", group = "Gitsigns" },
      { "<leader>c", group = "Snacks" },    -- Overrides spec's '[C]ode'
      { "<leader>n", group = "Noice" },
    })
  end,
}
