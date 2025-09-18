local M = {}
local root_markers = { "gradlew","mvnw","pom.xml","build.gradle","build.gradle.kts",".git" }
local function root_dir() return vim.fs.root(0, root_markers) or vim.fn.getcwd() end
local function workspace_dir()
  local name = vim.fn.fnamemodify(root_dir(), ":p:h:t")
  local data = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. name
  vim.fn.mkdir(data, "p"); return data
end
local function lombok_arg()
  local c = { vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar", "/usr/share/java/lombok.jar" }
  for _,p in ipairs(c) do if vim.uv.fs_stat(p) then return "-javaagent:"..p end end
end
local function organize_imports()
  vim.lsp.buf.execute_command({ command = "java.edit.organizeImports", arguments = { { uri = vim.uri_from_bufnr(0) } } })
end
function M.start()
  local ok, jdtls = pcall(require, "jdtls"); if not ok then return end
  local shared = require("langs.shared")
  local caps = shared.capabilities()
  local cmd = { vim.fn.stdpath("data").."/mason/bin/jdtls",
    "-configuration", vim.fn.stdpath("cache").."/jdtls/config", "-data", workspace_dir() }
  local lba = lombok_arg(); if lba then table.insert(cmd, 2, lba) end
  local function on_attach(client, bufnr)
    shared.on_attach(client, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls.setup_additional_capabilities({ on_completion_item_selected = true })
    vim.keymap.set("n","<leader>jo", organize_imports, { buffer=bufnr, desc="Java: Organize imports" })
    vim.keymap.set("n","<leader>jt", jdtls.test_nearest_method, { buffer=bufnr, desc="Java Test: nearest" })
    vim.keymap.set("n","<leader>jT", jdtls.test_class, { buffer=bufnr, desc="Java Test: class" })
    vim.keymap.set("n","<leader>jr", jdtls.test_reload, { buffer=bufnr, desc="Java Test: reload" })
    vim.keymap.set({"n","v"},"<leader>je", jdtls.extract_variable, { buffer=bufnr, desc="Java: Extract var" })
    vim.keymap.set("v","<leader>jm", jdtls.extract_method, { buffer=bufnr, desc="Java: Extract method" })
    vim.keymap.set("n","<leader>jc", jdtls.extract_constant, { buffer=bufnr, desc="Java: Extract const" })
    pcall(vim.lsp.codelens.refresh)
    vim.api.nvim_create_autocmd({ "BufEnter","InsertLeave" }, { buffer=bufnr, callback = vim.lsp.codelens.refresh })
  end
  local settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = { favoriteStaticMembers = { "org.junit.Assert.*","org.mockito.Mockito.*" } },
      codeGeneration = { toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" } },
      configuration = { updateBuildConfiguration = "interactive" },
      format = { enabled = false },
      references = { includeDecompiledSources = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
    },
  }
  require("jdtls").start_or_attach({
    cmd = cmd, root_dir = root_dir(), settings = settings,
    on_attach = on_attach, capabilities = caps,
    init_options = require("jdtls").extendedClientCapabilities,
    flags = { allow_incremental_sync = true },
  })
end
vim.api.nvim_create_autocmd("FileType", { pattern = "java", callback = function() require("langs.java").start() end })
return M