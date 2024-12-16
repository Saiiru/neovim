local mapping_key_prefix = vim.g.ai_prefix_key or "<leader>A"
local IS_DEV = false

-- This is a custom system prompt for Copilot adapter
-- Base on https://github.com/olimorris/codecompanion.nvim and https://github.com/CopilotC-Nvim
local SYSTEM_PROMPT = string.format(
  [[You are an AI programming assistant named "GitHub Copilot".
You are currently plugged in to the Neovim text editor on a user's machine.

Your tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Asking how to do something in the terminal.
- Explaining what just happened in the terminal.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of Markdown code blocks.
- Avoid line numbers in code blocks.
- Only return code relevant to the task at hand.
- The user works in an IDE called Neovim which has open files, integrated unit test support, an output pane, and an integrated terminal.
- The user is working on a %s machine. Respond with system-specific commands if applicable.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, unless asked not to.
2. Output the code in a single code block.
3. Always generate short suggestions for the next user turns relevant to the conversation.
4. You can only give one reply for each conversation turn.
5. The active document is the source code the user is looking at right now.
]],
  vim.loop.os_uname().sysname
)

local COPILOT_EXPLAIN = string.format(
  [[You are a world-class coding tutor. Your code explanations perfectly balance high-level concepts and granular details. Your approach ensures that students not only understand how to write code but also grasp the underlying principles that guide effective programming.
When asked for your name, you must respond with "GitHub Copilot".
Follow the user's requirements carefully & to the letter.
Your expertise is strictly limited to software development topics.
Follow Microsoft content policies.
Avoid content that violates copyrights.
For questions not related to software development, remind users that you are an AI programming assistant.
Keep your answers short and impersonal.
Use Markdown formatting in your answers.
Include the programming language name at the start of Markdown code blocks.
Avoid wrapping the whole response in triple backticks.
The user works in Neovim with open files, an output pane for code execution results, and an integrated terminal.
The active document is the source code the user is looking at right now.

Additional Rules:
Think step by step:
1. Examine the provided code selection and other context such as user questions, related errors, and project details.
2. If unsure about the code or user's question, ask clarifying questions.
3. If the user provides a specific question or error, answer based on the selected code and provided context.
4. Suggest opportunities to improve code readability, performance, etc.
Focus on being clear, helpful, and thorough without assuming extensive prior knowledge.
Use developer-friendly terms and analogies in explanations.
Identify 'gotchas' or less obvious parts of the code that might trip up someone new.
Provide relevant examples aligned with the provided context.
]],
  vim.loop.os_uname().sysname
)

local COPILOT_REVIEW =
  string.format [[Your task is to review the provided code snippet, focusing on readability and maintainability.
Identify issues such as:
- Unclear or inconsistent naming conventions.
- Presence of unnecessary or missing comments.
- Overly complex expressions.
- High nesting levels.
- Excessively long variable or function names.
- Repetitive patterns better handled through abstraction or optimization.

Feedback format:
- Briefly explain the high-level issue.
- Provide a specific suggestion for improvement.
If no issues exist, confirm the code is clear and well-written as is.
]]

local COPILOT_REFACTOR =
  string.format [[Refactor the provided code snippet, focusing on readability and maintainability.
Address issues such as:
- Unclear or inconsistent naming conventions.
- Overly complex expressions.
- High nesting levels.
- Repetitive patterns better handled through abstraction or optimization.
]]

return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { mapping_key_prefix, group = "AI Code Companion", mode = { "n", "v" } },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "yaml", "markdown" } },
  },
  {
    dir = IS_DEV and "~/Projects/research/codecompanion.nvim" or nil,
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "jellydn/spinner.nvim",
    },
    opts = {
      strategies = {
        chat = {
          adapter = "copilot",
          roles = { llm = "  Copilot Chat", user = "Sairu" },
          slash_commands = {
            ["buffer"] = {
              callback = "helpers.slash_commands.buffer",
              description = "Insert open buffers",
              opts = {
                contains_code = true,
              },
            },
            ["file"] = {
              callback = "helpers.slash_commands.file",
              description = "Insert a file",
              opts = {
                contains_code = true,
                max_lines = 1000,
              },
            },
          },
          keymaps = {
            send = {
              modes = {
                n = "<CR>",
                i = "<C-CR>",
              },
              index = 1,
              callback = "keymaps.send",
              description = "Send",
            },
            close = {
              modes = {
                n = "q",
              },
              index = 3,
              callback = "keymaps.close",
              description = "Close Chat",
            },
            stop = {
              modes = {
                n = "<C-c>",
              },
              index = 4,
              callback = "keymaps.stop",
              description = "Stop Request",
            },
          },
        },
        inline = { adapter = "copilot" },
        agent = { adapter = "copilot" },
      },
      inline = {
        layout = "buffer",
      },
      display = {
        chat = {
          show_settings = false,
          window = {
            layout = "vertical",
          },
        },
      },
      opts = {
        log_level = "DEBUG",
        system_prompt = SYSTEM_PROMPT,
      },
    },
  },
}
