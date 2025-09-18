-- lua/langs/java.lua
local M = {}

-- Descobre root do projeto
local root_markers = { "gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts", ".git" }
local function root_dir()
  return vim.fs.root(0, root_markers) or vim.fn.getcwd()
end

-- Workspace por projeto (como IntelliJ)
local function workspace_dir()
  local name = vim.fn.fnamemodify(root_dir(), ":p:h:t")
  local data = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. name
  vim.fn.mkdir(data, "p")
  return data
end

-- Opcional: Lombok se existir
local function lombok_arg()
  local candidates = {
    vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar",
    "/usr/share/java/lombok.jar",
  }
  for _, p in ipairs(candidates) do if vim.uv.fs_stat(p) then return "-javaagent:" .. p end end
  return nil
end

-- Code actions helpers
local function organize_imports() vim.lsp.buf.execute_command({ command = "java.edit.organizeImports", arguments = { { uri = vim.uri_from_bufnr(0) } } }) end

function M.start()
  local jdtls_ok, jdtls = pcall(require, "jdtls")
  if not jdtls_ok then return end

  local shared = require("langs.shared")
  local caps = shared.capabilities()

  local cmd = {
    vim.fn.stdpath("data") .. "/mason/bin/jdtls",
    "-configuration", vim.fn.stdpath("cache") .. "/jdtls/config",
    "-data", workspace_dir(),
  }
  local lba = lombok_arg(); if lba then table.insert(cmd, 2, lba) end

  local on_attach = function(client, bufnr)
    shared.on_attach(client, bufnr)

    -- JDT extras
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls.setup_additional_capabilities({ on_completion_item_selected = true })

    -- Codelens, organize imports, test helpers
    vim.keymap.set("n", "<leader>jo", organize_imports, { buffer = bufnr, desc = "Java: Organize imports" })
    vim.keymap.set("n", "<leader>jt", jdtls.test_nearest_method, { buffer = bufnr, desc = "Java Test: nearest" })
    vim.keymap.set("n", "<leader>jT", jdtls.test_class,          { buffer = bufnr, desc = "Java Test: class" })
    vim.keymap.set("n", "<leader>jr", jdtls.test_reload,         { buffer = bufnr, desc = "Java Test: reload" })
    vim.keymap.set("n", "<leader>je", jdtls.extract_variable,    { buffer = bufnr, desc = "Java: Extract var" })
    vim.keymap.set("v", "<leader>je", jdtls.extract_variable,    { buffer = bufnr, desc = "Java: Extract var" })
    vim.keymap.set("v", "<leader>jm", jdtls.extract_method,      { buffer = bufnr, desc = "Java: Extract method" })
    vim.keymap.set("n", "<leader>jc", jdtls.extract_constant,    { buffer = bufnr, desc = "Java: Extract const" })

    -- CodeLens como no IntelliJ (Run/Debug acima do método)
    pcall(vim.lsp.codelens.refresh)
    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, { buffer = bufnr, callback = vim.lsp.codelens.refresh })
  end

  local settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" }, -- decomp
      completion = { favoriteStaticMembers = { "org.junit.Assert.*", "org.mockito.Mockito.*" } },
      codeGeneration = { toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" } },
      configuration = { updateBuildConfiguration = "interactive" },
      format = { enabled = false }, -- usamos Conform (google-java-format) manual
      references = { includeDecompiledSources = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
    },
  }

  jdtls.start_or_attach({
    cmd = cmd,
    root_dir = root_dir(),
    settings = settings,
    on_attach = on_attach,
    capabilities = caps,
    init_options = jdtls.extendedClientCapabilities,
    flags = { allow_incremental_sync = true },
  })
end

-- Auto start for java buffers
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "java" },
  callback = function()
    require("langs.java").start()
  end,
})

return M