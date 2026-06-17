-- Preferences Module
-- Centralized user preferences management
-- Inspired by nvpunk's preferences system

local M = {}

-- Default preferences
M.default_preferences = {
  -- Theme
  theme = "noir",
  theme_variant = "dark",
  
  -- UI
  transparency = true,
  rounded_borders = true,
  dim_inactive = true,
  cursorline = true,
  relativenumber = true,
  
  -- Editor
  tab_width = 2,
  indent_width = 2,
  expandtab = true,
  line_numbers = "relative",
  wrap = false,
  cursorline = true,
  colorcolumn = 100,
  
  -- Windows
  split_below = true,
  split_right = true,
  equalalways = false,
  
  -- LSP
  inlay_hints = true,
  virtual_text = true,
  virtual_lines = false,
  diagnostic_underline = true,
  
  -- Completion
  completion_mode = "blink",
  snippet_engine = "luasnip",
  
  -- Tools
  terminal = "toggleterm",
  file_explorer = "oil",
  picker = "snacks",
  finder = "fff",
  
  -- Git
  git_signs = true,
  git_blame = false,
  git_diff = "mini.diff",
  
  -- Performance
  large_file_threshold = 1.5 * 1024 * 1024,
  
  -- Experimental
  experimental = false,
}

-- Internal state
local preferences = nil
local preferences_file = vim.fn.stdpath("config") .. "/preferences.json"

-- Load preferences from file
function M.load()
  if preferences ~= nil then
    return preferences
  end
  
  local file = io.open(preferences_file, "r")
  if file then
    local content = file:read("*a")
    file:close()
    local ok, decoded = pcall(vim.json.decode, content)
    if ok and decoded then
      preferences = vim.tbl_deep_extend("force", M.default_preferences, decoded)
      return preferences
    end
  end
  
  preferences = vim.deepcopy(M.default_preferences)
  return preferences
end

-- Save preferences to file
function M.save()
  local file = io.open(preferences_file, "w")
  if file then
    file:write(vim.json.encode(preferences))
    file:close()
    return true
  end
  return false
end

-- Get preference value
function M.get(key)
  local prefs = M.load()
  local keys = vim.split(key, ".", { plain = true })
  local value = prefs
  for _, k in ipairs(keys) do
    if type(value) == "table" and value[k] ~= nil then
      value = value[k]
    else
      return nil
    end
  end
  return value
end

-- Set preference value
function M.set(key, value)
  local prefs = M.load()
  local keys = vim.split(key, ".", { plain = true })
  local target = prefs
  for i = 1, #keys - 1 do
    local k = keys[i]
    if type(target[k]) ~= "table" then
      target[k] = {}
    end
    target = target[k]
  end
  target[keys[#keys]] = value
  return M.save()
end

-- Toggle boolean preference
function M.toggle(key)
  local current = M.get(key)
  if type(current) == "boolean" then
    return M.set(key, not current)
  end
  return false
end

-- Reset to defaults
function M.reset()
  preferences = vim.deepcopy(M.default_preferences)
  return M.save()
end

-- Get all preferences
function M.get_all()
  return M.load()
end

-- Setup user commands
function M.setup_commands()
  vim.api.nvim_create_user_command("PrefsGet", function(opts)
    local key = opts.args
    if key == "" then
      local prefs = M.get_all()
      print(vim.inspect(prefs))
    else
      local value = M.get(key)
      print(key .. " = " .. vim.inspect(value))
    end
  end, { nargs = "?", desc = "Get preference value" })
  
  vim.api.nvim_create_user_command("PrefsSet", function(opts)
    local args = vim.split(opts.args, " ", { plain = true })
    if #args >= 2 then
      local key = args[1]
      local val = args[2]
      -- Try to parse value
      if val == "true" then val = true
      elseif val == "false" then val = false
      elseif tonumber(val) then val = tonumber(val) end
      
      if M.set(key, val) then
        vim.notify("Set " .. key .. " = " .. vim.inspect(val), vim.log.levels.INFO)
      else
        vim.notify("Failed to save preferences", vim.log.levels.ERROR)
      end
    else
      vim.notify("Usage: PrefsSet <key> <value>", vim.log.levels.ERROR)
    end
  end, { nargs = "+", desc = "Set preference value" })
  
  vim.api.nvim_create_user_command("PrefsToggle", function(opts)
    local key = opts.args
    if key ~= "" then
      local result = M.toggle(key)
      if result ~= false then
        local new_val = M.get(key)
        vim.notify(key .. " = " .. tostring(new_val), vim.log.levels.INFO)
      else
        vim.notify("Failed to toggle " .. key, vim.log.levels.ERROR)
      end
    else
      vim.notify("Usage: PrefsToggle <key>", vim.log.levels.ERROR)
    end
  end, { nargs = 1, desc = "Toggle boolean preference" })
  
  vim.api.nvim_create_user_command("PrefsReset", function()
    if M.reset() then
      vim.notify("Preferences reset to defaults", vim.log.levels.INFO)
    else
      vim.notify("Failed to reset preferences", vim.log.levels.ERROR)
    end
  end, { desc = "Reset preferences to defaults" })
  
  vim.api.nvim_create_user_command("PrefsEdit", function()
    vim.cmd("edit " .. vim.fn.stdpath("config") .. "/preferences.json")
  end, { desc = "Edit preferences file" })
end

return M