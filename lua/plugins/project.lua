-- Project detection and management
-- Auto-detect project root, switch cwd, integrate with telescope/fff

return {
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",
  opts = {
    ------------------------------------------------------------------------
    -- DETECTION METHODS
    ------------------------------------------------------------------------
    detection_methods = { "pattern", "lsp" },

    ------------------------------------------------------------------------
    -- PATTERNS TO DETECT PROJECT ROOT
    ------------------------------------------------------------------------
    patterns = {
      ".git",
      ".hg",
      ".svn",
      "package.json",
      "go.mod",
      "Cargo.toml",
      "pyproject.toml",
      "setup.py",
      "requirements.txt",
      "pom.xml",
      "build.gradle",
      "build.gradle.kts",
      "Makefile",
      "meson.build",
      "CMakeLists.txt",
      ".project",
      ".vscode",
      ".idea",
    },

    ------------------------------------------------------------------------
    -- IGNORE PATTERNS
    ------------------------------------------------------------------------
    ignore_lsp = { "lua_ls", "null-ls", "copilot" },

    ------------------------------------------------------------------------
    -- SILENT CHDIR
    ------------------------------------------------------------------------
    silent_chdir = true,

    ------------------------------------------------------------------------
    -- SCOPE
    ------------------------------------------------------------------------
    scope_chdir = "global",

    ------------------------------------------------------------------------
    -- DATAPATH
    ------------------------------------------------------------------------
    datapath = vim.fn.stdpath "data",

    ------------------------------------------------------------------------
    -- CALLBACK ON PROJECT DETECTION
    ------------------------------------------------------------------------
    callback = function(project_root)
      -- Notify when project changes
      local project_name = vim.fn.fnamemodify(project_root, ":t")
      vim.notify("📁 Project: " .. project_name, vim.log.levels.INFO, { title = "Project.nvim" })
    end,
  },
  config = function(_, opts)
    require("project_nvim").setup(opts)

    ------------------------------------------------------------------------
    -- INTEGRATION WITH FFF (file picker)
    ------------------------------------------------------------------------
    local ok_fff, fff = pcall(require, "fff")
    if ok_fff then
      -- Use project root for fff find_files
      local original_find_files = fff.find_files
      fff.find_files = function(opts)
        opts = opts or {}
        local project = require("project_nvim.project")
        local root = project.get_project_root()
        if root then
          opts.cwd = root
        end
        return original_find_files(opts)
      end
    end

    ------------------------------------------------------------------------
    -- INTEGRATION WITH TELESCOPE (if available)
    ------------------------------------------------------------------------
    local ok_telescope, telescope = pcall(require, "telescope")
    if ok_telescope then
      pcall(telescope.load_extension, "projects")
    end

    ------------------------------------------------------------------------
    -- USER COMMANDS
    ------------------------------------------------------------------------
    vim.api.nvim_create_user_command("ProjectRoot", function()
      local project = require "project_nvim.project"
      local root = project.get_project_root()
      if root then
        vim.notify("Project root: " .. root)
      else
        vim.notify("No project root detected", vim.log.levels.WARN)
      end
    end, { desc = "Show current project root" })

    vim.api.nvim_create_user_command("ProjectList", function()
      local history = require "project_nvim.utils.history"
      local projects = history.get_recent_projects()
      for _, p in ipairs(projects) do
        print(p)
      end
    end, { desc = "List recent projects" })

    vim.api.nvim_create_user_command("ProjectAdd", function()
      local project = require "project_nvim.project"
      project.add_project(vim.fn.getcwd())
      vim.notify("Added current directory as project")
    end, { desc = "Add current directory as project" })
  end,
  keys = {
    { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Find projects (Telescope)" },
    { "<leader>fP", "<cmd>ProjectRoot<cr>", desc = "Show project root" },
  },
}