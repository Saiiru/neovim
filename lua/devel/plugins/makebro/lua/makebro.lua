local Path = require("plenary.path")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

local function extract_makefile_targets()
	local targets = {}
	local makefile_path = Path:new("Makefile")

	for line in makefile_path:iter() do
		local target = line:match("^([%w-_]+):")
		if target then
			table.insert(targets, target)
		end
	end

	return targets
end

local function makefile_targets_picker()
	local targets = extract_makefile_targets()

	pickers
		.new({}, {
			prompt_title = "Makefile Targets",
			finder = finders.new_table({
				results = targets,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry,
						ordinal = entry,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					vim.cmd("make " .. selection.value)
				end)
				return true
			end,
		})
		:find()
end

vim.api.nvim_create_user_command("Makebro", makefile_targets_picker, {})
