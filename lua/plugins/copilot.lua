return {
	-- copilot
	{
		"zbirenbaum/copilot.lua",
		verylazy = true,
		cmd = "Copilot",
		build = ":Copilot auth",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
				lua = true,
				bash = true,
			},
		},
	},

     {

    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    opts = {
      debug = false, -- Enable debugging
      -- default prompts
      prompts = {
        CommitStaged = {
          prompt =
          'Write a commit message following the commitizen convention. The title should be a concise summary of the change, with a maximum of 50 characters. The message should include a detailed description of what was changed and why, wrapped at 72 characters per line. Wrap the whole message in a code block with language gitcommit. Ensure the message is clear and informative for future reference.',
        },
      },
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatLoad",
      "CopilotChatDebugInfo",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatFixDiagnostic",
      "CopilotChatCommit",
      "CopilotChatCommitStaged",
    }
  },
    {
     'tzachar/cmp-tabnine',
     build = './install.sh',
     dependencies = 'hrsh7th/nvim-cmp',
 },
}
