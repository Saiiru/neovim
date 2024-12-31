return {
  "vuki656/package-info.nvim",
  dependencies = { "folke/which-key.nvim", "MunifTanjim/nui.nvim" },
  ft = { "json" },
  opts = {
    autostart = true,
    hide_up_to_date = true,
    hide_unstable_versions = false,
    package_manager = "auto", -- "auto" makes the plugin choose the package manager automatically
  },
  init = function()
    -- Function to check if a command (executable) is available
    local function is_executable(cmd)
      return vim.fn.executable(cmd) == 1
    end

    -- Function to detect the appropriate package manager based on availability
    local function detect_package_manager()
      -- Prefer pnpm, fall back to npm if pnpm is not available
      if is_executable("pnpm") then
        return "pnpm"
      elseif is_executable("npm") then
        return "npm"
      -- For Python, prefer pip (if available), fall back to pip3
      elseif is_executable("pip") then
        return "pip"
      elseif is_executable("pip3") then
        return "pip3"
      -- For Ruby, use gem if available
      elseif is_executable("gem") then
        return "gem"
      -- For Rust, use cargo if available
      elseif is_executable("cargo") then
        return "cargo"
      -- If no known package manager is found, fall back to npm as default
      else
        return "npm"
      end
    end

    -- Detect and configure the appropriate package manager
    local detected_package_manager = detect_package_manager()

    -- Display a message showing the detected package manager
    -- vim.api.nvim_echo({ { "Detected package manager: " .. detected_package_manager, "InfoMsg" } }, true, {})

    -- Configure the plugin to use the detected package manager
    require("package-info").setup({
      package_manager = detected_package_manager,
    })

    -- Store the detected package manager globally
    _G.current_package_manager = detected_package_manager
  end,

  keys = function()
    require("which-key").add({ { "<leader>p", group = "PackageInfo", icon = "" } })

    local function map(key, cmd, desc)
      vim.keymap.set("n", "<leader>p" .. key, cmd, { desc = desc, silent = true, noremap = true })
    end

    local pi = require("package-info")

    map("s", pi.show, "Show package info")
    map("h", pi.hide, "Hide package info")
    map("n", pi.toggle, "Toggle package info")
    map("u", pi.update, "Update package")
    map("d", pi.delete, "Delete package")
    map("i", pi.install, "Install package")
    map("v", pi.change_version, "Change package version")

    -- Adding a mapping to show the current package manager
    map("p", function()
      -- Displays the current package manager in the message area
      vim.api.nvim_echo({ { "Current package manager: " .. _G.current_package_manager, "InfoMsg" } }, true, {})
    end, "Show current package manager")
  end,
}
