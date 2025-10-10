-- lua/core/autocmds.lua :: Autocomandos para automação e QoL

-- Prefixo para augroups, para evitar conflitos.
local function aug(name)
	return vim.api.nvim_create_augroup("SAIRU_" .. name, { clear = true })
end

-- =============== Helpers =================
-- Encontra o diretório raiz do projeto (git, etc.)
local function root_dir(buf)
	local fname = vim.api.nvim_buf_get_name(buf or 0)
	local base = vim.fs.dirname(fname ~= "" and fname or vim.loop.cwd())
	local markers = {
		"gradlew",
		"mvnw",
		"pom.xml",
		"build.gradle",
		"build.gradle.kts",
		"go.mod",
		"Cargo.toml",
		"pyproject.toml",
		"poetry.lock",
		"requirements.txt",
		"package.json",
		"deno.json",
		"deno.jsonc",
		"bun.lockb",
		"composer.json",
		".git",
	}
	local found = vim.fs.find(markers, { upward = true, path = base })[1]
	return found and vim.fs.dirname(found) or base
end

-- Roda um comando em um terminal splitado.
local function termrun(cmd, opts)
	opts = opts or {}
	local cwd = opts.cwd or root_dir(0)
	vim.cmd("belowright split")
	vim.cmd("resize " .. (opts.height or 12))
	vim.cmd("terminal")
	local chan = vim.b.terminal_job_id
	if cwd and cwd ~= "" then
		vim.fn.chansend(chan, "cd " .. vim.fn.fnameescape(cwd) .. "\r")
	end
	for _, c in ipairs(type(cmd) == "table" and cmd or { cmd }) do
		vim.fn.chansend(chan, c .. "\r")
	end
end
-- Mapeia uma tecla no buffer atual.
local function map_buf(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { buffer = 0, silent = true, desc = desc })
end
-- Verifica se um arquivo existe na raiz do projeto.
local function has_file(root, files)
	for _, f in ipairs(files) do
		if vim.loop.fs_stat(root .. "/" .. f) then
			return true
		end
	end
end

-- =============== QoL gerais =================

-- Restaura a posição do cursor ao abrir um buffer.
-- Util para voltar onde parou.
vim.api.nvim_create_autocmd("BufReadPost", {
	group = aug("RestoreCursor"),
	callback = function(args)
		local m = vim.api.nvim_buf_get_mark(args.buf, '"')
		local lcount = vim.api.nvim_buf_line_count(args.buf)
		if m[1] > 0 and m[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, m)
		end
	end,
})

-- Highlight na linha ao dar yank.
vim.api.nvim_create_autocmd("TextYankPost", {
	group = aug("YankHL"),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 120 })
	end,
})

-- Ajusta o tamanho dos splits ao redimensionar a janela.
vim.api.nvim_create_autocmd("VimResized", { group = aug("Resize"), command = "tabdo wincmd =" })

-- Impede que o Neovim continue comentários automaticamente.
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
	group = aug("NoCommentCont"),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- Mostra números relativos apenas no modo Normal.
vim.api.nvim_create_autocmd("InsertEnter", {
	group = aug("RelNumToggle"),
	callback = function()
		vim.wo.relativenumber = false
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	group = aug("RelNumToggle"),
	callback = function()
		vim.wo.relativenumber = true
	end,
})

-- Verifica se o arquivo foi modificado no disco quando o Neovim ganha foco.
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = aug("CheckTime"),
	command = "checktime",
})

-- Cria diretórios automaticamente ao salvar um arquivo.
vim.api.nvim_create_autocmd("BufWritePre", {
	group = aug("MkDirs"),
	callback = function(args)
		local dir = vim.fn.fnamemodify(args.match, ":p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-- Remove espaços em branco no final da linha ao salvar.
-- Ignora arquivos markdown, diff e binários.
vim.api.nvim_create_autocmd("BufWritePre", {
	group = aug("TrimWS"),
	callback = function(args)
		if
			vim.bo[args.buf].buftype ~= ""
			or vim.bo[args.buf].binary
			or vim.bo[args.buf].filetype == "markdown"
			or vim.wo.diff
		then
			return
		end
		local view = vim.fn.winsaveview()
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})

-- Salva automaticamente ao modificar o texto (se g:auto_save = 1).
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
	group = aug("AutoSave"),
	callback = function()
		if vim.g.auto_save == 1 and vim.bo.modifiable and vim.bo.buftype == "" then
			pcall(vim.cmd, "silent write")
		end
	end,
})

-- Mostra diagnostics em um float ao parar o cursor.
vim.api.nvim_create_autocmd("CursorHold", {
	group = aug("DiagFloat"),
	callback = function()
		if not vim.b.__diag_open then
			vim.diagnostic.open_float(nil, { focus = false, scope = "cursor", border = "rounded" })
			vim.b.__diag_open = true
			vim.defer_fn(function()
				vim.b.__diag_open = false
			end, 250)
		end
	end,
})

-- Roda o linter ao salvar (se nvim-lint estiver presente).
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = aug("LintOnSave"),
	callback = function(args)
		local ok, lint = pcall(require, "lint")
		if ok then
			lint.try_lint()
		end
	end,
})

