return {
{
    'echasnovski/mini.splitjoin',
    version = false,
    enabled = true,
    lazy = true,
    keys = {
      { '<leader>ms', mode = 'n', '<cmd>lua MiniSplitjoin.split()<cr>', desc = 'MiniSplitjoin' },
      { '<leader>mj', mode = 'n', '<cmd>lua MiniSplitjoin.join()<cr>',  desc = 'MiniSplitjoin' }
    },
    opts = {}
  }
}
