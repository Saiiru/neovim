-- lua/plugins/ui/vim-maximizer.lua :: Maximiza e minimiza splits.

return {
	"szw/vim-maximizer",
	keys = {
		{ "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
	},
}
