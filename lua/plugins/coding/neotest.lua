return {
	"nvim-neotest/neotest",
	dependencies = { "rcasia/neotest-java", "nvim-neotest/nvim-nio" },
	keys = {
		{
			"<leader>tn",
			function()
				require("neotest").run.run()
			end,
			desc = "Test Nearest",
		},
		{
			"<leader>tf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Test File",
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "Test Output",
		},
		{
			"<leader>ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Test Summary",
		},
		{
			"<leader>td",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "Debug Nearest",
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-java")({}),
			},
		})
	end,
}
