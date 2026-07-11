return {
{
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "rcasia/neotest-bash",
    "nvim-neotest/neotest-python"
  },
  lazy = true,
  event = "VeryLazy",
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python"),
        require("neotest-bash")
      }
    })
  end
}
}
