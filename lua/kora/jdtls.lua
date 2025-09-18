local M = {}

local function mason_path()
	return vim.fn.stdpath("data") .. "/mason/packages"
end

local function os_cfg()
	if jit.os == "OSX" then
		return "config_mac"
	end
	if jit.os == "Windows" then
		return "config_win"
	end
	return "config_linux"
end

local function list(glob)
	local t = {}
	for _, p in ipairs(vim.split(vim.fn.glob(glob), "\n", { trimempty = true })) do
		if p ~= "" then
			table.insert(t, p)
		end
	end
	return t
end

function M.start(opts)
	opts = opts or {}

	local mason = mason_path()
	local jdtls_dir = mason .. "/jdtls"
	local dbg_dir = mason .. "/java-debug-adapter"
	local test_dir = mason .. "/java-test"

	local root = require("jdtls.setup").find_root({ "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" })
		or vim.loop.cwd()
	local project = vim.fs.basename(root)
	local workspace = opts.workspace_dir or (vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project)
	vim.fn.mkdir(workspace, "p")

	local bundles = {}
	vim.list_extend(bundles, list(dbg_dir .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"))
	vim.list_extend(bundles, list(test_dir .. "/extension/server/*.jar"))

	local lombok = opts.lombok or (jdtls_dir .. "/lombok.jar")
	if vim.fn.filereadable(lombok) ~= 1 then
		lombok = nil
	end

	local cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=INFO",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		lombok and ("-javaagent:" .. lombok) or nil,
		"-jar",
		vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		jdtls_dir .. "/" .. os_cfg(),
		"-data",
		workspace,
	}
	-- remove nils
	local clean = {}
	for _, v in ipairs(cmd) do
		if v then
			table.insert(clean, v)
		end
	end

	local capabilities = (pcall(require, "blink.cmp") and require("blink.cmp").get_lsp_capabilities())
		or require("cmp_nvim_lsp").default_capabilities()

	local jdtls = require("jdtls")

	local function map(buf, lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
	end

	local function on_attach(client, bufnr)
		-- LSP básico
		map(bufnr, "gd", vim.lsp.buf.definition, "Goto Def")
		map(bufnr, "gr", vim.lsp.buf.references, "References")
		map(bufnr, "gi", vim.lsp.buf.implementation, "Implementations")
		map(bufnr, "gy", vim.lsp.buf.type_definition, "Type Def")
		map(bufnr, "K", vim.lsp.buf.hover, "Hover")
		map(bufnr, "<leader>lr", vim.lsp.buf.rename, "Rename")
		map(bufnr, "<leader>la", vim.lsp.buf.code_action, "Code Action")
		map(bufnr, "<leader>lf", function()
			vim.lsp.buf.format({ async = true })
		end, "Format")

		-- Ações Java
		map(bufnr, "<leader>jo", jdtls.organize_imports, "Java Organize Imports")
		map(bufnr, "<leader>jm", jdtls.extract_method, "Java Extract Method")
		map(bufnr, "<leader>jv", jdtls.extract_variable, "Java Extract Variable")
		map(bufnr, "<leader>jc", jdtls.extract_constant, "Java Extract Constant")
		map(bufnr, "<leader>jt", jdtls.test_nearest_method, "Java Test Method")
		map(bufnr, "<leader>jT", jdtls.test_class, "Java Test Class")

		-- DAP (hot code replace)
		jdtls.setup_dap({ hotcodereplace = "auto" })
	end

	local settings = vim.tbl_deep_extend("force", {
		java = {
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			references = { includeDecompiledSources = true },
			signatureHelp = { enabled = true },
			implementationsCodeLens = { enabled = true },
			inlayHints = { parameterNames = { enabled = "all" } },
			format = { enabled = false }, -- use sua chain formatters
		},
	}, opts.settings or {})

	require("jdtls").start_or_attach({
		cmd = clean,
		root_dir = root,
		capabilities = capabilities,
		init_options = { bundles = bundles },
		settings = settings,
		on_attach = on_attach,
	})

	-- Which-Key (opcional)
	local ok, wk = pcall(require, "which-key")
	if ok and wk.add then
		wk.add({
			{ "<leader>j", group = "Java" },
			{ "<leader>jo", desc = "Organize Imports" },
			{ "<leader>jm", desc = "Extract Method" },
			{ "<leader>jv", desc = "Extract Variable" },
			{ "<leader>jc", desc = "Extract Constant" },
			{ "<leader>jt", desc = "Test Method" },
			{ "<leader>jT", desc = "Test Class" },
		})
	end
end

return M
