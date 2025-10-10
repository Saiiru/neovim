-- lua/plugins/util/gitworktree.lua :: Gerenciador de git worktrees com Telescope.

return {
	"ThePrimeagen/git-worktree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},

	config = function()
		local gitworktree = require("git-worktree")

		gitworktree.setup()

		require("telescope").load_extension("git_worktree")

		-- Keymaps para listar e criar worktrees.
		vim.keymap.set("n", "<leader>wl", function()
			require("telescope").extensions.git_worktree.git_worktrees()
		end, { desc = "list Git Worktree" })

		vim.keymap.set("n", "<leader>wc", function()
			require("telescope").extensions.git_worktree.create_git_worktree()
		end, { desc = "Create Git Worktree Branches" })
	end,
}