-- Formata ao salvar (se g:format_on_save = 1).
vim.g.format_on_save = vim.g.format_on_save ~= 1 and 0 or 0
vim.api.nvim_create_autocmd("BufWritePre", {
	group = aug("FormatOnSave"),
	callback = function(args)
		if vim.g.format_on_save == 1 then
			local ok, conform = pcall(require, "conform")
			if ok then
				conform.format({ bufnr = args.buf, lsp_fallback = true, timeout_ms = 1200 })
			end
		end
	end,
})

-- Fecha janelas auxiliares com `q`.
vim.api.nvim_create_autocmd("FileType", {
	group = aug("QuickClose"),
	pattern = {
		"help",
		"qf",
		"lspinfo",
		"man",
		"checkhealth",
		"startuptime",
		"oil",
		"neotest-output",
		"neotest-summary",
		"mason",
		"dap-float",
	},
	callback = function()
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = 0, silent = true })
	end,
})

-- Configurações para arquivos de documentação.
vim.api.nvim_create_autocmd("FileType", {
	group = aug("DocsUX"),
	pattern = { "markdown", "gitcommit", "gitrebase" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.conceallevel = 0
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us,pt_br"
		vim.opt_local.textwidth = 100
		vim.opt_local.colorcolumn = "+1"
	end,
})
-- Indentação de 2 espaços para alguns filetypes.
vim.api.nvim_create_autocmd("FileType", {
	group = aug("Indent2"),
	pattern = { "markdown", "yaml", "json", "jsonc", "toml", "lua", "html", "css" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
	end,
})

-- Configurações para o terminal.
vim.api.nvim_create_autocmd("TermOpen", {
	group = aug("TermUX"),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
		vim.cmd.startinsert()
		-- Mapeia Esc Esc para sair do modo terminal.
		if vim.fn.maparg("<Esc><Esc>", "t") == "" then
			vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { buffer = 0, silent = true })
		end
	end,
})

-- Desliga o modo paste ao sair do modo de inserção.
vim.api.nvim_create_autocmd("InsertLeave", {
	group = aug("NoPaste"),
	callback = function()
		vim.opt.paste = false
	end,
})

-- Abre a quickfix list automaticamente após :grep.
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = aug("QuickfixAutoOpen"),
	pattern = { "grep", "vimgrep", "helpgrep" },
	command = "cwindow",
})

-- Liga/desliga o highlight da busca.
vim.api.nvim_create_autocmd(
	"CmdlineEnter",
	{ group = aug("HLSearch"), pattern = { "/", "?" }, command = "set hlsearch" }
)
vim.api.nvim_create_autocmd(
	"CmdlineLeave",
	{ group = aug("HLSearch"), pattern = { "/", "?" }, command = "set nohlsearch" }
)

-- Salva/carrega a view (folds, cursor) ao sair/entrar em um buffer.
vim.api.nvim_create_autocmd("BufWinLeave", {
	group = aug("ViewSave"),
	callback = function()
		pcall(vim.cmd, "silent! mkview")
	end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = aug("ViewLoad"),
	callback = function()
		pcall(vim.cmd, "silent! loadview")
	end,
})

-- Ativa inlay hints automaticamente quando o LSP atacha.
vim.api.nvim_create_autocmd("LspAttach", {
	group = aug("InlayHints"),
	callback = function(args)
		if vim.lsp.inlay_hint and vim.lsp.get_clients({ bufnr = args.buf })[1] then
			pcall(vim.lsp.inlay_hint.enable, true, { bufnr = args.buf })
		end
	end,
})

-- =============== Runners ==================
-- Runners para diferentes linguagens, inspirados no JetBrains.
-- Build: <leader>B | Run: <leader>R | Test: <leader>T

