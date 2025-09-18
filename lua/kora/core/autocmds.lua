-- ~/.config/nvim/lua/kora/core/autocmds.lua
-- Minimal, rápido, ASCII-only.

-- UTF-8 (global). Não force 'fileencoding' por buffer aqui.
vim.opt.encoding = "utf-8"

local aug = vim.api.nvim_create_augroup
local auc = vim.api.nvim_create_autocmd
local cmd = vim.cmd
local fn = vim.fn

-- groups
local g_yank = aug("kora_yank", { clear = true })
local g_resize = aug("kora_resize", { clear = true })
local g_numbers = aug("kora_numbers", { clear = true })
local g_comment = aug("kora_comment", { clear = true })
local g_mkdir = aug("kora_mkdir", { clear = true })
local g_trim = aug("kora_trim", { clear = true })
local g_term = aug("kora_term", { clear = true })
local g_diag_skip = aug("kora_diag_skip", { clear = true })
local g_lsp = aug("kora_lsp", { clear = true })
local g_format = aug("kora_format", { clear = true })
local g_restore = aug("kora_restore", { clear = true })
local g_check = aug("kora_checktime", { clear = true })
local g_large = aug("kora_large", { clear = true })
local g_md = aug("kora_markdown", { clear = true })
local g_localft = aug("kora_local_ftplugin", { clear = true })
local g_runner = aug("kora_runner", { clear = true })
local g_sanitize = aug("kora_sanitize", { clear = true })

-- 1) feedback ao yank
auc("TextYankPost", {
	group = g_yank,
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 120 })
	end,
})

-- 2) igualar splits ao redimensionar
auc("VimResized", {
	group = g_resize,
	callback = function()
		local tab = fn.tabpagenr()
		cmd("tabdo wincmd =")
		cmd("tabnext " .. tab)
	end,
})

-- 3) número relativo fora do insert
auc({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
	group = g_numbers,
	callback = function()
		if vim.o.number and vim.api.nvim_get_mode().mode ~= "i" then
			vim.o.relativenumber = true
		end
	end,
})
auc({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
	group = g_numbers,
	callback = function()
		if vim.o.number then
			vim.o.relativenumber = false
		end
	end,
})

-- 4) sem continuação de comentário
auc({ "BufWinEnter", "InsertEnter" }, {
	group = g_comment,
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- 5) criar diretório ao salvar
auc("BufWritePre", {
	group = g_mkdir,
	callback = function(args)
		if args.match:match("^%w%w+://") then
			return
		end
		local f = (vim.uv.fs_realpath(args.match) or args.match)
		fn.mkdir(fn.fnamemodify(f, ":p:h"), "p")
	end,
})

-- helper: só edite buffer de arquivo normal e modificável
local function can_edit()
	return vim.bo.buftype == "" and vim.bo.modifiable and not vim.bo.readonly
end

-- 6) trim trailing whitespace (respeita b:no_trim)
auc("BufWritePre", {
	group = g_trim,
	callback = function()
		if vim.b.no_trim or not can_edit() then
			return
		end
		local view = fn.winsaveview()
		cmd([[%s/\s\+$//e]])
		fn.winrestview(view)
	end,
})

-- 7) terminal limpo + startinsert
auc("TermOpen", {
	group = g_term,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
		vim.opt_local.spell = false
		vim.opt_local.foldcolumn = "0"
	end,
})
auc("BufEnter", { group = g_term, pattern = "term://*", command = "startinsert" })

-- 8) desativar diagnostics em pastas pesadas
auc({ "BufRead", "BufNewFile" }, {
	group = g_diag_skip,
	pattern = { "*/node_modules/*", "*/vendor/*", "*/dist/*", "*/build/*" },
	callback = function()
		vim.diagnostic.disable(0)
	end,
})

-- 9) LSP attach: keymaps e inlay hints (fallback se faltar telescope)
auc("LspAttach", {
	group = g_lsp,
	callback = function(ev)
		local buf = ev.buf
		local ok, tb = pcall(require, "telescope.builtin")
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
		end

		if ok then
			map("gd", tb.lsp_definitions, "Goto definition")
			map("gr", tb.lsp_references, "Goto references")
			map("gi", tb.lsp_implementations, "Goto implementations")
			map("gy", tb.lsp_type_definitions, "Goto type")
			map("<leader>ds", tb.lsp_document_symbols, "Doc symbols")
			map("<leader>ws", tb.lsp_dynamic_workspace_symbols, "Workspace symbols")
		else
			map("gd", vim.lsp.buf.definition, "Goto definition")
			map("gr", vim.lsp.buf.references, "Goto references")
			map("gi", vim.lsp.buf.implementation, "Goto implementations")
			map("gy", vim.lsp.buf.type_definition, "Goto type")
		end

		map("K", vim.lsp.buf.hover, "Hover")
		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
		map("]d", vim.diagnostic.goto_next, "Next diagnostic")
		map("gl", vim.diagnostic.open_float, "Line diagnostics")

		local client = ev.data and vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.server_capabilities and client.server_capabilities.inlayHintProvider then
			pcall(vim.lsp.inlay_hint.enable, true, { bufnr = buf })
		end
	end,
})

