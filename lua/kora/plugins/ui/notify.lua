-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                    KORA NOTIFICATION SYSTEM MATRIX                      ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	keys = {
		{
			"<leader>un",
			function()
				require("notify").dismiss({ silent = true, pending = true })
			end,
			desc = "Dismiss All Notifications",
		},
		{
			"<leader>ut",
			function()
				require("notify")("󰓩 Test notification\nSystem online, Operator.", "info", {
					title = "KORA Neural PDE",
					timeout = 3000,
				})
			end,
			desc = "Test Notification",
		},
	},
	opts = {
		-- Notification lifetime
		timeout = 3500,
		-- Animation style
		stages = "fade_in_slide_out", -- "fade", "slide", "static", "fade_in_slide_out"
		-- Max number of visible notifications
		max_pending = 8,
		-- Render style
		render = "default", -- "minimal", "default", "compact", "simple"
		-- FPS for animations
		fps = 60,
		-- Background color for floating windows
		background_colour = "#1E1E2E",
		-- Level (minimum) to show
		level = vim.log.levels.INFO,
		-- Icons (Nerd Font, Cyberpunk style)
		icons = {
			ERROR = "",
			WARN = "",
			INFO = "󰋽",
			DEBUG = "",
			TRACE = "✎",
		},
		-- On open: always float above everything
		on_open = function(win)
			vim.api.nvim_win_set_config(win, { zindex = 150 })
			vim.wo[win].winblend = 10
		end,
		-- On close: optional custom logic
		on_close = nil,
	},
	init = function()
		-- Store original vim.notify before notify plugin loads
		local original_notify = vim.notify

		-- Advanced spam filter
		local spam_patterns = {
			"No information available",
			"^%s*$", -- Empty or whitespace only
			"^$", -- Completely empty
			"Starting",
			"Started",
			"ready",
			"initialized",
			"loading",
			"loaded",
			"enabled",
			"disabled",
			"attached",
			"detached",
			"client",
			"server",
		}

		-- Message cache for deduplication
		local message_cache = {}
		local cache_timeout = 3000 -- 3 seconds

		-- Enhanced notify wrapper
		vim.notify = function(msg, level, opts)
			-- Handle nil or empty messages
			if not msg then
				return
			end

			-- Convert to string and trim
			msg = tostring(msg):gsub("^%s+", ""):gsub("%s+$", "")

			-- Filter empty messages
			if msg == "" or msg == "No information available" then
				return
			end

			-- Check spam patterns
			for _, pattern in ipairs(spam_patterns) do
				if msg:lower():match(pattern:lower()) then
					-- Only allow ERROR level for spam patterns
					if level ~= vim.log.levels.ERROR then
						return
					end
				end
			end

			-- Deduplicate messages
			local current_time = vim.loop.hrtime() / 1000000
			local msg_key = msg:sub(1, 50) -- First 50 chars as key

			if message_cache[msg_key] then
				local time_diff = current_time - message_cache[msg_key]
				if time_diff < cache_timeout then
					return -- Skip duplicate
				end
			end

			message_cache[msg_key] = current_time

			-- Clean old cache entries occasionally
			if math.random(1, 100) == 1 then -- 1% chance
				for key, timestamp in pairs(message_cache) do
					if current_time - timestamp > cache_timeout * 2 then
						message_cache[key] = nil
					end
				end
			end

			-- Call original notify for clean messages
			return original_notify(msg, level, opts)
		end
	end,
	config = function(_, opts)
		local notify = require("notify")
		notify.setup(opts)

		-- Custom highlights for a cyberpunk/Sci-Fi feel
		vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#1E1E2E" })
		vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#FF5555", bg = "#1E1E2E" })
		vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#F1FA8C", bg = "#1E1E2E" })
		vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#8BE9FD", bg = "#1E1E2E" })
		vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = "#7B68EE", bg = "#1E1E2E" })
		vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = "#BD93F9", bg = "#1E1E2E" })
		vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = "#FF5555", bg = "#1E1E2E" })
		vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = "#F1FA8C", bg = "#1E1E2E" })
		vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = "#8BE9FD", bg = "#1E1E2E" })
		vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = "#7B68EE", bg = "#1E1E2E" })
		vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = "#BD93F9", bg = "#1E1E2E" })
		vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = "#FF5555", bold = true })
		vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = "#F1FA8C", bold = true })
		vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = "#8BE9FD", bold = true })
		vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = "#7B68EE", bold = true })
		vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = "#BD93F9", bold = true })
		vim.api.nvim_set_hl(0, "NotifyERRORBody", { fg = "#FF5555" })
		vim.api.nvim_set_hl(0, "NotifyWARNBody", { fg = "#F1FA8C" })
		vim.api.nvim_set_hl(0, "NotifyINFOBody", { fg = "#8BE9FD" })
		vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { fg = "#7B68EE" })
		vim.api.nvim_set_hl(0, "NotifyTRACEBody", { fg = "#BD93F9" })

		-- Store original notify for commands
		local original_notify = notify

		-- Use notify as the default vim.notify with enhanced filtering
		vim.notify = function(msg, level, opts)
			-- Handle nil or empty messages
			if not msg then
				return
			end

			-- Convert to string and trim
			msg = tostring(msg):gsub("^%s+", ""):gsub("%s+$", "")

			-- Filter problematic messages
			if msg == "" or msg == "No information available" then
				return
			end

			-- Enhanced spam filter
			local spam_patterns = {
				"No information available",
				"^%s*$",
				"Starting",
				"Started",
				"ready",
				"initialized",
				"loading",
				"loaded",
				"enabled",
				"disabled",
				"attached",
				"detached",
			}

			for _, pattern in ipairs(spam_patterns) do
				if msg:lower():match(pattern:lower()) then
					if level ~= vim.log.levels.ERROR then
						return
					end
				end
			end

			-- Call notify for clean messages
			return original_notify(msg, level, opts)
		end

		-- Add commands for notification control
		vim.api.nvim_create_user_command("NotifyEnable", function()
			vim.notify = original_notify
			vim.notify("📢 Notifications Enabled", vim.log.levels.INFO, {
				title = "KORA Notification",
				timeout = 2000,
			})
		end, { desc = "Enable all notifications" })

		vim.api.nvim_create_user_command("NotifyDisable", function()
			vim.notify = function() end
			print("🔇 Notifications Disabled")
		end, { desc = "Disable all notifications" })

		vim.api.nvim_create_user_command("NotifyToggle", function()
			if vim.notify == original_notify then
				vim.cmd("NotifyDisable")
			else
				vim.cmd("NotifyEnable")
			end
		end, { desc = "Toggle notifications" })

		-- Additional keymaps
		vim.keymap.set("n", "<leader>nt", "<cmd>NotifyToggle<cr>", { desc = "🔔 Toggle Notifications" })
		vim.keymap.set("n", "<leader>ne", "<cmd>NotifyEnable<cr>", { desc = "📢 Enable Notifications" })
		vim.keymap.set("n", "<leader>nd", "<cmd>NotifyDisable<cr>", { desc = "🔇 Disable Notifications" })

		-- Show welcome notification ONLY once on startup (reduced spam)
		vim.defer_fn(function()
			-- Only show if notifications are enabled
			if vim.notify == original_notify then
				original_notify("󰓩 KORA Neural Matrix Online", vim.log.levels.INFO, {
					title = "KORA System",
					timeout = 1500,
				})
			end
		end, 1000) -- Delayed to avoid startup spam
	end,
}
