-- ftplugin/java.lua -----------------------------------------
-- Start JDTLS por arquivo Java, com guardas, estilo JetBrains.

local ok_jdtls, jdtls = pcall(require, "jdtls")
if not ok_jdtls then return end

-- Resolve caminho de pacote do Mason de forma resiliente
local function mason_pkg_path(name)
  local ok_reg, registry = pcall(require, "mason-registry")
  if not ok_reg then return nil end
  local ok_pkg, pkg = pcall(registry.get_package, name)
  if not ok_pkg or not pkg then return nil end
  if type(pkg.get_install_path) == "function" then
    return pkg:get_install_path()
  end
  local ms = require("mason.settings")
  return ms.current.install_root_dir .. "/packages/" .. name
end

-- OS -> pasta de config do JDTLS
local function jdtls_config_dir(jdt_home)
  local uname = vim.loop.os_uname().sysname
  local suffix = (uname == "Darwin" and "config_mac") or
                 (uname:match("Windows") and "config_win") or
                 "config_linux"
  return jdt_home .. "/" .. suffix
end

-- Raiz do projeto
local root = require("jdtls.setup").find_root({ "gradlew","mvnw","pom.xml","build.gradle",".git" })
if not root then
  vim.notify("[jdtls] root_dir não encontrado", vim.log.levels.WARN)
  return
end

-- Workspaces por projeto
local ws_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. vim.fn.fnamemodify(root, ":p:h:t")

-- Caminhos principais
local jdt_home = mason_pkg_path("jdtls") or os.getenv("JDTLS_HOME")
if not jdt_home then
  vim.notify("[jdtls] pacote 'jdtls' não instalado no Mason", vim.log.levels.ERROR)
  return
end

local launcher = vim.fn.glob(jdt_home .. "/plugins/org.eclipse.equinox.launcher_*.jar", 1)
if launcher == "" then
  vim.notify("[jdtls] launcher .jar não encontrado em " .. jdt_home .. "/plugins", vim.log.levels.ERROR)
  return
end

local cfg_dir = jdtls_config_dir(jdt_home)

-- Bundles (debug + test)
local bundles = {}
local dbg_home  = mason_pkg_path("java-debug-adapter")
if dbg_home then
  local dbg = vim.fn.glob(dbg_home .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1)
  if dbg ~= "" then table.insert(bundles, dbg) end
end
local test_home = mason_pkg_path("java-test")
if test_home then
  local gl = vim.split(vim.fn.glob(test_home .. "/extension/server/*.jar", 1), "\n")
  for _, p in ipairs(gl) do if p ~= "" then table.insert(bundles, p) end end
end

-- Lombok opcional (se você usa)
local lombok = vim.fn.expand("~/.local/share/java/lombok.jar")
local lombok_args = {}
if vim.fn.filereadable(lombok) == 1 then
  lombok_args = { "-javaagent:"..lombok, "-Xbootclasspath/a:"..lombok }
end

-- Capacidades (cmp)
local caps = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
if ok_cmp and cmp.default_capabilities then
  caps = cmp.default_capabilities(caps)
end

-- CMD do servidor
local cmd = vim.list_extend({
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true", "-Dlog.level=ALL",
}, lombok_args)
vim.list_extend(cmd, {
  "-Xmx2G",
  "--add-modules=ALL-SYSTEM",
  "--add-opens", "java.base/java.util=ALL-UNNAMED",
  "--add-opens", "java.base/java.lang=ALL-UNNAMED",
  "-jar", launcher,
  "-configuration", cfg_dir,
  "-data", ws_dir,
})

-- on_attach com “JetBrains UX”
local function on_attach(client, bufnr)
  -- CodeLens (refs/impl acima do método)
  pcall(vim.lsp.codelens.refresh)
  vim.api.nvim_create_autocmd({ "BufWritePost","CursorHold" }, {
    buffer = bufnr, callback = function() pcall(vim.lsp.codelens.refresh) end
  })

  -- Inlay hints (param names)
  if vim.lsp.inlay_hint then
    local enable = true
    local ok = pcall(function() vim.lsp.inlay_hint(bufnr, enable) end)
    if not ok then pcall(vim.lsp.inlay_hint.enable, enable, { bufnr = bufnr }) end
  end

  -- Atalhos estilo IntelliJ
  local map = function(m, l, r, d) vim.keymap.set(m, l, r, { buffer = bufnr, silent = true, desc = d }) end
  map("n","<A-CR>", vim.lsp.buf.code_action, "Code Action (Alt+Enter)")
  map("n","gd",     vim.lsp.buf.definition,  "Goto Definition")
  map("n","gr",     vim.lsp.buf.references,  "References")
  map("n","gi",     vim.lsp.buf.implementation, "Implementations")
  map("n","gy",     vim.lsp.buf.type_definition,"Type Definition")
  map("n","K",      vim.lsp.buf.hover,       "Hover")
  map("n","<leader>jo", jdtls.organize_imports, "Organize Imports")
  map("n","<leader>jr", vim.lsp.buf.rename,     "Rename")
  map("n","<leader>jt", jdtls.test_nearest_method, "Test Nearest")
  map("n","<leader>jT", jdtls.test_class,        "Test Class")
  map("v","<leader>je", function() jdtls.extract_variable(true) end, "Extract Variable")
  map("v","<leader>jE", function() jdtls.extract_constant(true) end, "Extract Constant")
  map("n","<leader>jM", jdtls.extract_method, "Extract Method")
end

-- Config do servidor
local config = {
  cmd = cmd,
  root_dir = root,
  capabilities = caps,
  on_attach = on_attach,
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      referencesCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      -- organize imports agressivo (evita imports encurtados)
      sources = { organizeImports = { starThreshold = 999, staticStarThreshold = 999 } },
      format = { enabled = false }, -- formatação via Conform
    },
  },
  init_options = { bundles = bundles },
}

jdtls.setup_dap({ hotcodereplace = "auto" })
pcall(function() require("jdtls.dap").setup_dap_main_class_configs() end)
jdtls.start_or_attach(config)
-- -----------------------------------------------------------

