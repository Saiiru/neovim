-- Function to retrieve JDTLS configuration paths and launcher
local function get_jdtls()
  local mason_registry = require("mason-registry")
  local jdtls = mason_registry.get_package("jdtls")
  local jdtls_path = jdtls:get_install_path()
  local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  local SYSTEM = "linux" -- Update this according to your OS if necessary
  local config = jdtls_path .. "/config_" .. SYSTEM
  local lombok = jdtls_path .. "/lombok.jar"
  return launcher, config, lombok
end

-- Function to gather required bundles for debugging and testing
local function get_bundles()
  local mason_registry = require("mason-registry")
  local bundles = {}

  -- Java Debug Adapter
  local java_debug = mason_registry.get_package("java-debug-adapter")
  local java_debug_path = java_debug:get_install_path()
  table.insert(bundles, vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1))

  -- Java Test Adapter
  local java_test = mason_registry.get_package("java-test")
  local java_test_path = java_test:get_install_path()
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1), "\n"))

  return bundles
end

-- Function to determine the workspace directory
local function get_workspace()
  local home = os.getenv("HOME")
  local workspace_path = home .. "/code/workspace/"
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  return workspace_path .. project_name
end

-- Function to set Java-specific key mappings
local function java_keymaps()
  local commands = {
    JdtCompile = "lua require('jdtls').compile(<f-args>)",
    JdtUpdateConfig = "lua require('jdtls').update_project_config()",
    JdtBytecode = "lua require('jdtls').javap()",
    JdtJshell = "lua require('jdtls').jshell()"
  }

  for cmd, action in pairs(commands) do
    vim.cmd(string.format("command! -buffer %s %s", cmd, action))
  end

  local keymap_defs = {
    { "n", "<leader>Jo", "organize_imports",          "[J]ava [O]rganize Imports" },
    { "n", "<leader>Jv", "extract_variable",          "[J]ava Extract [V]ariable" },
    { "v", "<leader>Jv", "extract_variable(true)",    "[J]ava Extract [V]ariable" },
    { "n", "<leader>JC", "extract_constant",          "[J]ava Extract [C]onstant" },
    { "v", "<leader>JC", "extract_constant(true)",    "[J]ava Extract [C]onstant" },
    { "n", "<leader>Jt", "test_nearest_method",       "[J]ava [T]est Method" },
    { "v", "<leader>Jt", "test_nearest_method(true)", "[J]ava [T]est Method" },
    { "n", "<leader>JT", "test_class",                "[J]ava [T]est Class" },
    { "n", "<leader>Ju", "JdtUpdateConfig",           "[J]ava [U]pdate Config" }
  }

  for _, mapping in ipairs(keymap_defs) do
    vim.keymap.set(mapping[1], mapping[2], string.format("<Cmd> lua require('jdtls').%s()<CR>", mapping[3]),
      { desc = mapping[4] })
  end
end

-- Function to configure JDTLS
local function setup_jdtls()
  local jdtls = require("jdtls")
  local launcher, os_config, lombok = get_jdtls()
  local workspace_dir = get_workspace()
  local bundles = get_bundles()

  -- Determine the project root directory
  local root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })

  local capabilities = vim.tbl_deep_extend("force", {
    workspace = { configuration = true },
    textDocument = { completion = { snippetSupport = false } },
  }, require("cmp_nvim_lsp").default_capabilities())

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  -- Command to start JDTLS
  local cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. lombok,
    "-jar", launcher,
    "-configuration", os_config,
    "-data", workspace_dir, -- Correção realizada aqui, na vírgula e linha
  }                         -- JDTLS settings

  local settings = {
    java = {
      format = { enabled = true, settings = { url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml", profile = "GoogleStyle" } },
      eclipse = { downloadSource = true },
      maven = { downloadSources = true },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      saveActions = { organizeImports = true },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*", "io.micrometer.shaded.*", "java.awt.*", "jdk.*", "sun.*",
        },
        importOrder = { "java", "jakarta", "javax", "com", "org" },
      },
      sources = { organizeImports = { starThreshold = 9999, staticThreshold = 9999 } },
      codeGeneration = {
        toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
        hashCodeEquals = { useJava7Objects = true },
        useBlocks = true,
      },
      configuration = { updateBuildConfiguration = "interactive" },
      referencesCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
    },
  }

  -- Initialization options for JDTLS
  local init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  }

  -- on_attach function to run after JDTLS attaches to the buffer
  local on_attach = function(_, bufnr)
    java_keymaps()
  end

  -- Start JDTLS
  jdtls.start_or_attach({
    cmd = cmd,
    root_dir = root_dir,
    capabilities = capabilities,
    settings = settings,
    init_options = init_options,
    on_attach = on_attach,
  })
end

return {
  setup_jdtls = setup_jdtls,
}
