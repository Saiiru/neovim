local Path = require("utils.path")

-- Centralized configuration file checks
local function check_config_file_exists(filename)
  local current_dir = vim.fn.getcwd()
  local config_file = current_dir .. "/" .. filename

  if vim.fn.filereadable(config_file) == 1 then
    return current_dir
  end

  local git_root = Path.get_git_root()
  if Path.is_git_repo() and git_root ~= current_dir then
    config_file = git_root .. "/" .. filename
    if vim.fn.filereadable(config_file) == 1 then
      return git_root
    end
  end
  return nil
end

local kind_filter = {
  default = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Package",
    "Property",
    "Struct",
    "Trait",
  },
  lua = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Property",
    "Struct",
    "Trait",
  },
}

local M = {
  kind_filter = kind_filter,
}

-- Default LSP keymaps
function M.get_default_keymaps()
  return {
    { keys = "<leader>ca", func = vim.lsp.buf.code_action, desc = "Code Actions" },
    { keys = "<leader>.", func = vim.lsp.buf.code_action, desc = "Code Actions" },
    { keys = "<leader>cA", func = M.action.source, desc = "Source Actions" },
    { keys = "<leader>cr", func = vim.lsp.buf.rename, desc = "Code Rename" },
    { keys = "<leader>cf", func = vim.lsp.buf.format, desc = "Code Format" },
    { keys = "<leader>k", func = vim.lsp.buf.hover, desc = "Documentation", has = "hoverProvider" },
    { keys = "K", func = vim.lsp.buf.hover, desc = "Documentation", has = "hoverProvider" },
    { keys = "gd", func = vim.lsp.buf.definition, desc = "Goto Definition", has = "definitionProvider" },
    { keys = "gD", func = vim.lsp.buf.declaration, desc = "Goto Declaration", has = "declarationProvider" },
    { keys = "gr", func = vim.lsp.buf.references, desc = "Goto References", has = "referencesProvider", nowait = true },
    { keys = "gi", func = vim.lsp.buf.implementation, desc = "Goto Implementation", has = "implementationProvider" },
    { keys = "gy", func = vim.lsp.buf.type_definition, desc = "Goto Type Definition", has = "typeDefinitionProvider" },
  }
end

-- Get kind filter based on filetype
function M.get_kind_filter(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  if M.kind_filter == false or M.kind_filter[ft] == false then
    return
  end
  return M.kind_filter[ft] or M.kind_filter.default
end

-- Setup LSP client by name
M.start_lsp_client_by_name = function(name, opts)
  local clients = M.get_clients()
  for _, client in ipairs(clients) do
    if client.name == name then
      vim.notify("LSP client: " .. name .. " is already running", vim.log.levels.INFO, { title = "LSP" })
      return
    end
  end
  require("lspconfig")[name].setup(opts)
  vim.notify("Started LSP client: " .. name, vim.log.levels.INFO, { title = "LSP" })
end

-- Stop LSP client by name
M.stop_lsp_client_by_name = function(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == name then
      vim.lsp.stop_client(client.id, true)
      vim.notify("Stopped LSP client: " .. name)
      return
    end
  end
  vim.notify("No active LSP client with name: " .. name)
end

-- Check if biome config exists
M.biome_config_exists = function()
  return check_config_file_exists("biome.json") ~= nil
end

-- Check if dprint config exists
M.dprint_config_exist = function()
  return check_config_file_exists("dprint.json") ~= nil
end

-- Check if deno config exists
M.deno_config_exist = function()
  return check_config_file_exists("deno.json") or check_config_file_exists("deno.jsonc") ~= nil
end

-- Check if eslint config exists
M.eslint_config_exists = function()
  local config_files = {
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    ".eslintrc",
    "eslint.config.js",
  }
  for _, file in ipairs(config_files) do
    if check_config_file_exists(file) then
      return true
    end
  end
  return false
end

-- Register keymaps for LSP clients
function M.register_keymaps(name, keymaps, prefix)
  M.on_attach(function(client, bufnr)
    if client.name == name then
      for _, keys in ipairs(keymaps) do
        vim.keymap.set("n", keys[1], keys[2], { buffer = bufnr, desc = prefix .. ": " .. keys.desc })
      end
    end
  end)
end

-- Get active LSP clients
function M.get_clients(opts)
  return vim.tbl_filter(opts and opts.filter or function()
    return true
  end, vim.lsp.get_clients(opts) or vim.lsp.get_active_clients(opts))
end

-- Handle LSP attach event
function M.on_attach(on_attach, name)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

-- Method support handling
function M.on_supports_method(method, fn)
  M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspSupportsMethod",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer
      if client and method == args.data.method then
        return fn(client, buffer)
      end
    end,
  })
end

M._supports_method = {}

function M.setup()
  local register_capability = vim.lsp.handlers["client/registerCapability"]
  vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    local ret = register_capability(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for buffer in pairs(client.attached_buffers) do
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspDynamicCapability",
          data = { client_id = client.id, buffer = buffer },
        })
      end
    end
    return ret
  end

  M.on_attach(M._check_methods)
  M.on_dynamic_capability(M._check_methods)
end

return M