-- Java (Gradle/Maven/JDTLS+DAP)
vim.api.nvim_create_autocmd("FileType", {
	group = aug("Java"),
	pattern = "java",
	callback = function()
		local root = root_dir(0)
		local use_gradle = has_file(root, { "gradlew", "build.gradle", "build.gradle.kts" })
		local use_maven = has_file(root, { "mvnw", "pom.xml" })
		local has_dap, dap = pcall(require, "dap")
		local has_jdtls, jdtls = pcall(require, "jdtls")

		map_buf("<leader>B", function()
			vim.cmd.write()
			if use_gradle then
				termrun({ "./gradlew build -x test || gradle build -x test" }, { cwd = root })
			elseif use_maven then
				termrun({ "./mvnw -q -DskipTests package || mvn -q -DskipTests package" }, { cwd = root })
			else
				vim.notify("Java: configure Gradle/Maven para build.", vim.log.levels.WARN)
			end
		end, "Build project")

		map_buf("<leader>T", function()
			if use_gradle then
				termrun({ "./gradlew test || gradle test" }, { cwd = root })
			elseif use_maven then
				termrun({ "./mvnw -q test || mvn -q test" }, { cwd = root })
			elseif has_jdtls then
				jdtls.test_class()
			else
				vim.notify("Java: sem runner de testes detectado.", vim.log.levels.WARN)
			end
		end, "Test project/class")

		map_buf("<leader>R", function()
			vim.cmd.write()
			if has_jdtls and has_dap then
				pcall(function()
					require("jdtls.dap").setup_dap_main_class_configs()
				end)
				dap.continue()
			elseif use_gradle then
				termrun({ "./gradlew run || gradle run" }, { cwd = root })
			elseif use_maven then
				termrun({ "./mvnw -q exec:java || mvn -q exec:java" }, { cwd = root })
			else
				vim.notify("Java: não foi possível detectar main.", vim.log.levels.WARN)
			end
		end, "Run main (DAP/Gradle/Maven)")
	end,
})

-- JS/TS
vim.api.nvim_create_autocmd("FileType", {
	group = aug("JS_TS"),
	pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" },
	callback = function()
		local root = root_dir(0)
		local pkg = root .. "/package.json"
		local use_deno = has_file(root, { "deno.json", "deno.jsonc" })
		local runner = has_file(root, { "bun.lockb" }) and "bun"
			or (has_file(root, { "pnpm-lock.yaml" }) and "pnpm")
			or (has_file(root, { "yarn.lock" }) and "yarn")
			or "npm"
		local function script_exists(name)
			if vim.loop.fs_stat(pkg) then
				local ok, json = pcall(vim.json.decode, table.concat(vim.fn.readfile(pkg), "\n"))
				return ok and json.scripts and json.scripts[name] ~= nil
			end
			return false
		end
		map_buf("<leader>B", function()
			vim.cmd.write()
			if use_deno then
				termrun({ "deno task build" }, { cwd = root })
			elseif script_exists("build") then
				termrun({ runner .. " run build" }, { cwd = root })
			else
				vim.notify("JS/TS: script build não encontrado.", vim.log.levels.INFO)
			end
		end, "Build")
		map_buf("<leader>T", function()
			if use_deno then
				termrun({ "deno test -A" }, { cwd = root })
			elseif script_exists("test") then
				termrun({ runner .. " test" }, { cwd = root })
			else
				termrun({ "node --test" }, { cwd = root })
			end
		end, "Test")
		map_buf("<leader>R", function()
			vim.cmd.write()
			if use_deno then
				termrun({ "deno task start" }, { cwd = root })
			elseif script_exists("dev") then
				termrun({ runner .. " run dev" }, { cwd = root })
			elseif script_exists("start") then
				termrun({ runner .. " start" }, { cwd = root })
			else
				termrun({ "node %" }, { cwd = root })
			end
		end, "Run")
	end,
})

-- Python
vim.api.nvim_create_autocmd("FileType", {
	group = aug("Python"),
	pattern = "python",
	callback = function()
		local root = root_dir(0)
		local use_uv = vim.fn.executable("uv") == 1
		local use_poetry = has_file(root, { "poetry.lock" })
		local use_venv = has_file(root, { ".venv" }) or os.getenv("VIRTUAL_ENV")
		local py = (use_uv and "uv run python")
			or (use_poetry and "poetry run python")
			or (use_venv and "python")
			or "python3"
		local pytest = (use_uv and "uv run pytest") or (use_poetry and "poetry run pytest") or "pytest"
		map_buf("<leader>B", function()
			vim.cmd.write()
			termrun({ "true # python: noop build" }, { cwd = root })
		end, "Build (noop)")
		map_buf("<leader>T", function()
			if vim.fn.executable("pytest") == 1 or use_uv or use_poetry then
				termrun({ pytest }, { cwd = root })
			else
				termrun({ py .. " -m unittest" }, { cwd = root })
			end
		end, "Test")
		map_buf("<leader>R", function()
			vim.cmd.write()
			termrun({ py .. " %" }, { cwd = root })
		end, "Run current file")
	end,
})

