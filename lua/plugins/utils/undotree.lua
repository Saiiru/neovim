-- lua/plugins/utils/undotree.lua

return {
	"mbbill/undotree",
	event = "VeryLazy",
	keys = {
		{ "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "UndoTree Toggle" },
		{ "<leader>uf", "<cmd>UndotreeFocus<cr>", desc = "UndoTree Focus" },
	},
}
