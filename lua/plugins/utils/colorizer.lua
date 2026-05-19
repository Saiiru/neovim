-- lua/plugins/utils/colorizer.lua

return {
	"NvChad/nvim-colorizer.lua",
	event = "VeryLazy",
	opts = {
		user_default_options = {
			tailwind = true,
			mode = "background",
		},
	},
}
