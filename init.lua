-- File: lua/sairu/init.lua
require "sairu.config.launch"
require "sairu.config.options"
require "sairu.config.keymaps"
require "sairu.config.autocmds"

-- Lazy plugin specifications array
LAZY_PLUGIN_SPEC = {}

-- Function to dynamically load all plugins from the plugins directory
local function load_plugins()
  -- Find all Lua files in the plugins directory and its subdirectories
  local plugin_files = vim.fn.glob("lua/sairu/plugins/**/*.lua", true, true)
  for _, file in ipairs(plugin_files) do
    -- Convert file path into a Lua module path for requiring
    local plugin = file:match("lua/sairu/plugins/(.+)%.lua$")
    if plugin then
      local success, err = pcall(function()
        -- Add the plugin module to LAZY_PLUGIN_SPEC using the spec function
        spec("sairu.plugins." .. plugin:gsub("/", "."))
      end)
      if not success then
        vim.notify("Failed to load plugin spec: " .. plugin .. "\nError: " .. err, vim.log.levels.ERROR)
      end
    end
  end
end

-- Load all plugin specifications
load_plugins()

-- Initialize lazy loading
require "sairu.lazy"

