return {
	"nvim-lua/plenary.nvim", --lua functions that many plugins use
	"christoomey/vim-tmux-navigator", -- tmux & split window nav
    -- fixes the well know nvim bug
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                {
                    path = "${3rd}/plenary.nvim/lua",
                    words = { "plenary" }
                },
            },
        },
    },
     
    
 -- Which-key para visualização de atalhos
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        -- setup options
      })
    end,
  },

  -- Overseer para gerenciamento de tasks
  {
    "stevearc/overseer.nvim",
    opts = {
      templates = {
        "python", "node", "go", "rust", "java", "spring", "arduino",
        -- Template customizado para usar o runner externo
        {
          name = "Run in External Terminal",
          builder = function()
            local runner = require("kora.runner")
            local cmd = runner.cmd("run") -- Obtém o comando de 'run' para o projeto atual
            if cmd then
              return {
                cmd = { "sh", "-c", runner.external("run") },
                name = "External Runner",
              }
            end
          end,
          condition = {
            callback = function()
              return require("kora.runner").cmd("run") ~= nil
            end,
          },
        },
      },
    },
    config = function(_, opts)
      require("overseer").setup(opts)
      -- Mapeamentos de atalhos
      local wk = require("which-key")
      wk.register({
        r = {
          name = "+run",
          r = { "<cmd>OverseerRun<cr>", "Run Task" },
          l = { "<cmd>OverseerRunCmd<cr>", "Run Last Task" },
          p = { "<cmd>OverseerQuickAction open<cr>", "Open Output" },
          e = {
            function()
              require("kora.runner").external("run")
            end,
            "Run in External Terminal",
          },
        },
        b = {
          name = "+build",
          b = {
            function()
              require("kora.runner").run_task("build")
            end,
            "Build Project",
          },
        },
        t = {
          name = "+test",
          t = {
            function()
              require("kora.runner").run_task("test")
            end,
            "Test Project",
          },
        },
      }, { prefix = "<leader>" })
    end,
  },
}

