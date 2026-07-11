------------------------------
-- Toggle Location List
local function toggle_ll()
	for _, info in ipairs(vim.fn.getwininfo()) do
		if info.loclist == 1 then
			vim.cmd("lclose")
			return
		end
	end

	if next(vim.fn.getloclist(0)) == nil then
		print("loc list empty")
		return
	end
	vim.cmd("lopen")
end
vim.api.nvim_create_user_command("ToggleLocList", toggle_ll, {})

---------------------------------
-- Toggle Quickfix
local function toggle_qf()
	for _, info in ipairs(vim.fn.getwininfo()) do
		if info.quickfix == 1 then
			vim.cmd("cclose")
			return
		end
	end

	if next(vim.fn.getqflist()) == nil then
		print("qf list empty")
		return
	end
	vim.cmd("copen")
end
vim.api.nvim_create_user_command("ToggleQFList", toggle_qf, {})
