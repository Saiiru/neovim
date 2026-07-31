-- vim: set foldmethod=marker foldlevel=0 foldmarker={{{,}}} : -
--
--

local aucmd = vim.api.nvim_create_autocmd
local bufmap = vim.api.nvim_buf_set_keymap
local opts = { noremap = true, silent = true }

local augroup = function(name)
	return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

--[[
  Check if we need to reload the file after changes
]]
--
aucmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	command = "checktime",
})

--[[
Auto create parent directories when saving a file
]]
--
aucmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

--[[
 Highlight on yank
 ]]
--
local yank_ns = vim.api.nvim_create_namespace("custom_highlight_yank")

aucmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		local event = vim.v.event
		if event.operator ~= "y" or event.regtype == "" then
			return
		end
		vim.hl.range(0, yank_ns, "IncSearch", "'[", "']", {
			regtype = event.regtype,
			inclusive = true,
			priority = vim.hl.priorities.user,
			timeout = 120,
		})
	end,
})

--[[
 Resize splits if window got resized
 ]]
--
aucmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

--[[
 Terminal escaping improvements
 ]]
--
aucmd({ "TermOpen" }, {
	group = augroup("terminals"),
	callback = function()
		bufmap(0, "n", "<C-\\>", "ToggleTerm", opts)
		bufmap(0, "t", "<C-w>h", [[<C-\><C-n><C-W>h]], opts)
		bufmap(0, "t", "<C-w>j", [[<C-\><C-n><C-W>j]], opts)
		bufmap(0, "t", "<C-w>k", [[<C-\><C-n><C-W>k]], opts)
		bufmap(0, "t", "<C-w>l", [[<C-\><C-n><C-W>l]], opts)
		bufmap(0, "t", "<esc><esc>", [[<C-\><C-n>]], opts)
		bufmap(0, "t", "jk", [[<C-\><C-n>]], opts)
	end,
})
