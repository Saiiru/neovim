-- Source: https://codeberg.org/www-gem/Scripts
-- ~/.config/nvim/lua/user_functions/tasks.lua
local M = {}
function M.annotation_update(line_nb)
	if line_nb == 0 then
		line_nb = vim.fn.line(".")
	end
	local total_lines = vim.api.nvim_buf_line_count(0)

	for line = line_nb, total_lines do
		local current_line = vim.fn.getline(line)
		local task_id = string.match(current_line, "UUID: ([%w-]+)")
		local annot_line_cmd = string.format("task %s export | jq '.[].annotations.[-1].description'", task_id)
		local annot = vim.fn.system(annot_line_cmd)
		local annot_line = string.match(annot, "+(%d+)")
		annot_line = tonumber(annot_line)

		if annot ~= "" and annot_line ~= line then
			local file_path = vim.fn.expand("%:p") -- Get full path of current file
			local annotation = string.format("+%s %s", line, vim.fn.shellescape(file_path))
			local annotate_cmd = string.format('task %s annotate "%s"', task_id, annotation)
			vim.fn.system(annotate_cmd)
			vim.notify("Annotation(s) updated")
		elseif task_id and annot == "" then
			vim.notify("Can't find UUID on line " .. line)
		end
	end
end

function M.create_or_update_task()
	local current_line = vim.fn.getline(".")
	local file_path = vim.fn.expand("%:p") -- Get full path of current file
	local line_number = vim.fn.line(".") -- Get current line number

	-- Ask for parameters
	local task_tag = ""
	local project = vim.fn.input("Project name: ")
	local start = vim.fn.input("Start date: ")
	local due = vim.fn.input("Due date (default: start+1h): ")
	local additional_tags_input = vim.fn.input("Tags (separated by spaces): ")
	local additional_tags = {}

	-- Check for gamified study syntax: #TW study:<xp>:<subject>:<duration> Description
	local study_match = string.match(current_line, "#TW%s+study:(%d+):([^:]+):(%d+)%s+(.+)$")
	if study_match then
		local xp = study_match
		local subject = study_match
		local duration = study_match
		local description = study_match:match("^%s*(.+)$")
		task_cmd = string.format('task add project:study +study study_xp:%s study_level:1 study_subject:"%s" study_duration:%s "%s"',
			xp, subject, duration, description)
	else
		-- Keywords to look for
		local keywords = { "#TW" }

		for _, keyword in ipairs(keywords) do
			local kw_start_index, kw_end_index = string.find(current_line, keyword)
			-- Check line validity
			if not kw_start_index then
				vim.notify("No valid keyword found")
			else
				-- Add task description
				local id_keyword = ":: UUID:"
				local task_id = string.match(current_line, "UUID: ([%w-]+)")
				local id_start_index = string.find(current_line, id_keyword)
				if task_id then
					local task_description = string.sub(current_line, kw_end_index + 2, id_start_index - 2)
					task_cmd = string.format('task %s mod %s "%s"', task_id, task_tag, task_description)
				else
					local task_description = string.sub(current_line, kw_end_index + 1)
					task_cmd = string.format('task add %s "%s"', task_tag, task_description)
				end

			-- Prefix each additional tag with a "+"
			for tag in additional_tags_input:gmatch("%S+") do
				table.insert(additional_tags, "+" .. tag)
			end

			-- Add additional tags if available
			if #additional_tags > 0 then
				task_cmd = task_cmd .. " " .. table.concat(additional_tags, " ")
			end

			-- Add project if available
			if #project > 0 then
				task_cmd = task_cmd .. " project:" .. project
			end

			-- Add start date if available
			if #start > 0 then
				task_cmd = task_cmd .. " start:" .. '"' .. start .. '"'
			end

			-- Add due date if available
			if #due > 0 then
				task_cmd = task_cmd .. " due:" .. due
			else
				task_cmd = task_cmd .. " due:" .. "start+1h"
			end

			-- Execute the task add command
			output = vim.fn.system(task_cmd)

			-- Task update notification
			local task_id = string.match(current_line, "UUID: ([%w-]+)")
			if task_id then
				vim.notify("Task updated")
			end

			-- Add annotation to new task
			local new_task_id = string.match(output, "Created task (%d+)%.")
			if new_task_id then
				-- Retrieve UUID
				local tasks_number_cmd = "task count status=pending"
				local tasks_number = vim.fn.system(tasks_number_cmd)
				tasks_number = tasks_number:gsub("%s+$", "")
				local new_task_id_cmd = string.format("task %s export | jq '.[].uuid' | sed 's/\"//g'", tasks_number)
				new_task_id = vim.fn.system(new_task_id_cmd)
				new_task_id = new_task_id:gsub("%s+$", "")

				-- Annotate task with filename and line number
				local annotation = string.format("+%s %s", line_number, vim.fn.shellescape(file_path))
				local annotate_cmd = string.format('task %s annotate "%s"', new_task_id, annotation)
				vim.fn.system(annotate_cmd)
				vim.notify("Task created")

				-- Add UUID to line
				local line_id = current_line .. " :: UUID: " .. new_task_id
				vim.fn.setline(".", line_id)

				-- Comment the line
				vim.api.nvim_command("normal! gcc")
			elseif not task_id then
				vim.notify("Failed to extract task ID")
			end

			-- Update annotation on line change
			M.annotation_update(0)
		end
	end
end
end

vim.keymap.set("n", "<leader>ta", function()
	require("user_functions.tasks").create_or_update_task()
end)

function M.task_delete()
	local current_line = vim.fn.getline(".")
	local task_id = string.match(current_line, "UUID: ([%w-]+)")
	local status_cmd = string.format("task %s export | jq '.[].status' | sed 's/\"//g'", task_id)
	local status = vim.fn.system(status_cmd)

	if string.match(status, "pending") then
		local delete_cmd = string.format("task rc.confirmation=off del %s", task_id)
		vim.fn.system(delete_cmd)
		vim.notify("Task " .. task_id .. " deleted")
		vim.api.nvim_command("normal! dd")
		M.annotation_update(0)
	else
		vim.notify("Can't find UUID task")
	end
end

vim.keymap.set("n", "<leader>td", function()
	require("user_functions.tasks").task_delete()
end)

function M.task_complete()
	local current_line = vim.fn.getline(".")
	local task_id = string.match(current_line, "UUID: ([%w-]+)")

	if task_id then
		local complete_cmd = string.format("task %s mod status:completed", task_id)
		vim.fn.system(complete_cmd)
		vim.notify("Task " .. task_id .. " completed")
		M.annotation_update(0)
	else
		vim.notify("Can't find UUID task")
	end
end

vim.keymap.set("n", "<leader>tc", function()
	require("user_functions.tasks").task_complete()
end)

function M.task_undo()
	local undo_cmd = string.format("task rc.confirmation=off undo")
	local undo_output = vim.fn.system(undo_cmd)
	vim.cmd("undo")
	vim.notify("Undo output: ", undo_output)
end

vim.keymap.set("n", "<leader>tu", function()
	require("user_functions.tasks").task_undo()
end)

function M.task_info()
	local current_line = vim.fn.getline(".")
	local task_id = string.match(current_line, "UUID: ([%w-]+)")
	local info_cmd = string.format("task %s info | head -n 12", task_id)
	local info = vim.fn.system(info_cmd)
	vim.notify(info)
end

vim.keymap.set("n", "<leader>ti", function()
	require("user_functions.tasks").task_info()
end)

return M
