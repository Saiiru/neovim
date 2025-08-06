-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                KORA NEURAL MOVEMENT TRAINING MATRIX                     ║
-- ║                   SUPERIOR TO HARDTIME APPROACH                         ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
	-- ═══════════════════════════════════════════════════════════════════════════
	-- 🚀 LEAP.NVIM - QUANTUM MOVEMENT ENGINE
	-- ═══════════════════════════════════════════════════════════════════════════
	{
		"ggandor/leap.nvim",
		event = "VeryLazy",
		dependencies = { "tpope/vim-repeat" },
		config = function()
			local leap = require("leap")

			leap.setup({
				max_phase_one_targets = nil,
				highlight_unlabeled_phase_one_targets = false,
				max_highlighted_traversal_targets = 10,
				case_sensitive = false,
				equivalence_classes = { " \t\r\n" },
				substitute_chars = {},
				safe_labels = { "f", "n", "u", "t", "/", "F", "N", "L", "H", "M", "U", "G", "T", "?", "Z" },
				labels = {
					"f",
					"n",
					"j",
					"k",
					"l",
					"o",
					"d",
					"w",
					"e",
					"m",
					"b",
					"u",
					"y",
					"v",
					"r",
					"g",
					"t",
					"c",
					"x",
					"/",
					"F",
					"N",
					"J",
					"K",
					"L",
					"O",
					"D",
					"W",
					"E",
					"M",
					"B",
					"U",
					"Y",
					"V",
					"R",
					"G",
					"T",
					"C",
					"X",
					"?",
				},
				special_keys = {
					repeat_search = "<enter>",
					next_phase_one_target = "<enter>",
					next_target = { "<enter>", ";" },
					prev_target = { "<tab>", "," },
					next_group = "<space>",
					prev_group = "<tab>",
					multi_accept = "<enter>",
					multi_revert = "<backspace>",
				},
			})

			-- ═══════════════════════════════════════════════════════════════════════════
			-- 🎯 LEAP KEYBINDINGS - NEURAL INTERFACE
			-- ═══════════════════════════════════════════════════════════════════════════
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "🚀 Leap forward" })
			vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "🚀 Leap backward" })
			vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)", { desc = "🚀 Leap from window" })

			-- ═══════════════════════════════════════════════════════════════════════════
			-- 🎨 LEAP COLORS - CYBERDREAM THEME INTEGRATION
			-- ═══════════════════════════════════════════════════════════════════════════
			vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "#6C7086" })
			vim.api.nvim_set_hl(0, "LeapMatch", { fg = "#FF79C6", bold = true, nocombine = true })
			vim.api.nvim_set_hl(
				0,
				"LeapLabelPrimary",
				{ fg = "#16213E", bg = "#50FA7B", bold = true, nocombine = true }
			)
			vim.api.nvim_set_hl(
				0,
				"LeapLabelSecondary",
				{ fg = "#16213E", bg = "#8BE9FD", bold = true, nocombine = true }
			)

			vim.notify("🚀 Leap Neural Interface Online", vim.log.levels.INFO, {
				title = "KORA Movement Matrix",
				timeout = 2000,
			})
		end,
	},

	-- ═══════════════════════════════════════════════════════════════════════════
	-- ⚡ FLASH.NVIM - ENHANCED F/T MOVEMENT
	-- ═══════════════════════════════════════════════════════════════════════════
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			search = {
				multi_window = true,
				forward = true,
				wrap = true,
				mode = "exact",
				incremental = false,
			},
			jump = {
				jumplist = true,
				pos = "start",
				history = false,
				register = false,
				nohlsearch = false,
				autojump = false,
			},
			label = {
				uppercase = true,
				exclude = "",
				current = true,
				after = true,
				before = false,
				style = "overlay",
				reuse = "lowercase",
				distance = true,
				min_pattern_length = 0,
				rainbow = {
					enabled = true,
					shade = 5,
				},
			},
			highlight = {
				backdrop = true,
				matches = true,
				priority = 5000,
				groups = {
					match = "FlashMatch",
					current = "FlashCurrent",
					backdrop = "FlashBackdrop",
					label = "FlashLabel",
				},
			},
			modes = {
				search = {
					enabled = true,
					highlight = { backdrop = false },
					jump = { history = true, register = true, nohlsearch = true },
				},
				char = {
					enabled = true,
					config = function(opts)
						opts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"
						opts.jump_labels = vim.fn.mode(true):find("no") and vim.v.operator ~= "y"
					end,
					autohide = false,
					jump_labels = false,
					multi_line = true,
					label = { exclude = "hjkliardc" },
					keys = { "f", "F", "t", "T", ";", "," },
					char_actions = function(motion)
						return {
							[";"] = "next",
							[","] = "prev",
							[motion:lower()] = "next",
							[motion:upper()] = "prev",
						}
					end,
					search = { wrap = false },
					highlight = { backdrop = true },
					jump = { register = false },
				},
				treesitter = {
					labels = "abcdefghijklmnopqrstuvwxyz",
					jump = { pos = "range" },
					search = { incremental = false },
					label = { before = true, after = true, style = "inline" },
					highlight = {
						backdrop = false,
						matches = false,
					},
				},
				remote = {
					remote_op = { restore = true, motion = true },
				},
			},
		},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "⚡ Flash Jump",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "⚡ Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "⚡ Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "⚡ Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "⚡ Toggle Flash Search",
			},
		},

		config = function(_, opts)
			require("flash").setup(opts)

			-- ═══════════════════════════════════════════════════════════════════════════
			-- 🎨 FLASH COLORS - CYBERDREAM INTEGRATION
			-- ═══════════════════════════════════════════════════════════════════════════
			vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#6C7086" })
			vim.api.nvim_set_hl(0, "FlashMatch", { fg = "#FF79C6", bg = "#313244", bold = true })
			vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "#F8F8F2", bg = "#7B68EE", bold = true })
			vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#16213E", bg = "#50FA7B", bold = true, underline = true })

			vim.notify("⚡ Flash Neural Enhancement Active", vim.log.levels.INFO, {
				title = "KORA Movement Matrix",
				timeout = 2000,
			})
		end,
	},

	-- ═══════════════════════════════════════════════════════════════════════════
	-- 🧭 MINI.JUMP2D - ALTERNATIVE RAPID MOVEMENT
	-- ═══════════════════════════════════════════════════════════════════════════
	{
		"echasnovski/mini.jump2d",
		event = "VeryLazy",
		opts = {
			view = {
				dim = true,
				n_steps_ahead = 0,
			},
			labels = "abcdefghijklmnopqrstuvwxyz",
			allowed_lines = {
				blank = true,
				cursor_before = true,
				cursor_at = true,
				cursor_after = true,
				fold = true,
			},
			allowed_windows = {
				current = true,
				not_current = true,
			},
			hooks = {
				before_start = function()
					vim.cmd("hi MiniJump2dSpot guifg=#FF79C6 guibg=#313244 gui=bold,underline")
					vim.cmd("hi MiniJump2dSpotAhead guifg=#8BE9FD guibg=#1A1A2E gui=bold")
					vim.cmd("hi MiniJump2dSpotUnique guifg=#50FA7B guibg=#16213E gui=bold,reverse")
				end,
			},
			mappings = {
				start_jumping = "<CR>",
			},
			silent = false,
		},
		keys = {
			{
				"<CR>",
				function()
					require("mini.jump2d").start(require("mini.jump2d").builtin_opts.single_character)
				end,
				desc = "🧭 Jump2D",
				mode = { "n", "x", "o" },
			},
		},
	},

	-- ═══════════════════════════════════════════════════════════════════════════
	-- 📊 MOVEMENT STATISTICS & TRAINING
	-- ═══════════════════════════════════════════════════════════════════════════
	{
		"m4xshen/hardtime.nvim",
		enabled = false, -- Keeping disabled but available for future fixes
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
}

