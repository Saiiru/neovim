local mapping_key_prefix = vim.g.ai_prefix_key or "<leader>a"
local IS_DEV = false

local system_prompt = string.format(
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
- Include the programming language name at the start of the Markdown code blocks.
- Avoid line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand.
- The user works in an IDE called Neovim which has open files, integrated unit test support, an output pane showing code run output, as well as an integrated terminal.
- The user is working on a %s machine. Please respond with system specific commands if applicable.

When given a task:
1. Think step-by-step and describe your plan in detailed pseudocode unless instructed otherwise.
2. Output the code in a single code block.
3. Provide short suggestions for next steps relevant to the conversation.
4. You can only provide one reply per conversation turn.
5. The active document is the source code the user is viewing.
]], vim.loop.os_uname().sysname
)

local copilot_explain = string.format(
  [[You are a world-class coding tutor. Your code explanations perfectly balance high-level concepts and granular details. Your approach ensures that students not only understand how to write code, but also grasp the underlying principles that guide effective programming.
When asked for your name, you must respond with "GitHub Copilot".
Follow the user's requirements carefully and to the letter.
Your expertise is strictly limited to software development topics.
Follow Microsoft content policies.
Avoid content that violates copyrights.
For questions not related to software development, simply remind the user that you are an AI programming assistant.
Keep your answers short and impersonal.
Use Markdown formatting in your answers.
Include the programming language name at the start of Markdown code blocks.
Avoid wrapping the whole response in triple backticks.
The user works in an IDE called Neovim which has open files, integrated unit test support, an output pane, and an integrated terminal.
The active document is the source code the user is viewing.
You can only provide one reply per conversation turn.
]], ""
)

local copilot_review = string.format(
  [[Your task is to review the provided code snippet focusing on readability and maintainability.
Identify issues such as:
- Unclear or inconsistent naming conventions.
- Lack of necessary comments or the presence of unnecessary ones.
- Overly complex expressions or high nesting levels.
- Inconsistent formatting or code style.
- Repetitive code patterns that could be abstracted.
Provide concise feedback with:
- A description of the issue.
- A concrete suggestion for improvement.
If no issues are found, simply confirm that the code is clear and well-written.
]], ""
)

