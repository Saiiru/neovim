-- ftplugin/java.lua
local jdtls = require("jdtls")

-- Mason v2: use $MASON como raiz (LazyVim também faz isso)
local mason = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
local launcher = vim.fn.glob(mason .. "/share/jdtls/plugins/org.eclipse.equinox.launcher*.jar", 1)
local config_dir = mason .. "/packages/jdtls/config_linux"   -- ou *_arm conforme a sua arch
local lombok = mason .. "/share/jdtls/lombok.jar"
if vim.fn.filereadable(lombok) == 0 then
  lombok = mason .. "/packages/jdtls/lombok.jar"
end

-- root & workspace
local root = require("jdtls.setup").find_root({ "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" })
if not root or root == "" then
  return
end
local ws_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fs.basename(root)

-- bundles (debug & tests)
local bundles = {}
vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1), "\n"))
vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar", 1), "\n"))

-- capacidades (cmp + inlay hints)
local caps = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then caps = cmp.default_capabilities(caps) end

local on_attach = function(client, bufnr)
  -- estilo JetBrains
  if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
    pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
  end
  pcall(vim.lsp.codelens.refresh)
  vim.api.nvim_create_autocmd({ "BufWritePost", "CursorHold" }, {
    buffer = bufnr,
    callback = function() pcall(vim.lsp.codelens.refresh) end,
  })

  -- atalhos
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

-- DAP
jdtls.setup_dap({ hotcodereplace = "auto" })
require("jdtls.dap").setup_dap_main_class_configs()

-- iniciar
jdtls.start_or_attach({
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true", "-Dlog.level=ALL",
    "-Xmx2g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    (vim.fn.filereadable(lombok) == 1) and ("-javaagent:" .. lombok) or nil,
    "-jar", launcher,
    "-configuration", config_dir,
    "-data", ws_dir,
  },
  root_dir = root,
  capabilities = caps,
  on_attach = on_attach,
  init_options = { bundles = bundles },
  settings = {
    java = {
      referencesCodeLens = { enabled = true },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      saveActions = { organizeImports = true },
      inlayHints = { parameterNames = { enabled = "all" } }, -- estilo JetBrains
      format = { enabled = false }, -- formatar via conform
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "org.mockito.Mockito.*",
        },
        filteredTypes = { "com.sun.*", "io.micrometer.shaded.*", "java.awt.*", "jdk.*", "sun.*" },
        importOrder = { "java", "jakarta", "javax", "com", "org" },
      },
      sources = { organizeImports = { starThreshold = 9999, staticThreshold = 9999 } },
      configuration = { updateBuildConfiguration = "interactive" },
    },
  },
})

