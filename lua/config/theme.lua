-- Theme Configuration
-- Wraps theme_manager for backward compatibility

local M = {}

-- Available themes
M.available_themes = { "noir" }
M.current_theme = "noir"

function M.get_current()
  return M.current_theme
end

function M.get_available()
  return M.available_themes
end

function M.apply(name)
  -- Read current transparency preference
  local prefs = require("config.preferences")
  local transparency = prefs.get("transparency")
  vim.g.transparency = transparency
  
  if name and name ~= M.current_theme then
    local theme_manager = require("config.theme_manager")
    if theme_manager.themes[name] then
      theme_manager.themes[name].apply()
      M.current_theme = name
      vim.g.theme = name
      vim.notify("Theme applied: " .. name, vim.log.levels.INFO)
      return true
    end
    vim.notify("Theme not found: " .. name, vim.log.levels.ERROR)
    return false
  end
  
  -- Apply current theme
  local theme_manager = require("config.theme_manager")
  if theme_manager.themes[M.current_theme] then
    theme_manager.themes[M.current_theme].apply()
  end
end

function M.setup()
  local theme_manager = require("config.theme_manager")
  theme_manager.setup()
  
  -- Apply saved preference
  local prefs = require("config.preferences")
  local saved_theme = prefs.get("theme")
  local transparency = prefs.get("transparency")
  
  -- Set global transparency for theme manager
  vim.g.transparency = transparency
  
  if saved_theme and theme_manager.themes[saved_theme] then
    M.apply(saved_theme)
  else
    M.apply("noir")
  end
end

return M