
return {
  {
    "Exafunction/codeium.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    lazy = true,
    event = { "InsertEnter", "LspAttach" },
    opts = {
      enable_chat = true,
      enable_cmp_source = true,
      virtual_text = {
        enabled = false
      },

    }
},
  {
    -- AI code completion
    "zbirenbaum/copilot.lua",
    enabled = true,
    lazy = true,
    event = { "InsertEnter", "LspAttach" },
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        terraform = true,
        hcl = true,
        python = true,
        markdown = true,
        bash = true,
        zsh = true,
        dockerfile = true,
        yaml = true,
        json = true,
        css = true,
        html = true,
        lua = true,
        devicetree = true,
        typescript = true,
        javascript = true,
      }
    },
  },
  { 'AndreM222/copilot-lualine', },
  {
    "zbirenbaum/copilot-cmp",
    event = { "InsertEnter", "LspAttach" },
    enabled = true,
    config = true
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = true,
    branch = "main",
    build = "make tiktoken",
    lazy = true,
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        model = "gpt-4o",
        auto_insert_mode = true,
        chat_autocomplete = true,
        show_help = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
        selection = function(source)
          local select = require("CopilotChat.select")
          return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    keys = {
      { "<c-s>",     "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "",     desc = "+ai",        mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      -- Show help actions with telescope
      {
        "<leader>ad",
        function()
          require("CopilotChat.actions").pick("help")
        end,
        desc = "Diagnostic Help (CopilotChat)",
        mode = { "n", "v" }
      },
      -- Show prompts actions with telescope
      {
        "<leader>ap",
        function()
          require("CopilotChat.actions").pick("prompt")
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "v" }
      },
      {
        "<leader>ccq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },


}
