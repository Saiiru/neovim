return {
	"gelguy/wilder.nvim",
	build = function()
		vim.cmd("UpdateRemotePlugins") -- registra o host Python do Wilder
	end,
	dependencies = {
		"romgrk/fzy-lua-native", -- para lua_fzy_highlighter
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		-- Verifica Python3 provider antes de ligar
		if vim.fn.has("python3") ~= 1 then
			vim.notify("Wilder desativado: provider python3 ausente (instale 'pynvim')", vim.log.levels.WARN)
			return
		end

		local ok, wilder = pcall(require, "wilder")
		if not ok then
			return
		end

		wilder.setup({ modes = { ":", "/", "?" } })

		-- highlighters opcionais (só usa os disponíveis)
		local highlighters = {}
		if wilder.lua_fzy_highlighter then
			table.insert(highlighters, wilder.lua_fzy_highlighter())
		end
		if wilder.lua_pcre2_highlighter then
			pcall(function()
				table.insert(highlighters, wilder.lua_pcre2_highlighter())
			end)
		end

		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
				min_width = "20%",
				max_height = "15%",
				reverse = 0,
				highlighter = highlighters,
				border = "single",
			}))
		)
	end,
}
