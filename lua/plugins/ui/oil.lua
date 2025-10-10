-- lua/plugins/ui/oil.lua :: Explorador de arquivos que substitui o netrw.

return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
            default_file_explorer = true, -- Ativa o oil como explorador de arquivos padrão.
			columns = { },
			keymaps = {
				["<C-h>"] = false,
                ["<C-c>"] = false, -- Impede que o oil seja fechado com <C-c>.
				["<M-h>"] = "actions.select_split",
                ["q"] = "actions.close",
			},
            delete_to_trash = true,
			view_options = {
				show_hidden = true,
			},
            skip_confirm_for_simple_edits = true,
		})

		-- Abre o diretório pai na janela atual.
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		-- Abre o diretório pai em uma janela flutuante.
		vim.keymap.set("n", "<leader>-", require("oil").toggle_float)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "oil",
            callback = function()
                vim.opt_local.cursorline = true
            end,
        })
	end,

}
