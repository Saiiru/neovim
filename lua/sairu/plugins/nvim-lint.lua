local M = {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "biome", "eslint_d" },
			typescript = { "biome", "eslint_d" },
			javascriptreact = { "biome", "eslint_d" },
			typescriptreact = { "biome", "eslint_d" },
			angular = { "biome", "eslint_d" },
			svelte = { "eslint_d" },
			python = { "pylint" },
			java = { "checkstyle" },
			c = { "cppcheck" },
			cpp = { "cppcheck" },
			cs = { "dotnet-format" },
			go = { "golangci-lint" },
			php = { "phpcs" },
			lua = { "luacheck" },
		}

		lint.linters = {
			biome = {
				name = "biome",
				cmd = "biome",
				args = { "check", "--stdin" },
				stdin = true,
				parser = some_parser_function, -- Replace with the actual parser function
			},
			eslint_d = {
				name = "eslint_d",
				cmd = "eslint_d",
				args = { "--stdin", "--stdin-filename", "%filepath" },
				stdin = true,
				parser = some_parser_function, -- Replace with the actual parser function
			},
			pylint = {
				name = "pylint",
				cmd = "pylint",
				args = { "--from-stdin", "%filepath" },
				stdin = true,
				parser = some_parser_function, -- Replace with the actual parser function
			},
			checkstyle = {
				name = "checkstyle",
				cmd = "checkstyle",
				args = { "-f", "xml", "-c", "/google_checks.xml", "-" },
				stdin = true,
				parser = some_parser_function, -- Replace with the actual parser function
			},
			cppcheck = {
				name = "cppcheck",
				cmd = "cppcheck",
				args = { "--enable=all", "--inline-suppr", "%filepath" },
				stdin = false,
				parser = some_parser_function, -- Replace with the actual parser function
			},
			["dotnet-format"] = {
				name = "dotnet-format",
				cmd = "dotnet",
				args = { "format" },
				stdin = false,
				parser = some_parser_function, -- Replace with the actual parser function
			},
			golangci_lint = {
				name = "golangci_lint",
				cmd = "golangci-lint",
				args = { "run", "--out-format", "json" },
				stdin = false,
				parser = some_parser_function, -- Replace with the actual parser function
			},
			phpcs = {
				name = "phpcs",
				cmd = "phpcs",
				args = { "--standard=PSR2", "--report=full", "%filepath" },
				stdin = false,
				parser = some_parser_function, -- Replace with the actual parser function
			},
			luacheck = {
				name = "luacheck",
				cmd = "luacheck",
				args = { "--formatter", "plain", "--codes", "--ranges", "--filename", "%filepath", "-" },
				stdin = true,
				parser = some_parser_function, -- Replace with the actual parser function
			},
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}

return M
