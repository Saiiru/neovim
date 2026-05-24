local M = {}

local root_markers = {
  ".git",
  "mvnw",
  "gradlew",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
}

local preferred_java_home = "/usr/lib/jvm/java-21-openjdk"

local function mason_root()
  return vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")
end

local function java_version(candidate)
  if not candidate or not vim.uv.fs_stat(candidate) then
    return nil
  end

  local result = vim.system({ candidate, "-version" }, { text = true }):wait(2000)
  local output = table.concat({ result.stdout or "", result.stderr or "" }, "\n")
  if output == "" then
    return nil
  end

  return output
end

local function is_java_21(candidate)
  local output = java_version(candidate)
  if not output then
    return false
  end

  return output:match('version%s+"21') ~= nil or output:match('openjdk version%s+"21') ~= nil
end

local function ensure_java_21()
  local candidates = {
    vim.env.JDTLS_JAVA and vim.env.JDTLS_JAVA or nil,
    vim.env.JDTLS_JAVA_HOME and (vim.env.JDTLS_JAVA_HOME .. "/bin/java") or nil,
    vim.env.JAVA_HOME and (vim.env.JAVA_HOME .. "/bin/java") or nil,
    preferred_java_home .. "/bin/java",
    "/usr/lib/jvm/java-21-openjdk/bin/java",
  }

  for _, candidate in ipairs(candidates) do
    if is_java_21(candidate) then
      local java_home = candidate:gsub("/bin/java$", "")
      vim.env.JAVA_HOME = java_home
      vim.env.JDTLS_JAVA_HOME = java_home
      vim.env.JDTLS_JAVA = candidate
      return candidate
    end
  end

  return nil
end

local function java_executable()
  return ensure_java_21()
end

