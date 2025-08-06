-- ═════════════════════════════════════════════════════════════════════════
--  AUTO PAIRS - BRACKET INTELLIGENCE
-- ═════════════════════════════════════════════════════════════════════════
return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		check_ts = true,
		ts_config = {
			lua = { "string", "source" },
			javascript = { "string", "template_string" },
			java = false,
		},
		disable_filetype = { "TelescopePrompt", "spectre_panel" },
		fast_wrap = {
			map = "<M-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
			offset = 0,
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "PmenuSel",
			highlight_grey = "LineNr",
		},
	},
	config = function(_, opts)
		local npairs = require("nvim-autopairs")
		npairs.setup(opts)

		-- Integration with nvim-cmp
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		-- Custom rules
		local Rule = require("nvim-autopairs.rule")

		-- Add spaces inside curly braces for JavaScript/TypeScript
		npairs.add_rules({
			Rule(" ", " "):with_pair(function(opts)
				local pair = opts.line:sub(opts.col - 1, opts.col)
				return vim.tbl_contains({ "()", "[]", "{}" }, pair)
			end),
			Rule("( ", " )")
				:with_pair(function()
					return false
				end)
				:with_move(function(opts)
					return opts.prev_char:match(".%)") ~= nil
				end)
				:use_key(")"),
			Rule("{ ", " }")
				:with_pair(function()
					return false
				end)
				:with_move(function(opts)
					return opts.prev_char:match(".%}") ~= nil
				end)
				:use_key("}"),
			Rule("[ ", " ]")
				:with_pair(function()
					return false
				end)
				:with_move(function(opts)
					return opts.prev_char:match(".%]") ~= nil
				end)
				:use_key("]"),
		})
	end,
}
