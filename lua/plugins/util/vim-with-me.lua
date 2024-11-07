return {
  "ThePrimeagen/vim-with-me",
  cmd = "VimBeGood",
  keys = {
    {
      "<leader>vwm",
      function()
        require("vim-with-me").StartVimWithMe()
      end,
      desc = "Start Vim With Me",
    },
    {
      "<leader>svwm",
      function()
        require("vim-with-me").StopVimWithMe()
      end,
      desc = "Stop Vim With Me",
    },
  },
}