-- # 🚀 KORA NEURAL MOVEMENT TRAINING - SUPERIOR ALTERNATIVES

-- ## 🎯 Why These Are Better Than Hardtime

-- ### ❌ Hardtime Problems:
-- - **Restrictive**: Blocks movement, interrupts flow
-- - **Negative**: Punishment-based training
-- - **Buggy**: Current version has nil value crashes
-- - **Limited**: Only teaches what NOT to do

-- ### ✅ Our Solution Benefits:
-- - **Enabling**: Shows you faster ways to move
-- - **Positive**: Reward-based learning
-- - **Stable**: Well-maintained, reliable plugins
-- - **Comprehensive**: Teaches efficient patterns

-- ## 🚀 Leap.nvim - Quantum Jumps

-- ### Keybindings
-- | Key | Mode | Action | Description |
-- |-----|------|--------|-------------|
-- | `s` | n,x,o | Leap forward | Jump to any visible location |
-- | `S` | n,x,o | Leap backward | Jump backward to any location |
-- | `gs` | n,x,o | Leap from window | Jump across windows |

-- ### Usage Pattern
-- 1. Press `s` (leap forward)
-- 2. Type 2 characters of your target location
-- 3. Leap shows labels - press the label to jump
-- 4. Result: Reach any location in 3-4 keystrokes max

