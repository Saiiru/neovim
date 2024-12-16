return {
  "luckasRanarison/nvim-devdocs",
  cmd = {
    "DevdocsFetch",
    "DevdocsInstall",
    "DevdocsUninstall",
    "DevdocsOpen",
    "DevdocsOpenFloat",
    "DevdocsOpenCurrent",
    "DevdocsOpenCurrentFloat",
    "DevdocsUpdate",
    "DevdocsUpdateAll",
  },
  keys = {
    { "<leader>sE", "<cmd>DevdocsOpen<cr>", desc = "Open Devdocs" },
    { "<leader>se", "<cmd>DevdocsOpenCurrent<cr>", desc = "Open Current Devdocs" },
  },
  opts = {
    -- Directory where devdocs will be installed
    dir_path = vim.fn.stdpath "data" .. "/devdocs",

    -- Configuration for telescope picker, can be extended if necessary
    telescope = {},

    -- Configuration for floating window
    float_win = {
      relative = "editor",
      height = 25,
      width = 100,
      border = "rounded",
    },

    -- Disable text wrapping in floating window
    wrap = false,

    -- Command for previewer (e.g., using glow as a markdown previewer)
    previewer_cmd = nil,

    -- Arguments for previewer (e.g., using glow with custom settings)
    cmd_args = {},

    -- Ignore cmd rendering for specific docs
    cmd_ignore = {},

    -- Whether to use cmd previewer in picker preview
    picker_cmd = false,
    picker_cmd_args = {},

    -- Function to set up keymap for closing the floating window after opening
    after_open = function(bufnr)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":close<CR>", {})
    end,

    -- List of docsets to ensure are installed
    ensure_installed = {
      "javascript",
      "lua-5.4",
      "fish-3.6",
      "git",
      "npm",
      "node",
    },
  },
}
