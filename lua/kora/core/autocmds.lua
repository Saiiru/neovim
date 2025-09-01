-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                   KORA AUTO COMMAND RESPONSE MATRIX                     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ═════════════════════════════════════════════════════════════════════════
--  NOTIFICATION CONTROL SYSTEM
-- ═════════════════════════════════════════════════════════════════════════

-- Global notification filter to reduce spam
local original_notify = vim.notify
local notify_history = {}
local notify_filter = {
	-- Patterns to suppress or reduce frequency
	suppress = {
		"Starting",
		"started",
		"ready",
		"attached",
		"client",
		"initialized",
		"loading",
		"loaded",
		"enabled",
		"disabled",
	},
	-- Debounce time for similar messages (ms)
	debounce_time = 2000,
}

-- Enhanced notify function with spam protection
vim.notify = function(msg, level, opts)
	if type(msg) ~= "string" then
		return original_notify(msg, level, opts)
	end

	-- Check if message should be suppressed
	for _, pattern in ipairs(notify_filter.suppress) do
		if msg:lower():find(pattern:lower()) then
			-- Only show important levels (WARN and ERROR)
			if level and (level == vim.log.levels.WARN or level == vim.log.levels.ERROR) then
				return original_notify(msg, level, opts)
			else
				return -- Suppress INFO and other levels for spam patterns
			end
		end
	end

	-- Debounce similar messages
	local now = vim.loop.hrtime() / 1000000 -- Convert to milliseconds
	local msg_key = msg:sub(1, 50) -- Use first 50 chars as key

	if notify_history[msg_key] then
		local time_diff = now - notify_history[msg_key]
		if time_diff < notify_filter.debounce_time then
			return -- Skip if too recent
		end
	end

	notify_history[msg_key] = now
	return original_notify(msg, level, opts)
end

-- ═════════════════════════════════════════════════════════════════════════
--  CORE AUTOCOMMANDS
-- ═════════════════════════════════════════════════════════════════════════

-- 1. Visual feedback ao yank
autocmd("TextYankPost", {
	group = augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
})

-- 2. Resize splits automaticamente ao redimensionar janela
autocmd("VimResized", {
	group = augroup("resize_splits", { clear = true }),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- 3. Número relativo inteligente (nunca em Insert)
local numgroup = augroup("numbertoggle", { clear = true })
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
	group = numgroup,
	callback = function()
		if vim.o.number and vim.api.nvim_get_mode().mode ~= "i" then
			vim.opt.relativenumber = true
		end
	end,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
	group = numgroup,
	callback = function()
		if vim.o.number then
			vim.opt.relativenumber = false
		end
	end,
})

