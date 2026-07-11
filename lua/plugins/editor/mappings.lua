return {
  {
    "folke/which-key.nvim",
    lazy = true,
    enabled = true,
    event = "VeryLazy",
    keys = {
      { "<leader><leader>w", mode = "n",                                       "<esc><Cmd>WhichKey<Cr>",            desc = "WhichKey" },
      { "<A-down>",          "<C-w>j",                                         desc = "Move to window down" },
      { "<A-left>",          "<C-w>h",                                         desc = "Move to window left" },
      { "<A-right>",         "<C-w>l",                                         desc = "Move to window right" },
      { "<A-up>",            "<C-w>k",                                         desc = "Move to window up" },
      { "<C-s><C-a>",        ":qa!<cr>",                                       desc = "Quit all without saving" },
      { "<C-s>a",            ":wa<cr>",                                        desc = "Save all" },
      { "<C-s>s",            ":w<cr>",                                         desc = "Save" },
      { "<leader>,",         "<cmd>noh<cr>",                                   desc = "Disable search highlights" },
      { "<leader><leader>d", '"_dd',                                           desc = "Delete without yanking" },
      { "<leader><leader>e", desc = "<cmd>lua vim.diagnostic.open_float()<cr>" },
      { "<leader><leader>q", desc = "<cmd>lua vim.diagnostic.setloclist()<cr>" },
      { "<leader><leader>x", '"_x',                                            desc = "Delete without yanking" },
      { "<leader><tab>",     "<cmd>b#<cr>",                                    desc = "Go to last buffer" },
      { "<leader>P",         '"*p',                                            desc = "Paste from system clipboard" },
      { "<leader>Y",         '"*y',                                            desc = "Yank to system clipboard" },
      { "[d",                desc = "<cmd>lua vim.diagnostic.goto_prev()<cr>" },
      { "]d",                desc = "<cmd>lua vim.diagnostic.goto_next()<cr>" },
    },
    cmd = "WhichKey",
    init = function()
      vim.o.timeoutlen = 300
      vim.o.timeout = true
    end,
  },
}
