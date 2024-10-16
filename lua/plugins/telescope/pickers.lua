local M = {}

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

function M.project_files(opts)
  opts = opts or {}
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end

function M.buffer_search()
  pickers.new({}, {
    prompt_title = "Buffer Search",
    finder = finders.new_table {
      results = vim.fn.getbufinfo({bufloaded = true}),
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name,
          ordinal = entry.name,
        }
      end,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<CR>", function()
        local selection = action_state.get_selected_entry()
        if selection and vim.api.nvim_buf_is_valid(selection.value.bufnr) then
          vim.api.nvim_set_current_buf(selection.value.bufnr)
        else
          print("Failed to switch to buffer " .. selection.value.bufnr)
        end
        actions.close(prompt_bufnr)
      end)
      return true
    end,
  }):find()
end

return M
