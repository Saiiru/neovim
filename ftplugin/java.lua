-- Sobe jdtls por projeto (gradle/maven/git)
local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then return end

local mason = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
local root = require("jdtls.setup").find_root({ "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" })
if not root or root == "" then return end

local launcher = vim.fn.glob(mason .. "/share/jdtls/plugins/org.eclipse.equinox.launcher*.jar", 1)
local config_dir = mason .. "/packages/jdtls/config_linux"
local lombok = vim.fn.filereadable(mason .. "/share/jdtls/lombok.jar") == 1
  and (mason .. "/share/jdtls/lombok.jar")
  or  (mason .. "/packages/jdtls/lombok.jar")
local ws = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fs.basename(root)

-- bundles (debug/test)
local bundles = {}
vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1), "\n"))
vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar", 1), "\n"))

local caps = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then caps = cmp.default_capabilities(caps) end

local function on_attach(client, bufnr)
  local map = function(m, l, r, d) vim.keymap.set(m, l, r, { buffer = bufnr, silent = true, desc = d }) end
  map("n", "<A-CR>", vim.lsp.buf.code_action, "Code Action (Alt+Enter)")
  map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gi", vim.lsp.buf.implementation, "Implementations")
  map("n", "gy", vim.lsp.buf.type_definition, "Type Definition")
  map("n", "K",  vim.lsp.buf.hover, "Hover")

  map("n", "<leader>jo", jdtls.organize_imports, "Java: Organize Imports")
  map("n", "<leader>jr", vim.lsp.buf.rename, "Java: Rename")
  map("n", "<leader>jt", jdtls.test_nearest_method, "Java: Test Nearest")
  map("n", "<leader>jT", jdtls.test_class, "Java: Test Class")
  map("v", "<leader>je", function() jdtls.extract_variable(true) end, "Java: Extract Var")
  map("v", "<leader>jE", function() jdtls.extract_constant(true) end, "Java: Extract Const")
  map("n", "<leader>jM", jdtls.extract_method, "Java: Extract Method")
end

jdtls.setup_dap({ hotcodereplace = "auto" })
require("jdtls.dap").setup_dap_main_class_configs()

jdtls.start_or_attach({
  cmd = vim.tbl_filter(function(x) return x end, {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true", "-Dlog.level=ALL",
    "-Xmx2g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    lombok and ("-javaagent:" .. lombok) or nil,
    "-jar", launcher,
    "-configuration", config_dir,
    "-data", ws,
  }),
  root_dir = root,
  capabilities = caps,
  on_attach = on_attach,
  init_options = { bundles = bundles },
  settings = {
    java = {
      inlayHints = { parameterNames = { enabled = "all" } },
      format = { enabled = false }, -- formata com conform
      saveActions = { organizeImports = true },
      referencesCodeLens = { enabled = true },
      signatureHelp = { enabled = true },
      sources = { organizeImports = { starThreshold = 9999, staticThreshold = 9999 } },
      completion = { filteredTypes = { "com.sun.*", "sun.*", "jdk.*" } },
      configuration = { updateBuildConfiguration = "interactive" },
    },
  },
})

