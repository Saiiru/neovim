-- lua/plugins/coding/fugitive.lua

return {
	"tpope/vim-fugitive",
	cmd = "Git",
	keys = {
		{ "<leader>gs", vim.cmd.Git, desc = "Git Status" },
		{ "<leader>gb", ":Git blame<cr>", desc = "Git Blame" },
		{ "<leader>gA", ":Git add .<cr>", desc = "Git Add All" },
		{ "<leader>ga", ":Git add ", desc = "Git Add (Partial)" },
		{ "<leader>gc", ":Git commit", desc = "Git Commit" },
		{ "<leader>gp", ":Git push", desc = "Git Push" },
	},
	config = function()
		local sairu_Fugitive = vim.api.nvim_create_augroup("sairu_Fugitive", {})

		vim.api.nvim_create_autocmd("BufWinEnter", {
			group = sairu_Fugitive,
			pattern = "*",
			callback = function()
				if vim.bo.ft ~= "fugitive" then
					return
				end

				local bufnr = vim.api.nvim_get_current_buf()
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "<leader>p", function()
					vim.cmd.Git("push")
				end, opts)

				-- rebase always
				vim.keymap.set("n", "<leader>P", function()
					vim.cmd.Git({ "pull", "--rebase" })
				end, opts)

				-- NOTE: It allows me to easily set the branch i am pushing and any tracking
				-- needed if i did not set the branch up correctly
				vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
			end,
		})

		vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>", { desc = "Git Diff Get Left" })
		vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { desc = "Git Diff Get Right" })
	end,
}
