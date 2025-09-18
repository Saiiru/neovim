-- ~/.config/nvim/lua/kora/plugins/dap.lua
return {
	-- Core DAP
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug Continue",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug Step Into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug Step Out",
			},
			{
				"<F2>",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<S-F2>",
				function()
					require("dap").set_breakpoint(vim.fn.input("cond: "))
				end,
				desc = "Breakpoint cond",
			},

			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>dn",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("cond: "))
				end,
				desc = "Breakpoint cond",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "REPL",
			},
			{
				"<leader>dx",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "UI Toggle",
			},
			{
				"<leader>dC",
				function()
					pcall(require("telescope").extensions.dap.configurations)
				end,
				desc = "Configs",
			},
			{
				"<leader>dL",
				function()
					pcall(require("telescope").extensions.dap.list_breakpoints)
				end,
				desc = "Breakpoints",
			},
			{
				"<leader>dF",
				function()
					pcall(require("telescope").extensions.dap.frames)
				end,
				desc = "Frames",
			},
			{
				"<leader>dV",
				function()
					pcall(require("telescope").extensions.dap.variables)
				end,
				desc = "Variables",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				mode = { "n", "v" },
				desc = "Eval",
			},
		},
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"jay-babu/mason-nvim-dap.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-telescope/telescope-dap.nvim",
			"nvim-neotest/nvim-nio",
		},
		init = function() end,
		config = function()
			local dap = require("dap")

			-- External terminal (Kitty) e terminal integrado
			dap.defaults.fallback.external_terminal = {
				command = "/usr/bin/kitty",
				args = { "--hold" },
			}
			-- opcional: forçar terminal externo
			-- dap.defaults.fallback.force_external_terminal = true
			dap.defaults.fallback.terminal_win_cmd = "botright 15split new"

			-- Signs
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
			vim.fn.sign_define("DapStopped", { text = "➤", texthl = "DiagnosticInfo" })

			-- UI
			local dapui = require("dapui")
			dapui.setup({
				controls = { enabled = false },
				layouts = {
					{ elements = { "scopes", "stacks", "breakpoints" }, size = 40, position = "left" },
					{ elements = { "repl", "console" }, size = 10, position = "bottom" },
				},
				floating = { border = "rounded" },
			})
			require("nvim-dap-virtual-text").setup({ commented = true })

			dap.listeners.before.attach.dapui_auto = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_auto = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_auto = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_auto = function()
				dapui.close()
			end

			-- Telescope bridge
			pcall(require("telescope").load_extension, "dap")
		end,
	},

	-- Mason DAP adapters + presets
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
		opts = {
			ensure_installed = {
				"js", -- vscode-js (pwa-node/chrome)
				"python", -- debugpy
				"delve", -- Go
				"codelldb", -- C/C++/Rust
				"php", -- Xdebug helper
			},
			automatic_installation = true,
			handlers = {
				function(cfg)
					require("mason-nvim-dap").default_setup(cfg)
				end,

				js = function(cfg)
					require("mason-nvim-dap").default_setup(cfg)
					local dap = require("dap")
					dap.configurations.typescript = {
						{
							type = "pwa-node",
							request = "launch",
							name = "TS: file",
							program = "${file}",
							cwd = "${workspaceFolder}",
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "TS: attach 9229",
							port = 9229,
							cwd = "${workspaceFolder}",
							processId = require("dap.utils").pick_process,
						},
					}
					dap.configurations.typescriptreact = dap.configurations.typescript
					dap.configurations.javascript = dap.configurations.typescript
					dap.configurations.javascriptreact = dap.configurations.typescript
				end,

				python = function(cfg)
					require("mason-nvim-dap").default_setup(cfg)
					require("dap").configurations.python = {
						{
							type = "python",
							request = "launch",
							name = "Py: file",
							program = "${file}",
							console = "integratedTerminal",
						},
					}
				end,

				delve = function(cfg)
					require("mason-nvim-dap").default_setup(cfg)
					local pick = require("dap.utils").pick_process
					require("dap").configurations.go = {
						{ type = "delve", request = "launch", name = "Go: file", program = "${file}" },
						{ type = "delve", request = "attach", name = "Go: attach", processId = pick },
					}
				end,

				codelldb = function(cfg)
					require("mason-nvim-dap").default_setup(cfg)
					local function bin(default_path)
						return function()
							return vim.fn.input("bin: ", default_path, "file")
						end
					end
					local dap = require("dap")
					dap.configurations.c = {
						{
							name = "C: launch",
							type = "codelldb",
							request = "launch",
							program = bin(vim.fn.getcwd() .. "/build/a.out"),
							cwd = "${workspaceFolder}",
							stopOnEntry = false,
						},
					}
					dap.configurations.cpp = dap.configurations.c
					dap.configurations.rust = {
						{
							name = "Rust: launch",
							type = "codelldb",
							request = "launch",
							program = bin(vim.fn.getcwd() .. "/target/debug/${workspaceFolderBasename}"),
							cwd = "${workspaceFolder}",
							stopOnEntry = false,
						},
					}
				end,

				php = function(cfg)
					require("mason-nvim-dap").default_setup(cfg)
					require("dap").configurations.php = {
						{
							type = "php",
							request = "launch",
							name = "PHP: Xdebug",
							port = 9003,
							pathMappings = { ["/var/www/html"] = "${workspaceFolder}" },
						},
					}
				end,
			},
		},
	},

	-- Neotest hook (opcional)
	{
		"nvim-neotest/neotest",
		optional = true,
		keys = {
			{
				"<leader>tL",
				function()
					require("neotest").run.run_last({ strategy = "dap" })
				end,
				desc = "Debug Last Test",
			},
		},
	},
}