local copilot_refactor = string.format(
  [[Your task is to refactor the provided code snippet to improve its readability and maintainability.
Focus on:
- Improving naming conventions.
- Reducing code complexity and nesting.
- Ensuring consistent formatting and style.
- Removing redundant patterns.
Provide a refactored version that is easier to understand while retaining the original functionality.
]], ""
)

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
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = false,
  },
  {
    dir = IS_DEV and "~/Projects/research/codecompanion.nvim" or nil,
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ibhagwan/fzf-lua",
      "jellydn/spinner.nvim",
    },
    opts = {
      strategies = {
        chat = {
          adapter = "copilot",
          roles = { llm = "  Copilot Chat", user = "IT Man" },
          slash_commands = {
            ["buffer"] = {
              callback = "strategies.chat.slash_commands.buffer",
              description = "Insert open buffers",
              opts = { contains_code = true, provider = "fzf_lua" },
            },
            ["file"] = {
              callback = "strategies.chat.slash_commands.file",
              description = "Insert a file",
              opts = { contains_code = true, max_lines = 1000, provider = "fzf_lua" },
            },
          },
          keymaps = {
            send = {
              modes = { n = "<CR>", i = "<C-CR>" },
              index = 1,
              callback = "keymaps.send",
              description = "Send",
            },
            close = {
              modes = { n = "q" },
              index = 3,
              callback = "keymaps.close",
              description = "Close Chat",
            },
            stop = {
              modes = { n = "<C-c>" },
              index = 4,
              callback = "keymaps.stop",
              description = "Stop Request",
            },
          },
        },
        inline = { adapter = "copilot" },
        agent = { adapter = "copilot" },
      },
      inline = { layout = "buffer" },
      display = {
        chat = {
          show_settings = false,
          window = { layout = "vertical" },
        },
      },
      opts = {
        log_level = "DEBUG",
        system_prompt = system_prompt,
      },
      prompt_library = {
        ["Generate a Commit Message"] = {
          prompts = {
            {
              role = "user",
              content = function()
                return "Write commit message with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'."
                  .. "\n\n```\n" .. vim.fn.system("git diff") .. "\n```"
              end,
              opts = { contains_code = true },
            },
          },
        },
        ["Explain"] = {
          strategy = "chat",
          description = "Explain how code in a buffer works",
          opts = {
            default_prompt = true,
            modes = { "v" },
            short_name = "explain",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            { role = "system", content = copilot_explain, opts = { visible = false } },
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                return "Please explain how the following code works:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
              end,
              opts = { contains_code = true },
            },
          },
        },
        ["Explain Code"] = {
          strategy = "chat",
          description = "Explain how code works",
          opts = { short_name = "explain-code", auto_submit = false, is_slash_cmd = true },
          prompts = {
            { role = "system", content = copilot_explain, opts = { visible = false } },
            { role = "user", content = "Please explain how the following code works." },
          },
        },
        ["Generate a Commit Message for Staged"] = {
          strategy = "chat",
          description = "Generate a commit message for staged change",
          opts = { short_name = "staged-commit", auto_submit = true, is_slash_cmd = true },
          prompts = {
            {
              role = "user",
              content = function()
                return "Write commit message for the change with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'."
                  .. "\n\n```\n" .. vim.fn.system("git diff --staged") .. "\n```"
              end,
              opts = { contains_code = true },
            },
          },
        },
        ["Inline Document"] = {
          strategy = "inline",
          description = "Add documentation for code.",
          opts = {
            modes = { "v" },
            short_name = "inline-doc",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                return "Please provide documentation in comment code for the following code and suggest better naming to improve readability.\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
              end,
              opts = { contains_code = true },
            },
          },
        },
        ["Document"] = {
          strategy = "chat",
          description = "Write documentation for code.",
          opts = {
            modes = { "v" },
            short_name = "doc",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                return "Please briefly explain how the following code works and provide documentation in comments. Also suggest improvements in naming for better readability.\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
              end,
              opts = { contains_code = true },
            },
          },
        },
        ["Review"] = {
          strategy = "chat",
          description = "Review the provided code snippet.",
          opts = {
            modes = { "v" },
            short_name = "review",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            { role = "system", content = copilot_review, opts = { visible = false } },
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                return "Please review the following code and provide suggestions for improvement, then refactor it to enhance clarity and readability:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
              end,
              opts = { contains_code = true },
            },
          },
        },
        ["Review Code"] = {
          strategy = "chat",
          description = "Review code and provide suggestions for improvement.",
          opts = { short_name = "review-code", auto_submit = false, is_slash_cmd = true },
          prompts = {
            { role = "system", content = copilot_review, opts = { visible = false } },
            { role = "user", content = "Please review the following code and provide suggestions for improvement, then refactor it to enhance clarity and readability." },
          },
        },
        ["Refactor"] = {
          strategy = "inline",
          description = "Refactor the provided code snippet.",
          opts = {
            modes = { "v" },
            short_name = "refactor",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            { role = "system", content = copilot_refactor, opts = { visible = false } },
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                return "Please refactor the following code to improve its clarity and readability:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
              end,
              opts = { contains_code = true },
            },
          },
        },
        ["Refactor Code"] = {
          strategy = "chat",
          description = "Refactor the provided code snippet.",
          opts = { short_name = "refactor-code", auto_submit = false, is_slash_cmd = true },
          prompts = {
            { role = "system", content = copilot_refactor, opts = { visible = false } },
            { role = "user", content = "Please refactor the following code to improve its clarity and readability." },
          },
        },
        ["Naming"] = {
          strategy = "inline",
          description = "Provide better naming for the provided code snippet.",
          opts = {
            modes = { "v" },
            short_name = "naming",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                return "Please provide better names for the following variables and functions:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
              end,
              opts = { contains_code = true },
            },
          },
        },
        ["Better Naming"] = {
          strategy = "chat",
          description = "Provide better naming for the provided code snippet.",
          opts = { short_name = "better-naming", auto_submit = false, is_slash_cmd = true },
          prompts = {
            { role = "user", content = "Please provide better names for the following variables and functions." },
          },
        },
      },
    },
    config = function(_, options)
      require("codecompanion").setup(options)
      local spinner = require("spinner")
      local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequest*",
        group = group,
        callback = function(request)
          if request.match == "CodeCompanionRequestStarted" then
            spinner.show()
          elseif request.match == "CodeCompanionRequestFinished" then
            spinner.hide()
          end
        end,
      })
    end,
    keys = {
      { mapping_key_prefix .. "a", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion - Actions" },
      { mapping_key_prefix .. "v", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Code Companion - Toggle", mode = { "n", "v" } },
      { mapping_key_prefix .. "e", "<cmd>CodeCompanion /explain<cr>", desc = "Code Companion - Explain code", mode = "v" },
      { mapping_key_prefix .. "f", "<cmd>CodeCompanion /fix<cr>", desc = "Code Companion - Fix code", mode = "v" },
      { mapping_key_prefix .. "l", "<cmd>CodeCompanion /lsp<cr>", desc = "Code Companion - Explain LSP diagnostic", mode = { "n", "v" } },
      { mapping_key_prefix .. "t", "<cmd>CodeCompanion /tests<cr>", desc = "Code Companion - Generate unit test", mode = "v" },
      { mapping_key_prefix .. "m", "<cmd>CodeCompanion /commit<cr>", desc = "Code Companion - Git commit message" },
      { mapping_key_prefix .. "M", "<cmd>CodeCompanion /staged-commit<cr>", desc = "Code Companion - Git commit message (staged)" },
      { mapping_key_prefix .. "d", "<cmd>CodeCompanion /inline-doc<cr>", desc = "Code Companion - Inline document code", mode = "v" },
      { mapping_key_prefix .. "D", "<cmd>CodeCompanion /doc<cr>", desc = "Code Companion - Document code", mode = "v" },
      { mapping_key_prefix .. "r", "<cmd>CodeCompanion /refactor<cr>", desc = "Code Companion - Refactor code", mode = "v" },
      { mapping_key_prefix .. "R", "<cmd>CodeCompanion /review<cr>", desc = "Code Companion - Review code", mode = "v" },
      { mapping_key_prefix .. "n", "<cmd>CodeCompanion /naming<cr>", desc = "Code Companion - Better naming", mode = "v" },
      { mapping_key_prefix .. "q", function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            vim.cmd("CodeCompanion " .. input)
          end
        end, desc = "Code Companion - Quick chat" },
    },
  },
}

