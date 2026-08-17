local p = require("theme.palette")

local colors = {
	bg = p.bg0,
	fg = p.fg0,
	yellow = p.amber,
	cyan = p.cyan,
	darkblue = p.bg1,
	green = p.green,
	orange = p.orange,
	violet = p.violet,
	magenta = p.violet,
	blue = p.blue,
	red = p.red,
	graphite = p.bg2,
	dim = p.muted,
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

local function mode_key()
	return vim.fn.mode(1)
end

local function mode_name()
	local names = {
		n = "NORMAL",
		no = "OP-PENDING",
		nov = "OP-PENDING",
		noV = "OP-PENDING",
		["no\22"] = "OP-PENDING",
		niI = "NORMAL",
		niR = "NORMAL",
		niV = "NORMAL",
		nt = "NORMAL",
		v = "VISUAL",
		vs = "VISUAL",
		V = "V-LINE",
		Vs = "V-LINE",
		["\22"] = "V-BLOCK",
		["\22s"] = "V-BLOCK",
		s = "SELECT",
		S = "S-LINE",
		["\19"] = "S-BLOCK",
		i = "INSERT",
		ic = "INSERT",
		ix = "INSERT",
		R = "REPLACE",
		Rc = "REPLACE",
		Rx = "REPLACE",
		Rv = "V-REPLACE",
		Rvc = "V-REPLACE",
		Rvx = "V-REPLACE",
		c = "COMMAND",
		cv = "EX",
		ce = "EX",
		r = "PROMPT",
		rm = "MORE",
		["r?"] = "CONFIRM",
		["!"] = "SHELL",
		t = "TERMINAL",
	}
	return names[mode_key()] or mode_key():upper()
end

local function mode_color()
	local map = {
		n = colors.yellow,
		no = colors.yellow,
		nov = colors.yellow,
		noV = colors.yellow,
		["no\22"] = colors.yellow,
		i = colors.green,
		ic = colors.green,
		ix = colors.green,
		v = colors.blue,
		vs = colors.blue,
		V = colors.blue,
		Vs = colors.blue,
		["\22"] = colors.blue,
		["\22s"] = colors.blue,
		s = colors.orange,
		S = colors.orange,
		["\19"] = colors.orange,
		c = colors.magenta,
		R = colors.violet,
		Rc = colors.violet,
		Rx = colors.violet,
		Rv = colors.violet,
		Rvc = colors.violet,
		Rvx = colors.violet,
		r = colors.cyan,
		rm = colors.cyan,
		["r?"] = colors.cyan,
		["!"] = colors.red,
		t = colors.red,
	}
	return map[mode_key()] or colors.yellow
end

local function file_size()
	local file = vim.fn.expand("%:p")
	if file == "" then
		return ""
	end
	local size = vim.fn.getfsize(file)
	if size <= 0 then
		return ""
	end
	local suffixes = { "b", "k", "m", "g" }
	local i = 1
	while size > 1024 and i < #suffixes do
		size = size / 1024
		i = i + 1
	end
	return string.format("%.1f%s", size, suffixes[i])
end

local function pde_component()
	local ok, detect = pcall(require, "pde.detect")
	if not ok then
		return "PDE"
	end
	local info = detect.detect(0)
	if info.framework == "unknown" then
		return "PDE"
	end
	return info.type .. ":" .. info.framework
end

local function lsp_component()
	local names = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		table.insert(names, client.name)
	end
	table.sort(names)
	return #names > 0 and ("LSP:" .. table.concat(names, ",")) or "LSP:-"
end

local function lualine_theme()
	return {
		normal = { c = { fg = colors.fg, bg = colors.bg } },
		insert = { c = { fg = colors.fg, bg = colors.bg } },
		visual = { c = { fg = colors.fg, bg = colors.bg } },
		replace = { c = { fg = colors.fg, bg = colors.bg } },
		command = { c = { fg = colors.fg, bg = colors.bg } },
		inactive = { c = { fg = colors.fg, bg = colors.bg } },
	}
end

local function lualine_config()
	local config = {
		options = {
			globalstatus = true,
			component_separators = "",
			section_separators = "",
			theme = lualine_theme(),
			disabled_filetypes = {
				statusline = { "dashboard", "snacks_dashboard" },
				winbar = { "dashboard", "snacks_dashboard", "help", "quickfix" },
			},
		},
		sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {
				{
					"filename",
					path = 1,
					color = { fg = colors.dim, bg = colors.bg, gui = "italic" },
				},
			},
			lualine_x = {
				{ "location", color = { fg = colors.dim, bg = colors.bg } },
			},
			lualine_y = {},
			lualine_z = {},
		},
	}

	local function ins_left(component)
		table.insert(config.sections.lualine_c, component)
	end

	local function ins_right(component)
		table.insert(config.sections.lualine_x, component)
	end

	ins_left({
		function()
			return "▊"
		end,
		color = function()
			return { fg = mode_color(), bg = colors.bg, gui = "bold" }
		end,
		padding = { left = 0, right = 0 },
	})
	ins_left({
		mode_name,
		color = function()
			return { fg = mode_color(), bg = colors.bg, gui = "bold" }
		end,
		padding = { left = 1, right = 1 },
	})
	ins_left({
		file_size,
		cond = conditions.buffer_not_empty,
		color = { fg = colors.fg, bg = colors.bg },
	})
	ins_left({
		"filename",
		cond = conditions.buffer_not_empty,
		path = 1,
		color = { fg = colors.blue, bg = colors.bg, gui = "bold" },
	})
	ins_left({ "location", color = { fg = colors.fg, bg = colors.bg } })
	ins_left({
		"progress",
		color = { fg = colors.fg, bg = colors.bg, gui = "bold" },
	})
	ins_left({
		"diagnostics",
		sources = { "nvim_lsp" },
		symbols = {
			error = " ",
			warn = " ",
			info = " ",
			hint = " ",
		},
		diagnostics_color = {
			error = { fg = colors.red, bg = colors.bg },
			warn = { fg = colors.yellow, bg = colors.bg },
			info = { fg = colors.cyan, bg = colors.bg },
			hint = { fg = colors.fg, bg = colors.bg },
		},
	})
	ins_left({
		function()
			return "%="
		end,
	})
	ins_left({
		lsp_component,
		icon = " LSP:",
		color = { fg = colors.fg, bg = colors.bg, gui = "bold" },
	})
	ins_left({ pde_component, color = { fg = colors.yellow, bg = colors.bg } })

	ins_right({
		"o:encoding",
		upper = true,
		cond = conditions.hide_in_width,
		color = { fg = colors.green, bg = colors.bg, gui = "bold" },
	})
	ins_right({
		"fileformat",
		upper = true,
		icons_enabled = false,
		color = { fg = colors.green, bg = colors.bg, gui = "bold" },
	})
	ins_right({
		"branch",
		icon = "",
		cond = conditions.check_git_workspace,
		color = { fg = colors.violet, bg = colors.bg, gui = "bold" },
	})
	ins_right({
		"diff",
		symbols = { added = " ", modified = " ", removed = " " },
		diff_color = {
			added = { fg = colors.green, bg = colors.bg },
			modified = { fg = colors.orange, bg = colors.bg },
			removed = { fg = colors.red, bg = colors.bg },
		},
		cond = conditions.hide_in_width,
	})
	ins_right({
		function()
			return "▊"
		end,
		color = function()
			return { fg = mode_color(), bg = colors.bg, gui = "bold" }
		end,
		padding = { left = 0, right = 0 },
	})

	return config
end

return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		cond = function()
			return true
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = lualine_config,
	},
}
