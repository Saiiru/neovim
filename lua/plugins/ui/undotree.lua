-- lua/plugins/ui/undotree.lua :: Visualizador de histórico de "undo".

return {
    "mbbill/undotree",
    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
}