-- ### Examples
-- - Instead of `10j` → `s` + `fu` + `a` (if 'function' has label 'a')
-- - Instead of `20l` → `s` + `en` + `b` (if 'end' has label 'b')
-- - Instead of `Ctrl-f` + navigation → `s` + target chars + label

-- ## ⚡ Flash.nvim - Enhanced F/T

-- ### Keybindings
-- | Key | Mode | Action | Description |
-- |-----|------|--------|-------------|
-- | `s` | n,x,o | Flash jump | Enhanced f/t movement |
-- | `S` | n,x,o | Flash treesitter | Jump by syntax nodes |
-- | `r` | o | Remote flash | Remote operations |
-- | `R` | o,x | Treesitter search | Search syntax patterns |
-- | `<C-s>` | c | Toggle search | Toggle flash in search |

-- ### Enhanced F/T
-- - `f`, `F`, `t`, `T` now show labels for multiple matches
-- - `;` and `,` work as expected for repetition
-- - Multi-line support for finding characters
-- - Visual feedback with highlights

-- ## 🧭 Mini.Jump2D - Alternative Engine

-- ### Keybindings
-- | Key | Mode | Action | Description |
-- |-----|------|--------|-------------|
-- | `<CR>` | n,x,o | Jump2D | Single character jump with labels |

-- ### Usage
-- 1. Press `<CR>`
-- 2. Type one character
-- 3. See all instances labeled
-- 4. Press label to jump

-- ## 🎮 Training Philosophy

-- ### Old Way (Hardtime):
-- ❌ "Don't use h/j/k/l too much" (restrictive)

-- ### New Way (KORA Neural):
-- ✅ "Here's a faster way to get there" (enabling)

-- ## 📊 Movement Efficiency Comparison

-- | Traditional | KORA Neural | Keystrokes Saved |
-- |-------------|-------------|------------------|
-- | `10j` to go down | `s` + chars + label | ~7 keystrokes |
-- | `15l` to go right | `s` + target + label | ~12 keystrokes |
-- | `f;;;;;` repeat find | `s` + chars + label | ~2-3 keystrokes |
-- | Navigate across files | `gs` + chars + label | Massive time saved |

-- ## 🧠 Learning Path

-- ### Week 1: Basic Leap
-- - Use `s` instead of h/j/k/l spam
-- - Practice 2-character targeting
-- - Learn to read labels quickly

-- ### Week 2: Advanced Patterns
-- - Use `S` for backward jumps
-- - Try `gs` for cross-window movement
-- - Combine with other motions

-- ### Week 3: Flash Integration
-- - Enhanced f/t with Flash
-- - Treesitter-aware jumping with `S`
-- - Remote operations with `r`

-- ### Week 4: Mastery
-- - Unconscious competence with leap
-- - Efficient code navigation
-- - Custom patterns for your workflow

-- ## 🎨 Visual Integration
-- - Colors match Cyberdream theme
-- - Labels use KORA purple/green palette
-- - Backdrop dims for focus
-- - Smooth highlighting transitions

-- ## 🔧 Customization

-- ### Add Custom Leap Targets
-- ```lua
-- leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
