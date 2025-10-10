-- lua/plugins/coding/ai.lua :: Integração com assistentes de IA (Copilot, etc.)

local mapping_key_prefix = vim.g.ai_prefix_key or "<leader>A"

return {
  -- Adiciona um grupo de keymaps para IA no which-key.
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>c", group = "CopilotChat", mode = { "n", "v" } },
        { mapping_key_prefix, group = "AI Code Companion", mode = { "n", "v" } },
        { "<leader>a", group = "AI (extras)", mode = { "n", "v" } },
      },
    },
  },

  -- Renderiza o markdown nas respostas da IA.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "copilot-chat", "codecompanion" },
    opts = { file_types = { "markdown", "copilot-chat", "codecompanion" } },
  },

  -- Sugestões de código (ghost text) com Copilot.
  {
    "zbirenbaum/copilot.lua",
    lazy = false, -- Carrega cedo para que outros plugins de IA o encontrem.
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-l>",
          accept_word = "<M-w>",
          accept_line = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        ["*"] = true,
        markdown = true,
        gitcommit = true,
        help = false,
      },
    },
  },

  -- Chat com Copilot.
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    build = "make tiktoken", -- Dependência para o tokenizer.
    dependencies = { "nvim-lua/plenary.nvim", "github/copilot.vim" },
    keys = {
      { "<leader>cv", "<cmd>CopilotChatToggle<cr>", desc = "Toggle chat" },
      { "<leader>cr", "<cmd>CopilotChatReset<cr>",  desc = "Reset session" },
      { "<leader>cm", "<cmd>CopilotChatCommit<cr>", desc = "Commit msg (diff)" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>",    desc = "Fix diagnostics" },
      { "<leader>c?", "<cmd>CopilotChatModels<cr>", desc = "Select Model" },
      { "<leader>ca", "<cmd>CopilotChatAgents<cr>", desc = "Select Agent" },
      {
        "<leader>cp",
        function() require("CopilotChat").select_prompt({ context = { "buffers" } }) end,
        desc = "Prompt actions",
      },
      {
        "<leader>cp",
        function() require("CopilotChat").select_prompt() end,
        mode = "x",
        desc = "Prompt actions (visual)",
      },
    },
    opts = {
      window = { layout = "vertical", width = 0.42 },
      question_header = "## You ",
      answer_header   = "## Copilot ",
      error_header    = "## Error ",
      mappings = {
        complete       = { insert = "<Tab>" },
        close          = { normal = "q", insert = "<C-c>" },
        reset          = { normal = "<C-x>", insert = "<C-x>" },
        submit_prompt  = { normal = "<CR>",  insert = "<C-CR>" },
        accept_diff    = { normal = "<C-y>", insert = "<C-y>" },
        show_help      = { normal = "g?" },
      },
      prompts = {
        Explain  = { prompt = "Explain the selected code, then propose 2 improvements." },
        Tests    = { prompt = "Write table-driven tests for the selected code (language-idiomatic)." },
        Refactor = { prompt = "Refactor for clarity and maintainability. Keep behavior the same." },
        Docs     = { prompt = "Add high-quality docstrings/comments for the selected code." },
      },
    },
  },

  -- Orquestrador de IA que usa Copilot como provider.
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { mapping_key_prefix .. "a", "<cmd>CodeCompanionActions<cr>",             desc = "CC: Actions" },
      { mapping_key_prefix .. "v", "<cmd>CodeCompanionChat Toggle<cr>",         desc = "CC: Toggle", mode = { "n", "v" } },
      { mapping_key_prefix .. "e", "<cmd>CodeCompanion /explain<cr>",           desc = "CC: Explain",  mode = "v" },
      { mapping_key_prefix .. "f", "<cmd>CodeCompanion /fix<cr>",               desc = "CC: Fix",      mode = "v" },
      { mapping_key_prefix .. "t", "<cmd>CodeCompanion /tests<cr>",             desc = "CC: Tests",    mode = "v" },
      { mapping_key_prefix .. "r", "<cmd>CodeCompanion /refactor<cr>",          desc = "CC: Refactor", mode = "v" },
      { mapping_key_prefix .. "R", "<cmd>CodeCompanion /review<cr>",            desc = "CC: Review",   mode = "v" },
      { mapping_key_prefix .. "d", "<cmd>CodeCompanion /inline-doc<cr>",        desc = "CC: InlineDoc",mode = "v" },
      { mapping_key_prefix .. "m", "<cmd>CodeCompanion /staged-commit<cr>",     desc = "CC: Commit (staged)" },
    },
    opts = function()
      local SYSTEM_PROMPT = string.format([[
You are "GitHub Copilot" inside Neovim on a %s machine.
Keep answers short, code-first, and use markdown fences with language.
Do not wrap whole response in triple backticks.
      ]], vim.loop.os_uname().sysname)

      return {
        strategies = {
          chat   = { adapter = "copilot" },
          inline = { adapter = "copilot" },
          agent  = { adapter = "copilot" },
        },
        inline = { layout = "buffer" },
        display = {
          chat = { show_settings = false, window = { layout = "vertical" } },
        },
        opts = { log_level = "WARN", system_prompt = SYSTEM_PROMPT },
        prompt_library = {
          ["Explain"] = {
            strategy = "chat",
            description = "Explain how code works",
            opts = { modes = { "v" }, auto_submit = true, user_prompt = false, stop_context_insertion = true },
            prompts = {
              { role = "user", content = function(ctx)
                  local code = require("codecompanion.helpers.actions").get_code(ctx.start_line, ctx.end_line)
                  return ("Explain this code, then propose 2 improvements:\n\n```%s\n%s\n```"):format(ctx.filetype, code)
                end,
                opts = { contains_code = true },
              },
            },
          },
          ["Refactor"] = {
            strategy = "inline",
            description = "Refactor for clarity",
            opts = { modes = { "v" }, auto_submit = true, user_prompt = false, stop_context_insertion = true },
            prompts = {
              { role = "user", content = function(ctx)
                  local code = require("codecompanion.helpers.actions").get_code(ctx.start_line, ctx.end_line)
                  return ("Refactor this code for clarity/maintainability, keep behavior:\n\n```%s\n%s\n```")
                    :format(ctx.filetype, code)
                end,
                opts = { contains_code = true },
              },
            },
          },
          ["Inline Document"] = {
            strategy = "inline",
            description = "Add doc comments",
            opts = { modes = { "v" }, auto_submit = true, user_prompt = false, stop_context_insertion = true },
            prompts = {
              { role = "user", content = function(ctx)
                  local code = require("codecompanion.helpers.actions").get_code(ctx.start_line, ctx.end_line)
                  return ("Add high-quality doc comments (idiomatic):\n\n```%s\n%s\n```"):format(ctx.filetype, code)
                end,
                opts = { contains_code = true },
              },
            },
          },
          ["Generate a Commit Message for Staged"] = {
            strategy = "chat",
            description = "Generate commit message for staged change",
            opts = { short_name = "staged-commit", auto_submit = true, is_slash_cmd = true },
            prompts = {
              { role = "user", content = function()
                  return "Write a commit message (conventional commits). Explain WHAT and WHY.\n\n```\n"
                    .. vim.fn.system("git diff --staged") .. "\n```"
                end,
                opts = { contains_code = true },
              },
            },
          },
        },
      }
    end,
  },

  -- UI alternativa para IA, estilo Cursor.
  {
    "yetone/avante.nvim",
    enabled = vim.g.use_avante == true, -- ative com: :lua vim.g.use_avante = true
    version = false,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua", -- garante copilot antes
    },
    opts = {
      provider = vim.env.AVANTE_PROVIDER or "copilot", -- "copilot" | "ollama" | "openai"
      hints = { enabled = false },
      windows = { position = "right", width = 0.42 },
      providers = {
        ollama = {
          endpoint = vim.env.OLLAMA_BASE_URL or "http://127.0.0.1:11434",
          model = vim.env.OLLAMA_MODEL or "llama3.1:8b",
        },
      },
    },
    keys = {
      { "<leader>av", "<cmd>AvanteToggle<cr>",     desc = "Avante: Toggle" },
      { "<leader>aa", "<cmd>AvanteAsk<cr>",        desc = "Avante: Ask (buffer)" },
      { "<leader>aA", "<cmd>AvanteAskVisual<cr>",  desc = "Avante: Ask (visual)", mode = "v" },
    },
  },
}

