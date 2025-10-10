-- Configuração específica para Java, focada em projetos (Gradle/Maven).
-- O jdtls é iniciado por buffer, garantindo que cada projeto tenha sua própria instância.
local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then return end

-- Caminho do Mason para encontrar os artefatos do jdtls.
local mason = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
-- Encontra a raiz do projeto baseando-se em marcadores comuns do ecossistema Java.
local root = require("jdtls.setup").find_root({ "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" })
if not root or root == "" then return end

-- Localiza o launcher do Eclipse e o diretório de configuração do jdtls no Mason.
local launcher = vim.fn.glob(mason .. "/share/jdtls/plugins/org.eclipse.equinox.launcher*.jar", 1)
local config_dir = mason .. "/packages/jdtls/config_linux"
-- Verifica a presença do Lombok e define o caminho para o agente.
local lombok = vim.fn.filereadable(mason .. "/share/jdtls/lombok.jar") == 1
  and (mason .. "/share/jdtls/lombok.jar")
  or  (mason .. "/packages/jdtls/lombok.jar")
-- Define um workspace separado para cada projeto, evitando conflitos.
local ws = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fs.basename(root)

-- Agrega os bundles de debug e teste para o jdtls.
local bundles = {}
vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1), "\n"))
vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar", 1), "\n"))

-- Adiciona as capabilities do nvim-cmp para autocompletion.
local caps = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then caps = cmp.default_capabilities(caps) end

-- Função on_attach para definir keymaps específicos do LSP para Java.
local function on_attach(client, bufnr)
  local map = function(m, l, r, d) vim.keymap.set(m, l, r, { buffer = bufnr, silent = true, desc = d }) end
  map("n", "<A-CR>", vim.lsp.buf.code_action, "Code Action (Alt+Enter)")
  map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gi", vim.lsp.buf.implementation, "Implementations")
  map("n", "gy", vim.lsp.buf.type_definition, "Type Definition")
  map("n", "K",  vim.lsp.buf.hover, "Hover")

  -- Keymaps específicos do jdtls para refatoração e testes.
  map("n", "<leader>jo", jdtls.organize_imports, "Java: Organize Imports")
  map("n", "<leader>jr", vim.lsp.buf.rename, "Java: Rename")
  map("n", "<leader>jt", jdtls.test_nearest_method, "Java: Test Nearest")
  map("n", "<leader>jT", jdtls.test_class, "Java: Test Class")
  map("v", "<leader>je", function() jdtls.extract_variable(true) end, "Java: Extract Var")
  map("v", "<leader>jE", function() jdtls.extract_constant(true) end, "Java: Extract Const")
  map("n", "<leader>jM", jdtls.extract_method, "Java: Extract Method")
end

-- Configura o DAP (Debug Adapter Protocol) para Java.
jdtls.setup_dap({ hotcodereplace = "auto" })
require("jdtls.dap").setup_dap_main_class_configs()

-- Inicia o jdtls com as configurações e capabilities definidas.
jdtls.start_or_attach({
  -- Comando de inicialização do servidor, com argumentos para performance e features.
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
  -- Configurações específicas do jdtls para inlay hints, formatação, etc.
  settings = {
    java = {
      inlayHints = { parameterNames = { enabled = "all" } },
      format = { enabled = false }, -- Desabilitado para usar o conform.nvim
      saveActions = { organizeImports = true },
      referencesCodeLens = { enabled = true },
      signatureHelp = { enabled = true },
      sources = { organizeImports = { starThreshold = 9999, staticThreshold = 9999 } },
      completion = { filteredTypes = { "com.sun.*", "sun.*", "jdk.*" } },
      configuration = { updateBuildConfiguration = "interactive" },
    },
  },
})

