Vim�UnDo� ��\y!ٯ�p���V���z��X��Tol���M   "   require "sairu.config.launch"                             gF �    _�                        !    ����                                                                                                                                                                                                                                                                                                                                                             gD.!    �               #-- spec "sairu.plugins.breadcrumbs"    �                �             5��                          �                     �       #                  �                     �       #                  �                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             gDu&    �                 -- require "sairu.lazy"5��                         �                    5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             gDu�    �               #-- spec "sairu.plugins.colorscheme"5��                         |       $       !       5�_�                          ����                                                                                                                                                                                                                                                                                                                                                 v       gD}�     �             �             5��                          �               !       5�_�                            ����                                                                                                                                                                                                                                                                                                                               !                  v        gD~    �                �             �                spec "sairu.plugins.colorscheme"    spec "sairu.plugins.colorscheme"    -- spec "sairu.plugins.devicons"   "-- spec "sairu.plugins.treesitter"   -- spec "sairu.plugins.mason"   #-- spec "sairu.plugins.schemastore"   !-- spec "sairu.plugins.lspconfig"   -- spec "sairu.plugins.cmp"   !-- spec "sairu.plugins.telescope"   -- spec "sairu.plugins.none-ls"   "-- spec "sairu.plugins.illuminate"    -- spec "sairu.plugins.gitsigns"    -- spec "sairu.plugins.whichkey"    -- spec "sairu.plugins.nvimtree"   -- spec "sairu.plugins.comment"   -- spec "sairu.plugins.lualine"   -- spec "sairu.plugins.navic"   $-- spec "sairu.plugins.breadcrumbs"'   -- spec "sairu.plugins.harpoon"   -- spec "sairu.plugins.neotest"   !-- spec "sairu.plugins.autopairs"   -- spec "sairu.plugins.neogit"   -- spec "sairu.plugins.alpha"   -- spec "sairu.plugins.project"   "-- spec "sairu.plugins.indentline"   "-- spec "sairu.plugins.toggleterm"5��              "           |       U              �                         |                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                 v       gD~-     �                 require "sairu.lazy"�               5��                          �                     �                         �              /       5�_�                           ����                                                                                                                                                                                                                                                                                                                                                 v       gD~.    �             5��                          �                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                 v       gD~2     �               require "sairu.config.keymaps"    �                �             5��                          \                      �                         [                      5�_�                           ����                                                                                                                                                                                                                                                                                                                                                 v       gD~4    �               require "sairu.config.autocmds"5��                         {                      5�_�                            ����                                                                                                                                                                                                                                                                                                                                                 v���    gE&~    �                   �               �                  require "sairu.config.launch"   require "sairu.config.options"   require "sairu.config.keymaps"   require "sairu.config.autocmds"       F-- Function to dynamically load all plugins from the plugins directory   local function load_plugins()   I  local plugin_files = vim.fn.glob("lua/sairu/plugins/*.lua", true, true)   (  for _, file in ipairs(plugin_files) do   /    local plugin = file:match("^.+/(.+)%.lua$")       if plugin then   )      local success, _ = pcall(function()   (        spec("sairu.plugins." .. plugin)   
      end)         if not success then   M        vim.notify("Failed to load plugin: " .. plugin, vim.log.levels.ERROR)   	      end       end     end   end       -- Load plugins   load_plugins()       -- Initialize lazy loading   require "sairu.lazy"5��                                  �              �                                           �      5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  v        gE&�    �                   �               �                  -- File: lua/sairu/init.lua   require "sairu.config.launch"   require "sairu.config.options"   require "sairu.config.keymaps"   require "sairu.config.autocmds"       T-- Function to dynamically load all plugin configurations from the plugins directory   local function load_plugins()   S  -- Recursively find all Lua files in the plugins directory and its subdirectories   L  local plugin_files = vim.fn.glob("lua/sairu/plugins/**/*.lua", true, true)   (  for _, file in ipairs(plugin_files) do   :    -- Extract the plugin path relative to 'sairu.plugins'   =    local plugin = file:match("lua/sairu/plugins/(.+)%.lua$")       if plugin then   +      local success, err = pcall(function()   :        require("sairu.plugins." .. plugin:gsub("/", "."))   
      end)         if not success then   c        vim.notify("Failed to load plugin: " .. plugin .. "\nError: " .. err, vim.log.levels.ERROR)   	      end       end     end   end       &-- Load all plugins and configurations   load_plugins()       -- Initialize lazy loading   require "sairu.lazy"    5��                                   �              �                    !                       D      5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             gF�    �         "       5��                          �                      �                          �                      5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             gF �     �         "      require "sairu.config.launch"5��                                               5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             gF �    �         "      r equire "sairu.config.launch"5��                                               5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             gF �    �         "      require "sairu.config.launch"5��                         '                      5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             gF �    �         "      require "sa iru.config.launch"5��                         '                      5�_�                           ����                                                                                                                                                                                                                                                                                                                                                 v        gD}Z    �                  �              �                  -- Load essential configurations   require "sairu.config.launch"   require "sairu.config.options"   require "sairu.config.keymaps"   require "sairu.config.autocmds"       F-- Function to dynamically load all plugins from the plugins directory   local function load_plugins()   I  local plugin_files = vim.fn.glob("lua/sairu/plugins/*.lua", true, true)   (  for _, file in ipairs(plugin_files) do   /    local plugin = file:match("^.+/(.+)%.lua$")       if plugin then   C      local success, _ = pcall(require, "sairu.plugins." .. plugin)         if not success then   M        vim.notify("Failed to load plugin: " .. plugin, vim.log.levels.ERROR)   	      end       end     end   end       -- Load plugins   load_plugins()       -- Initialize lazy loading   require "sairu.lazy"5��                                  �              �                                          �      5�_�                            ����                                                                                                                                                                                                                                                                                                                                                 v        gD}�    �                  �              �                  -- Load essential configurations   require "sairu.config.launch"   require "sairu.config.options"   require "sairu.config.keymaps"   require "sairu.config.autocmds"       F-- Function to dynamically load all plugins from the plugins directory   local function load_plugins()   I  local plugin_files = vim.fn.glob("lua/sairu/plugins/*.lua", true, true)   (  for _, file in ipairs(plugin_files) do   /    local plugin = file:match("^.+/(.+)%.lua$")       if plugin then   C      local success, _ = pcall(require, "sairu.plugins." .. plugin)         if not success then   M        vim.notify("Failed to load plugin: " .. plugin, vim.log.levels.ERROR)   	      end       end     end   end       -- Load plugins   load_plugins()       -- Initialize lazy loading   require "sairu.lazy"5��                                  �              �                                          �      5�_�                            ����                                                                                                                                                                                                                                                                                                                            3          2           v        gD}�     �                �         
    �         
   -    -- Load essential configurations   require "sairu.config.launch"   require "sairu.config.options"   require "sairu.config.keymaps"   require "sairu.config.autocmds"       -- Load plugins   local plugins = {     "sairu.plugins.colorscheme",     -- "sairu.plugins.devicons",      -- "sairu.plugins.treesitter",     -- "sairu.plugins.mason",   !  -- "sairu.plugins.schemastore",     -- "sairu.plugins.lspconfig",     -- "sairu.plugins.cmp",     -- "sairu.plugins.telescope",     -- "sairu.plugins.none-ls",      -- "sairu.plugins.illuminate",     -- "sairu.plugins.gitsigns",     -- "sairu.plugins.whichkey",     -- "sairu.plugins.nvimtree",     -- "sairu.plugins.comment",     -- "sairu.plugins.lualine",     -- "sairu.plugins.navic",   !  -- "sairu.plugins.breadcrumbs",     -- "sairu.plugins.harpoon",     -- "sairu.plugins.neotest",     -- "sairu.plugins.autopairs",     -- "sairu.plugins.neogit",     -- "sairu.plugins.alpha",     -- "sairu.plugins.project",      -- "sairu.plugins.indentline",      -- "sairu.plugins.toggleterm",   }       !-- Load each plugin configuration   #for _, plugin in ipairs(plugins) do   +  local success, _ = pcall(require, plugin)     if not success then   A    vim.notify("Failed to load " .. plugin, vim.log.levels.ERROR)     end   end       -- Initialize lazy loading   require "sairu.lazy"5��                         �                     �                   ,      �               �      5�_�                    2        ����                                                                                                                                                                                                                                                                                                                            2          2           v        gD}�     �   1   4   6       5��    1                     8      /               5�_�      	              2        ����                                                                                                                                                                                                                                                                                                                            2          2           v        gD}�     �   1   3        5��    1                      8                     5�_�      
           	          ����                                                                                                                                                                                                                                                                                                                                                v       gD}�     �         4    �         4        "sairu.plugins.colorscheme",5��                          }                     5�_�   	              
          ����                                                                                                                                                                                                                                                                                                                                                v       gD}�     �         5        "sairu.plugins.",5��                         �                     5�_�   
                         ����                                                                                                                                                                                                                                                                                                                                                             gD}�   
 �         5        "sairu.plugins.oil",5��                         �                     �                        �                    5��