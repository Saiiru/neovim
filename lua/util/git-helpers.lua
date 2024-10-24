local M = {}
local map_opts = { noremap = true, silent = true, nowait = true }
local u = require("config.functions.utils")
local popup = require("config.popup")

local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
local diffview_ok, diffview = pcall(require, "diffview")
local plenary_ok, job = pcall(require, "plenary.job")

if not gitsigns_ok or not diffview_ok or not plenary_ok then
  vim.api.nvim_err_writeln("Gitsigns, diffview, or plenary not installed, cannot configure Git tools")
  return
end

-- Hunk-level operations
vim.keymap.set("n", "<leader>ghn", function() -- Next Change
  gitsigns.next_hunk()
  gitsigns.preview_hunk()
end, map_opts)

vim.keymap.set("n", "<leader>ghp", function() -- Previous Change
  gitsigns.prev_hunk()
  gitsigns.preview_hunk()
end, map_opts)

vim.keymap.set("n", "<leader>ghr", gitsigns.reset_hunk, map_opts) -- Reset Hunk
vim.keymap.set("n", "<leader>gha", gitsigns.stage_hunk, map_opts) -- Add hunk
vim.keymap.set("n", "<leader>ghv", gitsigns.preview_hunk, map_opts) -- Preview hunk

-- Adding files...
vim.keymap.set("n", "<leader>gaa", M.add_all, map_opts)
vim.keymap.set("n", "<leader>gah", gitsigns.stage_hunk, map_opts)
vim.keymap.set("n", "<leader>gac", M.add_current, map_opts)

-- Committing changes...
vim.keymap.set("n", "<leader>gcm", M.commit, map_opts)
vim.keymap.set("n", "<leader>gce", M.commit_easy, map_opts)

-- Resetting changes...
vim.keymap.set("n", "<leader>gre", M.reset_easy_commits, map_opts)
vim.keymap.set("n", "<leader>grr", M.reset, map_opts)

-- Stashing and unstashing...
vim.keymap.set("n", "<leader>gss", M.stash, map_opts)
vim.keymap.set("n", "<leader>gsp", M.pop, map_opts)

-- Viewing changes and diffs...
vim.keymap.set("n", "<leader>gvc", M.view_changes, map_opts)
vim.keymap.set("n", "<leader>gvs", M.view_staged, map_opts)
vim.keymap.set("n", "<leader>gvfh", M.view_file_history, map_opts)

-- Miscellaneous...
vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, map_opts)
vim.keymap.set("n", "<leader>gq", function() gitsigns.setqflist("all") end, map_opts)

-- Pushing and pulling...
vim.keymap.set("n", "<leader>gPP", M.push, map_opts)
vim.keymap.set("n", "<leader>gPU", M.pull, map_opts)

-- Commit function with automatic message
M.commit_easy = function()
  local relative_file_path = u.copy_relative_filepath(true)
  job:new({
    command = 'git',
    args = { "commit", relative_file_path, "-m", string.format("Updated %s", relative_file_path) },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")('Could not commit change!', vim.log.levels.ERROR)
      else
        require("notify")('Committed file', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Stash function
M.stash = function()
  job:new({
    command = 'git',
    args = { "stash" },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")('Could not stash changes!', vim.log.levels.ERROR)
      else
        require("notify")('Stashed', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Add all changes function
M.add_all = function()
  job:new({
    command = 'git',
    args = { "add", "." },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")('Could not add all files!', vim.log.levels.ERROR)
      else
        require("notify")('Added all files', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Reset function
M.reset = function()
  job:new({
    command = 'git',
    args = { "reset" },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")('Could not reset staged changes', vim.log.levels.ERROR)
      else
        require("notify")('Unstaged all changes', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Add current file function
M.add_current = function()
  local relative_file_path = u.copy_relative_filepath(true)
  job:new({
    command = 'git',
    args = { "add", relative_file_path },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")(string.format('Could not add %s!', relative_file_path), vim.log.levels.ERROR)
      else
        require("notify")('Added current file', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Reset easy commits function
M.reset_easy_commits = function()
  local latest_non_easy_commit = io.popen(
    "git log --format=\"%s %H\" | grep -v \"^Updated \" | awk '{ print $NF }' | tail -n +1 | head -1")
  if latest_non_easy_commit == nil then
    require("notify")('No easy commit hash found!', vim.log.levels.ERROR)
    return
  end

  local non_easy_hash = vim.fn.trim(latest_non_easy_commit:read("*a"))
  latest_non_easy_commit:close()

  job:new({
    command = 'git',
    args = { 'reset', '--soft', non_easy_hash },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")('Could not reset easy commits softly!', vim.log.levels.ERROR)
      else
        require("notify")('Soft reset all easy commits', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Commit function to open a popup
M.commit = function()
  popup.create_popup_with_action("Commit Message", function(msg)
    job:new({
      command = 'git',
      args = { 'commit', '-m', msg },
      on_exit = vim.schedule_wrap(function(_, exit_code)
        if exit_code ~= 0 then
          require("notify")('Could not commit changes with message!', vim.log.levels.ERROR)
        else
          require("notify")('Committed.', vim.log.levels.INFO)
        end
      end),
    }):start()
  end)
end

-- Pop stashed changes function
M.pop = function()
  job:new({
    command = 'git',
    args = { 'stash', 'pop' },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")('Could not pop off stash!', vim.log.levels.ERROR)
      else
        require("notify")('Popped.', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Push function
M.push = function()
  local push_job = job:new({
    command = 'git',
    args = { 'push' },
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")("Could not push!", "error")
      else
        require("notify")("Pushed.", "info")
      end
    end,
  })

  local isSubmodule = vim.fn.trim(vim.fn.system("git rev-parse --show-superproject-working-tree"))
  if isSubmodule == "" then
    push_job:start()
  else
    if vim.fn.confirm("Push to origin/main branch for submodule?") == 1 then
      push_job:start()
    end
  end
end

-- Pull function
M.pull = function()
  job:new({
    command = 'git',
    args = { 'pull' },
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")("Could not pull!", "error")
      else
        require("notify")("Pulled.", "info")
      end
    end,
  }):start()
end

-- Check if inside a Git work tree
M.is_inside_work_tree = function(cb)
  local branch_name_job = job:new({
    command = 'git',
    args = { 'rev-parse', '--is-inside-work-tree' },
    on_stdout = vim.schedule_wrap(function(err, data)
      if err == nil and data == "true" then
        cb()
      end
    end)
  })

  branch_name_job:start()
end

return M

