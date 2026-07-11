return {
{
    -- Python debugging
    "mfussenegger/nvim-dap-python",
    ft = "python",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap_py = require("dap-python")
      local py_path = os.getenv("HOME") .. "/.pyenv/versions/debugpy/bin/python"
      dap_py.setup(py_path)
      dap_py.test_runner = "pytest"
    end,
  },
  {
    "nvim-neotest/neotest",
    lazy = true,
    ft = 'python',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {}
      }
    }
  },
  {
    "linux-cultist/venv-selector.nvim",
    lazy = true,
    enabled = false,
    ft = 'python',
    dependencies = { "neovim/nvim-lspconfig","mfussenegger/nvim-dap-python" },
    opts = {
      -- Your options go here
      -- name = "venv",
      -- auto_refresh = false
    },
    event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = { {
      -- Keymap to open VenvSelector to pick a venv.
      "<leader>vs", "<cmd>:VenvSelect<cr>",
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      "<leader>vc", "<cmd>:VenvSelectCached<cr>"
    } }
  },
}