-- 10) format on save (skip em RO/!modifiable/large/generated)
auc("BufWritePre", {
	group = g_format,
	callback = function(args)
		if not can_edit() or vim.b.large_file or vim.b.format_on_save == false then
			return
		end
		local name = args.match:lower()
		if name:find("/node_modules/") or name:find("/vendor/") then
			return
		end
		local ok, conform = pcall(require, "conform")
		if ok then
			conform.format({ bufnr = args.buf, lsp_fallback = true, quiet = true })
		else
			pcall(vim.lsp.buf.format, { bufnr = args.buf, async = false, timeout_ms = 1500 })
		end
	end,
})

-- 11) restaurar cursor ao reabrir
auc("BufReadPost", {
	group = g_restore,
	callback = function()
		local mark = fn.line([['"]])
		if mark > 0 and mark <= fn.line("$") then
			pcall(cmd, 'normal! g`"')
		end
	end,
})

-- 12) autoread quando arquivo muda no disco
auc({ "FocusGained", "BufEnter", "CursorHold" }, {
	group = g_check,
	callback = function()
		if fn.getcmdwintype() == "" then
			cmd("checktime")
		end
	end,
})

-- 13) otimizar arquivos grandes (> 1 MB)
auc("BufReadPre", {
	group = g_large,
	callback = function()
		local file = fn.expand("<afile>")
		local size = fn.getfsize(file)
		if size > 1024 * 1024 then
			vim.b.large_file = true
			vim.opt_local.swapfile = false
			vim.opt_local.undofile = false
			vim.opt_local.foldmethod = "manual"
			pcall(function()
				vim.treesitter.stop(0)
			end)
			vim.defer_fn(function()
				for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
					pcall(vim.lsp.buf_detach_client, 0, c.id)
				end
			end, 50)
		end
	end,
})

-- 14) markdown prático
auc("FileType", {
	group = g_md,
	pattern = "markdown",
	callback = function()
		vim.opt_local.conceallevel = 2
		vim.opt_local.wrap = false
		vim.opt_local.linebreak = true
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
	end,
})

-- 15) ftplugin local do projeto: .nvim/ftplugin/<ft>.vim
auc({ "BufReadPost", "BufNewFile" }, {
	group = g_localft,
	callback = function()
		local ft = vim.bo.filetype
		if ft == "" then
			return
		end
		local path = fn.getcwd() .. "/.nvim/ftplugin/" .. ft .. ".vim"
		if fn.filereadable(path) == 1 then
			cmd("source " .. path)
		end
	end,
})

-- 16) runner por filetype (<leader>R) – abre terminal split
local function map_run(ft, shell)
	auc("FileType", {
		group = g_runner,
		pattern = ft,
		callback = function()
			vim.keymap.set("n", "<leader>R", function()
				if not can_edit() then
					return
				end
				local f = fn.expand("%")
				local r = fn.expand("%:r")
				local cmdline = shell:gsub("%%f", f):gsub("%%r", r)
				cmd("split | terminal " .. cmdline)
				cmd("resize 12")
			end, { buffer = true, silent = true, desc = "Run file" })
		end,
	})
end
map_run("c", "gcc %f -o %r && ./%r")
map_run("cpp", "g++ %f -o %r && ./%r")
map_run("go", "go run %f")
map_run("python", "python3 %f")
map_run("lua", "lua %f")
map_run("java", "javac %f && java %r")

-- 17) sanitizar zero-width (ZWSP/ZWNJ/ZWJ/BOM) ao salvar
auc("BufWritePre", {
	group = g_sanitize,
	callback = function()
		if not can_edit() then
			return
		end
		local view = fn.winsaveview()
		cmd([[%s/\%u200B\|\%u200C\|\%u200D\|\%uFEFF//ge]])
		fn.winrestview(view)
	end,
})
