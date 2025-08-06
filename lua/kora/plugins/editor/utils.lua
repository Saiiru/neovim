-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                KORA ESSENTIAL EDITOR TOOLS & BEHAVIOR MATRIX           ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
	-- ═══════════════════════════════════════════════════════════════════════════
	-- 📦 CORE DEPENDENCIES
	-- ═══════════════════════════════════════════════════════════════════════════
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- ═══════════════════════════════════════════════════════════════════════════
	-- 🧹 MINI.BUFREMOVE - CLEAN BUFFER MANAGEMENT
	-- ═══════════════════════════════════════════════════════════════════════════
	{
		"echasnovski/mini.bufremove",
		keys = {
			{
				"<leader>bd",
				function()
					local bd = require("mini.bufremove").delete
					if vim.bo.modified then
						local choice =
							vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
						if choice == 1 then
							vim.cmd.write()
							bd(0)
						elseif choice == 2 then
							bd(0, true)
						end
					else
						bd(0)
					end
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>bD",
				function()
					require("mini.bufremove").delete(0, true)
				end,
				desc = "Delete Buffer (Force)",
			},
		},
		opts = {},
	},

	-- ═══════════════════════════════════════════════════════════════════════════
	-- 💾 PERSISTENCE - SESSION MANAGEMENT MATRIX
	-- ═══════════════════════════════════════════════════════════════════════════
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = vim.opt.sessionoptions:get() },
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Current Session",
			},
		},
	},
}
