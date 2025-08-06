-- AUTOFORMAT ON SAVE:
-- Formata automaticamente ao salvar (pode ser desabilitado)
-- vim.g.disable_autoformat = true     -- Desabilitar globalmente
-- vim.b.disable_autoformat = true     -- Desabilitar no buffer atual

return {  {  "b0o/schemastore.nvim"},
{
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"b0o/schemastore.nvim",
		"mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	opts = {
		diagnostics = {
			underline = true,
			update_in_insert = false,
			virtual_text = {
				spacing = 4,
				source = "if_many",
				prefix = "●",
			},
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		},
		inlay_hints = {
			enabled = true,
		},
		codelens = {
			enabled = false,
		},
		capabilities = {},
		format = {
			formatting_options = nil,
			timeout_ms = nil,
		},
		servers = {
			-- WEB DEVELOPMENT STACK
			html = {
				filetypes = { "html", "templ" },
				init_options = {
					configurationSection = { "html", "css", "javascript" },
					embeddedLanguages = {
						css = true,
						javascript = true,
					},
					provideFormatter = true,
				},
			},
			cssls = {
				settings = {
					css = { validate = true },
					scss = { validate = true },
					less = { validate = true },
				},
			},
			tailwindcss = {
				root_dir = function(...)
					return require("lspconfig.util").root_pattern(".git")(...)
				end,
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
					"svelte",
				},
			},
			emmet_ls = {
				filetypes = {
					"html",
					"typescriptreact",
					"javascriptreact",
					"css",
					"sass",
					"scss",
					"less",
					"svelte",
					"vue",
				},
				init_options = {
					html = {
						options = {
							["bem.enabled"] = true,
						},
					},
				},
			},
			-- JAVASCRIPT/TYPESCRIPT ECOSYSTEM (Neovim nightly)
			ts_ls = {
				root_dir = function(...)
					return require("lspconfig.util").root_pattern("package.json")(...)
				end,
				single_file_support = false,
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "literal",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			},
			-- PYTHON DEVELOPMENT
			pyright = {
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							diagnosticMode = "workspace",
							inlayHints = {
								variableTypes = true,
								functionReturnTypes = true,
							},
						},
					},
				},
			},
			ruff_lsp = {
				init_options = {
					settings = {
						args = {},
					},
				},
			},
			-- GO DEVELOPMENT
			gopls = {
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
							shadow = true,
						},
						staticcheck = true,
						gofumpt = true,
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			},
			-- RUST DEVELOPMENT
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						assist = {
							importEnforceGranularity = true,
							importPrefix = "crate",
						},
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							runBuildScripts = true,
						},
						checkOnSave = {
							allFeatures = true,
							command = "clippy",
							extraArgs = { "--no-deps" },
						},
						inlayHints = {
							locationLinks = false,
						},
						procMacro = {
							enable = true,
							ignored = {
								["async-trait"] = { "async_trait" },
								["napi-derive"] = { "napi" },
								["async-recursion"] = { "async_recursion" },
							},
						},
					},
				},
			},
			-- C/C++ DEVELOPMENT
			clangd = {
				keys = {
					{ "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = " Switch Source/Header (C/C++)" },
				},
				root_dir = function(...)
					return require("lspconfig.util").root_pattern(
						".clangd",
						".clang-tidy",
						".clang-format",
						"compile_commands.json",
						"compile_flags.txt",
						"configure.ac",
						".git"
					)(...)
				end,
				capabilities = {
					offsetEncoding = { "utf-16" },
				},
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
			},
			-- JAVA DEVELOPMENT (JDTLS)
			jdtls = {},
			-- C# GAME DEVELOPMENT
			omnisharp = {
				cmd = { "omnisharp" },
				settings = {
					FormattingOptions = {
						EnableEditorConfigSupport = true,
						OrganizeImports = true,
					},
					MsBuild = {
						LoadProjectsOnDemand = nil,
					},
					RoslynExtensionsOptions = {
						EnableAnalyzersSupport = nil,
						EnableImportCompletion = nil,
						AnalyzeOpenDocumentsOnly = nil,
					},
					Sdk = {
						IncludePrereleases = true,
					},
				},
			},
			-- LUA DEVELOPMENT
			lua_ls = {
				settings = {
					Lua = {
						workspace = {
							checkThirdParty = false,
						},
						completion = {
							callSnippet = "Replace",
						},
						hint = {
							enable = true,
							arrayIndex = "Disable",
							await = true,
							paramName = "Disable",
							paramType = true,
							semicolon = "Disable",
							setType = false,
						},
						doc = {
							privateName = { "^_" },
						},
						type = {
							castNumberToInteger = true,
						},
						diagnostics = {
							disable = { "incomplete-signature-doc", "trailing-space" },
							groupSeverity = {
								strong = "Warning",
								strict = "Warning",
							},
							groupFileStatus = {
								["ambiguity"] = "Opened",
								["await"] = "Opened",
								["codestyle"] = "None",
								["duplicate"] = "Opened",
								["global"] = "Opened",
								["luadoc"] = "Opened",
								["redefined"] = "Opened",
								["strict"] = "Opened",
								["strong"] = "Opened",
								["type-check"] = "Opened",
								["unbalanced"] = "Opened",
								["unused"] = "Opened",
							},
							unusedLocalExclude = { "_*" },
						},
						format = {
							enable = false,
						},
					},
				},
			},
			-- DATA FORMATS
			jsonls = {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			},
			yamlls = {
				settings = {
					yaml = {
						schemaStore = {
							enable = false,
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			},
			-- SHELL SCRIPTING
			bashls = {
				filetypes = { "sh", "bash" },
			},
			-- DOCUMENTATION
			marksman = {},
			-- DEVOPS
			dockerls = {},
			docker_compose_language_service = {},
		},
		setup = {},
	},
	config = function(_, opts)
		local function on_attach(client, buffer)
			local keymaps = {
				{ "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
				{ "gr", vim.lsp.buf.references, desc = "References" },
				{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
				{ "gI", vim.lsp.buf.implementation, desc = "Goto Implementation", has = "implementation" },
				{ "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
				{ "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
				{ "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
				{
					"<leader>ca",
					vim.lsp.buf.code_action,
					desc = " Code Action",
					mode = { "n", "v" },
					has = "codeAction",
				},
				{ "<leader>cr", vim.lsp.buf.rename, desc = " Rename", has = "rename" },
				{
					"<leader>cf",
					function()
						vim.lsp.buf.format({ async = true })
					end,
					desc = " Format Document",
					has = "documentFormatting",
				},
				{
					"<leader>cf",
					function()
						vim.lsp.buf.format({ async = true })
					end,
					desc = " Format Range",
					mode = "v",
					has = "documentRangeFormatting",
				},
			}
			for _, keymap in ipairs(keymaps) do
				local opts = { buffer = buffer, silent = true }
				opts.desc = keymap.desc
				opts.has = keymap.has
				local mode = keymap.mode or "n"
				if opts.has == nil or client.server_capabilities[opts.has .. "Provider"] then
					vim.keymap.set(mode, keymap[1], keymap[2], opts)
				end
			end
		end

		local servers = opts.servers
		local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			has_cmp and cmp_nvim_lsp.default_capabilities() or {},
			opts.capabilities or {}
		)

		local function setup(server)
			local server_opts = vim.tbl_deep_extend("force", {
				capabilities = vim.deepcopy(capabilities),
			}, servers[server] or {})
			if opts.setup[server] then
				if opts.setup[server](server, server_opts) then
					return
				end
			elseif opts.setup["*"] then
				if opts.setup["*"](server, server_opts) then
					return
				end
			end
			server_opts.on_attach = on_attach
			require("lspconfig")[server].setup(server_opts)
		end

		local have_mason, mlsp = pcall(require, "mason-lspconfig")
		local ensure_installed = {}
		if have_mason then
			ensure_installed = {
				"ts_ls",
				"lua_ls",
				"pyright",
				-- "ruff_lsp",
				"gopls",
				"rust_analyzer",
				"clangd",
				"jdtls",
				"omnisharp",
				"bashls",
				"jsonls",
				"yamlls",
				"html",
				"cssls",
				"tailwindcss",
				"emmet_ls",
				"marksman",
				"dockerls",
			}
			mlsp.setup({
				ensure_installed = ensure_installed,
				handlers = { setup },
			})
		end

		vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
		if opts.inlay_hints.enabled then
			vim.lsp.handlers["textDocument/inlayHint"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})
		end
	end,
}}
