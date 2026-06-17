-- Java LSP with nvim-jdtls
-- Uses eclipse.jdt.ls via nvim-jdtls plugin

return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  dependencies = {
    "folke/which-key.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    ------------------------------------------------------------------------
    -- JAVA OPTS
    ------------------------------------------------------------------------
    local function get_jdtls_config()
      local home = vim.env.HOME
      local jdtls_path = vim.fn.expand(home .. "/.local/share/mise/installs/java/temurin-21.0.10+7.0.LTS")
      local jdtls_jar = vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
      local jdtls_config = home .. "/.local/share/nvim/mason/packages/jdtls/config_linux"
      local lombok_jar = home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar"

      -- Workspace folder
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

      -- Java version (use mise managed version)
      local java_cmd = "java"

      return {
        cmd = {
          java_cmd,
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xms1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-javaagent:" .. lombok_jar,
          "-jar", jdtls_jar,
          "-configuration", jdtls_config,
          "-data", workspace_dir,
        },
        root_dir = require("jdtls.setup").find_root({ ".git", "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts" }),
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
            completion = {
              favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.junit.Assert.*",
                "org.junit.Assume.*",
                "org.junit.jupiter.api.Assertions.*",
                "org.junit.jupiter.api.Assumptions.*",
                "org.mockito.Mockito.*",
              },
              filteredTypes = {
                "com.sun.*",
                "io.micrometer.shaded.*",
                "java.awt.*",
                "jdk.*",
                "sun.*",
              },
            },
            sources = {
              organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
            },
            codeGeneration = {
              toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
              },
              useBlocks = true,
            },
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = jdtls_path,
                },
              },
            },
          },
        },
        init_options = {
          bundles = {},
        },
      }
    end

    ------------------------------------------------------------------------
    -- SETUP JDTLS
    ------------------------------------------------------------------------
    local function setup_jdtls()
      local config = get_jdtls_config()
      require("jdtls").start_or_attach(config)

      ------------------------------------------------------------------------
      -- KEYMAPS FOR JAVA
      ------------------------------------------------------------------------
      local opts = { buffer = true, silent = true }
      local map = vim.keymap.set

      map("n", "<leader>co", "<cmd>lua require'jdtls'.organize_imports()<cr>", vim.tbl_extend("force", opts, { desc = "Organize Imports" }))
      map("n", "<leader>ct", "<cmd>lua require'jdtls'.test_class()<cr>", vim.tbl_extend("force", opts, { desc = "Test Class" }))
      map("n", "<leader>cn", "<cmd>lua require'jdtls'.test_nearest_method()<cr>", vim.tbl_extend("force", opts, { desc = "Test Nearest Method" }))
      map("n", "<leader>cr", "<cmd>lua require'jdtls'.rename()<cr>", vim.tbl_extend("force", opts, { desc = "Rename (Java)" }))
      map("v", "<leader>cm", "<cmd>lua require'jdtls'.extract_method(true)<cr>", vim.tbl_extend("force", opts, { desc = "Extract Method" }))
      map("n", "<leader>cm", "<cmd>lua require'jdtls'.extract_variable()<cr>", vim.tbl_extend("force", opts, { desc = "Extract Variable" }))
      map("n", "<leader>ci", "<cmd>lua require'jdtls'.super_implementation()<cr>", vim.tbl_extend("force", opts, { desc = "Super Implementation" }))
    end

    ------------------------------------------------------------------------
    -- AUTOCMD FOR JAVA FILES
    ------------------------------------------------------------------------
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = setup_jdtls,
    })

    ------------------------------------------------------------------------
    -- WHICH-KEY INTEGRATION
    ------------------------------------------------------------------------
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add {
        { "<leader>j", group = "Java", icon = "☕" },
        { "<leader>jo", "<cmd>lua require'jdtls'.organize_imports()<cr>", desc = "Organize Imports" },
        { "<leader>jt", "<cmd>lua require'jdtls'.test_class()<cr>", desc = "Test Class" },
        { "<leader>jn", "<cmd>lua require'jdtls'.test_nearest_method()<cr>", desc = "Test Nearest Method" },
        { "<leader>jr", "<cmd>lua require'jdtls'.rename()<cr>", desc = "Rename" },
        { "<leader>jm", "<cmd>lua require'jdtls'.extract_method(true)<cr>", mode = "v", desc = "Extract Method" },
        { "<leader>jv", "<cmd>lua require'jdtls'.extract_variable()<cr>", desc = "Extract Variable" },
        { "<leader>ji", "<cmd>lua require'jdtls'.super_implementation()<cr>", desc = "Super Implementation" },
      }
    end
  end,
}