local function java_runtimes()
  local runtimes = {}

  local known = {
    { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk" },
    { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk", default = true },
    { name = "JavaSE-26", path = "/usr/lib/jvm/java-26-openjdk" },
  }

  for _, runtime in ipairs(known) do
    if vim.uv.fs_stat(runtime.path) then
      table.insert(runtimes, runtime)
    end
  end

  return runtimes
end

local function jdtls_paths()
  local package = mason_root() .. "/packages/jdtls"
  local share = mason_root() .. "/share/jdtls"
  local base = vim.uv.fs_stat(package) and package or share

  if not vim.uv.fs_stat(base) then
    return nil
  end

  local launcher = base .. "/plugins/org.eclipse.equinox.launcher.jar"
  if not vim.uv.fs_stat(launcher) then
    launcher = vim.fn.glob(base .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  end

  return {
    bin = mason_root() .. "/bin/jdtls",
    launcher = launcher,
    lombok = base .. "/lombok.jar",
  }
end

local function jdtls_bundles()
  local bundles = {}

  local mason = mason_root()
  local java_debug = mason .. "/share/java-debug-adapter"
  if vim.uv.fs_stat(java_debug) then
    local launcher = vim.fn.glob(java_debug .. "/com.microsoft.java.debug.plugin-*.jar")
    if launcher ~= "" then
      table.insert(bundles, launcher)
    end
  end

  local java_test = mason .. "/share/java-test"
  if vim.uv.fs_stat(java_test) then
    vim.list_extend(bundles, vim.split(vim.fn.glob(java_test .. "/*.jar"), "\n", { trimempty = true }))
  end

  return bundles
end

local function project_root()
  local file = vim.api.nvim_buf_get_name(0)
  local start = file ~= "" and file or vim.fn.getcwd()
  return vim.fs.root(start, root_markers) or vim.fs.dirname(start) or vim.fn.getcwd()
end

local function workspace_dir(root_dir)
  local project = root_dir:gsub("^" .. vim.pesc(vim.env.HOME or ""), "~")
  project = project:gsub("[/\\:%s]+", "_"):gsub("^_+", "")
  return vim.fn.stdpath "data" .. "/jdtls-workspace/" .. project
end

local function java_keymaps(bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  vim.api.nvim_buf_create_user_command(bufnr, "JdtCompile", function(opts)
    require("jdtls").compile(opts.args)
  end, { nargs = "?", complete = "custom,v:lua.require'jdtls'._complete_compile" })
  vim.api.nvim_buf_create_user_command(bufnr, "JdtUpdateConfig", function()
    require("jdtls").update_project_config()
  end, {})
  vim.api.nvim_buf_create_user_command(bufnr, "JdtBytecode", function()
    require("jdtls").javap()
  end, {})
  vim.api.nvim_buf_create_user_command(bufnr, "JdtJshell", function()
    require("jdtls").jshell()
  end, {})

  map("n", "<leader>Jo", function()
    require("jdtls").organize_imports()
  end, "[J]ava Organize Imports")
  map("n", "<leader>Jv", function()
    require("jdtls").extract_variable()
  end, "[J]ava Extract Variable")
  map("v", "<leader>Jv", function()
    require("jdtls").extract_variable(true)
  end, "[J]ava Extract Variable")
  map("n", "<leader>JC", function()
    require("jdtls").extract_constant()
  end, "[J]ava Extract Constant")
  map("v", "<leader>JC", function()
    require("jdtls").extract_constant(true)
  end, "[J]ava Extract Constant")
  map("n", "<leader>Jt", function()
    require("jdtls").test_nearest_method()
  end, "[J]ava Test Method")
  map("v", "<leader>Jt", function()
    require("jdtls").test_nearest_method(true)
  end, "[J]ava Test Method")
  map("n", "<leader>JT", function()
    require("jdtls").test_class()
  end, "[J]ava Test Class")
  map("n", "<leader>Ju", "<Cmd>JdtUpdateConfig<CR>", "[J]ava Update Config")
end

function M.start()
  local ok, jdtls = pcall(require, "jdtls")
  if not ok then
    return
  end

  local java_home_bin = ensure_java_21()
  if not java_home_bin then
    vim.notify("JDTLS requires Java 21. Set JAVA_HOME or JDTLS_JAVA_HOME to a Java 21 install.", vim.log.levels.ERROR)
    return
  end

  local paths = jdtls_paths()
  if not paths or paths.launcher == "" or vim.fn.executable(paths.bin) ~= 1 then
    vim.notify("jdtls is not installed in Mason", vim.log.levels.WARN)
    return
  end

  local root_dir = project_root()
  if not root_dir then
    return
  end

  local lsp = require "config.lsp"
  local capabilities = vim.tbl_deep_extend("force", {}, lsp.capabilities, {
    workspace = { configuration = true },
    textDocument = { completion = { snippetSupport = false } },
  })

  local extended = jdtls.extendedClientCapabilities
  extended.resolveAdditionalTextEditsSupport = true

  local cmd = {
    paths.bin,
    "--java-executable",
    java_home_bin or java_executable(),
    "--jvm-arg=-Dlog.protocol=true",
    "--jvm-arg=-Dlog.level=ALL",
    "--jvm-arg=-Xmx1g",
  }

  if vim.uv.fs_stat(paths.lombok) then
    table.insert(cmd, "--jvm-arg=-javaagent:" .. paths.lombok)
  end

  vim.list_extend(cmd, {
    "-data",
    workspace_dir(root_dir),
  })

  local java_settings = {
    format = { enabled = true },
    eclipse = { downloadSources = true },
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
        "com.sun.*",
        "io.micrometer.shaded.*",
        "java.awt.*",
        "jdk.*",
        "sun.*",
      },
    },
    source = {
      organizeImports = {
        starThreshold = 9999,
        staticThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      hashCodeEquals = { useJava7Objects = true },
      useBlocks = true,
    },
    configuration = {
      updateBuildConfiguration = "interactive",
      runtimes = java_runtimes(),
    },
    referencesCodeLens = { enabled = true },
    implementationsCodeLens = { enabled = true },
    inlayHints = {
      parameterNames = { enabled = "all" },
    },
  }

  local format_profile = vim.fn.stdpath "config" .. "/lang_servers/intellij-java-google-style.xml"
  if vim.uv.fs_stat(format_profile) then
    java_settings.format.settings = {
      url = format_profile,
      profile = "GoogleStyle",
    }
  end

  jdtls.start_or_attach {
    cmd = cmd,
    root_dir = root_dir,
    capabilities = capabilities,
    settings = { java = java_settings },
    init_options = {
      bundles = jdtls_bundles(),
      extendedClientCapabilities = extended,
    },
    on_attach = function(client, bufnr)
      lsp.on_attach(client, bufnr)
      java_keymaps(bufnr)

      require("jdtls.setup").add_commands()
      pcall(vim.lsp.codelens.refresh)

      vim.api.nvim_create_autocmd("BufWritePost", {
        buffer = bufnr,
        pattern = "*.java",
        callback = function()
          pcall(vim.lsp.codelens.refresh)
        end,
      })
    end,
  }
end

return M
