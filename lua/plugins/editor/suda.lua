return {
  "lambdalisue/suda.vim",

  -- Define the key mappings
  keys = {
    -- Use <leader>W to trigger SudaWrite, allowing you to write files with sudo
    { "<leader>W", ":SudaWrite<CR>", desc = "Write File with Sudo (SudaWrite)" },
  },

  -- Define commands available for Suda
  cmd = {
    "SudaRead", -- Read file with sudo permissions
    "SudaWrite", -- Write file with sudo permissions
  },
}