-- Go
vim.api.nvim_create_autocmd("FileType", {
	group = aug("Go"),
	pattern = "go",
	callback = function()
		local root = root_dir(0)
		map_buf("<leader>B", function()
			termrun({ "go build ./..." }, { cwd = root })
		end, "Build")
		map_buf("<leader>T", function()
			termrun({ "go test ./..." }, { cwd = root })
		end, "Test")
		map_buf("<leader>R", function()
			termrun({ "go run ." }, { cwd = root })
		end, "Run")
	end,
})

-- Rust
vim.api.nvim_create_autocmd("FileType", {
	group = aug("Rust"),
	pattern = "rust",
	callback = function()
		local root = root_dir(0)
		map_buf("<leader>B", function()
			termrun({ "cargo build" }, { cwd = root })
		end, "Build")
		map_buf("<leader>T", function()
			termrun({ "cargo test" }, { cwd = root })
		end, "Test")
		map_buf("<leader>R", function()
			termrun({ "cargo run" }, { cwd = root })
		end, "Run")
	end,
})

-- PHP
vim.api.nvim_create_autocmd("FileType", {
	group = aug("PHP"),
	pattern = "php",
	callback = function()
		local root = root_dir(0)
		map_buf("<leader>B", function()
			if has_file(root, { "composer.json" }) then
				termrun({ "composer install" }, { cwd = root })
			else
				vim.notify("PHP: composer.json não encontrado.", vim.log.levels.INFO)
			end
		end, "Build (composer install)")
		map_buf("<leader>T", function()
			if has_file(root, { "vendor/bin/phpunit", "phpunit.xml", "phpunit.xml.dist" }) then
				termrun({ "vendor/bin/phpunit || phpunit" }, { cwd = root })
			else
				vim.notify("PHP: PHPUnit não detectado.", vim.log.levels.INFO)
			end
		end, "Test")
		map_buf("<leader>R", function()
			termrun({ "php %" })
		end, "Run current file")
	end,
})

-- Ruby
vim.api.nvim_create_autocmd("FileType", {
	group = aug("Ruby"),
	pattern = "ruby",
	callback = function()
		local root = root_dir(0)
		map_buf("<leader>B", function()
			if has_file(root, { "Gemfile" }) then
				termrun({ "bundle install" }, { cwd = root })
			end
		end, "Build")
		map_buf("<leader>T", function()
			termrun({ "bundle exec rake test || rake test || rspec" }, { cwd = root })
		end, "Test")
		map_buf("<leader>R", function()
			termrun({ "ruby %" })
		end, "Run current file")
	end,
})

-- Shell & Lua
vim.api.nvim_create_autocmd("FileType", {
	group = aug("ShellLua"),
	pattern = { "sh", "bash", "zsh", "lua" },
	callback = function()
		map_buf("<leader>R", function()
			vim.cmd.write()
			termrun({ (vim.bo.filetype == "lua") and "lua %" or "bash %" })
		end, "Run")
	end,
})

-- C/C++
vim.api.nvim_create_autocmd("FileType", {
	group = aug("C_CPP"),
	pattern = { "c", "cpp" },
	callback = function()
		map_buf("<leader>B", function()
			vim.cmd.write()
			local base = vim.fn.expand("%:r")
			local cmd = (vim.bo.filetype == "c") and string.format("gcc %% -O2 -Wall -o %s", base)
				or string.format("g++ %% -O2 -std=c++20 -Wall -o %s", base)
			termrun({ "sh -c " .. vim.fn.shellescape(cmd) })
		end, "Build current file")
		map_buf("<leader>R", function()
			vim.cmd.write()
			local base = vim.fn.expand("%:r")
			local cmd = (vim.bo.filetype == "c") and string.format("gcc %% -O2 -Wall -o %s && ./%s", base, base)
				or string.format("g++ %% -O2 -std=c++20 -Wall -o %s && ./%s", base, base)
			termrun({ "sh -c " .. vim.fn.shellescape(cmd) })
		end, "Compile & run")
	end,
})

-- Fallback: se não houver runner para o filetype
vim.api.nvim_create_autocmd("FileType", {
	group = aug("GenericRun"),
	pattern = "*",
	callback = function()
		if vim.fn.maparg("<leader>R", "n") == "" then
			map_buf("<leader>R", function()
				vim.cmd.write()
				termrun({ "echo 'No runner for this filetype.'" })
			end, "No runner")
		end
	end,
})