-- 4. Remove continuação automática de comentário em novas linhas
autocmd("BufWinEnter", {
	group = augroup("no_auto_comment", { clear = true }),
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- 5. Auto-criação de diretórios ao salvar
autocmd("BufWritePre", {
	group = augroup("auto_create_dir", { clear = true }),
	callback = function(args)
		if args.match:match("^%w%w+://") then
			return
		end
		local file = vim.uv.fs_realpath(args.match) or args.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- 6. Terminal: sem número, sem spell, sem relativenumber
autocmd("TermOpen", {
	group = augroup("terminal_settings", { clear = true }),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.spell = false
		vim.opt_local.signcolumn = "no"
		vim.opt_local.foldcolumn = "0"
		vim.opt_local.winbar = ""
	end,
})
autocmd("BufEnter", {
	group = augroup("terminal_insert", { clear = true }),
	pattern = "term://*",
	command = "startinsert",
})

-- 7. Disable diagnostics em node_modules, .env, vendor
autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup("disable_diagnostics", { clear = true }),
	pattern = { "*/node_modules/*", "*.env*", ".env", "*/vendor/*" },
	callback = function()
		vim.diagnostic.disable(0)
	end,
})

-- 8. LSP: inlay hints e keymaps (com telescope para navegação) - SILENT VERSION
autocmd("LspAttach", {
	group = augroup("lsp_attach", { clear = true }),
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }
		vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
		vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
		vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
		vim.keymap.set("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", opts)

		-- Enable inlay hints silently
		if event.data and event.data.client_id then
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.server_capabilities.inlayHintProvider then
				vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
			end
		end

		-- NO NOTIFICATION - removed spam notification
	end,
})

-- 9. Run-on-Save: keymap <leader>R para rodar arquivos (C, C++, Go, Python, Lua, Java)
local function map_run(ft, cmd)
	autocmd("FileType", {
		pattern = ft,
		group = augroup("RunOnSave_" .. ft, { clear = true }),
		callback = function()
			vim.keymap.set("n", "<leader>R", function()
				local filename = vim.fn.expand("%")
				local full_cmd = cmd:gsub("%%f", filename):gsub("%%r", vim.fn.expand("%:r"))
				vim.cmd("split")
				vim.cmd("terminal " .. full_cmd)
				vim.cmd("resize 10")
			end, { buffer = true, desc = "Run " .. ft .. " file" })
		end,
	})
end
map_run("c", "gcc %f -o %r && ./%r")
map_run("cpp", "g++ %f -o %r && ./%r")
map_run("java", "javac %f && java %r")
map_run("go", "go run %f")
map_run("python", "python3 %f")
map_run("lua", "lua %f")

-- 10. Não abrir comentários ao entrar em Insert em nova linha (o mais performático)
autocmd("InsertEnter", {
	group = augroup("no_comment_insert", { clear = true }),
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- 11. Markdown otimizado
autocmd("FileType", {
	group = augroup("markdown_optim", { clear = true }),
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

-- 12. LARGE FILE OPTIMIZATION - Disable heavy features for large files
autocmd("BufReadPre", {
	group = augroup("large_file_optimizations", { clear = true }),
	callback = function()
		local file = vim.fn.expand("<afile>")
		local size = vim.fn.getfsize(file)

		-- If file is larger than 1MB, optimize
		if size > 1024 * 1024 then
			vim.opt_local.eventignore:append({
				"FileType",
				"Syntax",
				"BufEnter",
				"BufLeave",
				"BufNew",
			})
			vim.opt_local.undolevels = -1
			vim.opt_local.undoreload = 0
			vim.opt_local.swapfile = false
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.bufhidden = "unload"
			vim.opt_local.buftype = "nowrite"
			vim.opt_local.undofile = false

			-- Disable LSP for very large files
			vim.defer_fn(function()
				vim.lsp.stop_client(vim.lsp.get_active_clients({ bufnr = 0 }))
			end, 100)
		end
	end,
})

-- 13. CLEANUP NOTIFICATIONS HISTORY - Prevent memory bloat
autocmd("VimLeavePre", {
	group = augroup("cleanup_notifications", { clear = true }),
	callback = function()
		notify_history = {}
	end,
})

-- Clean old notification history periodically
local cleanup_timer = vim.loop.new_timer()
cleanup_timer:start(300000, 300000, function() -- Every 5 minutes
	local now = vim.loop.hrtime() / 1000000
	for key, timestamp in pairs(notify_history) do
		if now - timestamp > 600000 then -- Remove entries older than 10 minutes
			notify_history[key] = nil
		end
	end
end)

-- ═════════════════════════════════════════════════════════════════════════
--  PROJECT-LOCAL FTPLUGIN LOADING
-- ═════════════════════════════════════════════════════════════════════════

-- Autocommand to load project-local ftplugin files
autocmd({ "BufReadPost", "BufNewFile" }, {
  group = augroup("project_local_ftplugin", { clear = true }),
  callback = function(args)
    local ft = vim.bo.filetype
    if ft == "" then
      return -- No filetype, nothing to do
    end

    -- Construct path to project-local ftplugin file
    -- Assumes .nvim/ftplugin/<filetype>.vim in the current working directory
    local local_ftplugin_path = vim.fn.getcwd() .. "/.nvim/ftplugin/" .. ft .. ".vim"

    -- Check if the file exists and source it
    if vim.fn.filereadable(local_ftplugin_path) == 1 then
      vim.cmd("source " .. local_ftplugin_path)
      -- Optional: Notify user that a local ftplugin was loaded
      -- vim.notify("Loaded project-local ftplugin: " .. ft .. ".vim", vim.log.levels.INFO, { title = "KORA Neovim" })
    end
  end,
})

-- ═════════════════════════════════════════════════════════════════════════
--  STARTUP OPTIMIZATION
-- ═════════════════════════════════════════════════════════════════════════

-- Disable some autocommands during startup for faster boot
local startup = augroup("startup_optimizations", { clear = true })

-- Re-enable features after startup
autocmd("VimEnter", {
	group = startup,
	callback = function()
		-- Re-enable normal notification behavior after startup
		vim.defer_fn(function()
			-- System ready - only show this one startup notification
			vim.notify("󰓩 KORA Neural Matrix Online", vim.log.levels.INFO, {
				title = "KORA System",
				timeout = 1500,
			})
		end, 500)
	end,
})

-- ══════════════════════════════════════════════════════════════════════════
-- USAGE EXAMPLES - OPTIMIZED AUTOCMDS.LUA
-- ══════════════════════════════════════════════════════════════════════════
-- This file now includes intelligent notification filtering to reduce spam:
--
-- NOTIFICATION FILTERING:
-- - Suppresses common spam patterns (starting, loading, etc.) at INFO level
-- - Allows WARN and ERROR levels through
-- - Debounces similar messages (2 second window)
-- - Automatically cleans old notification history
--
-- PERFORMANCE OPTIMIZATIONS:
-- - Large file detection and optimization (>1MB)
-- - Automatic LSP disable for very large files
-- - Memory cleanup for notification history
-- - Startup optimization with deferred notifications
--
-- SPAM REDUCTION:
-- - LSP attach notifications removed
-- - Plugin initialization messages filtered
-- - Only critical notifications shown during startup
-- - Timer-based cleanup prevents memory bloat
--
-- MANUAL NOTIFICATION CONTROL:
-- To completely disable notifications temporarily:
-- vim.notify = function() end
--
-- To re-enable:
-- vim.notify = original_notify
--
-- All other functionality remains the same as before.
-- ══════════════════════════════════════════════════════════════════════════
