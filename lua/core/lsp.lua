local M = {}

local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end

local function root_for(bufnr, markers)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local start = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()
  return vim.fs.root(start, markers) or start or vim.uv.cwd()
end

local servers = {
  lua = {
    name = "lua_ls",
    cmd = { "lua-language-server" },
    root_markers = { ".luarc.json", ".git" },
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
  },
  python = {
    name = "basedpyright",
    cmd = { "basedpyright-langserver", "--stdio" },
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
  },
  javascript = {
    name = "ts_ls",
    cmd = { "typescript-language-server", "--stdio" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  },
  javascriptreact = "javascript",
  typescript = "javascript",
  typescriptreact = "javascript",
  go = {
    name = "gopls",
    cmd = { "gopls" },
    root_markers = { "go.mod", "go.work", ".git" },
  },
  rust = {
    name = "rust_analyzer",
    cmd = { "rust-analyzer" },
    root_markers = { "Cargo.toml", ".git" },
  },
  c = {
    name = "clangd",
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
  },
  cpp = "c",
}

local function resolve(ft)
  local cfg = servers[ft]
  if type(cfg) == "string" then
    cfg = servers[cfg]
  end
  return cfg
end

local function has_file(root, rel)
  return root and vim.uv.fs_stat(root .. "/" .. rel) ~= nil
end

local function project_declares_typescript(root)
  return has_file(root, "node_modules/typescript/lib/typescript.js")
end

function M.start(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local cfg = resolve(ft)

  if ft == "cpp" then
    local ok_arduino, arduino = pcall(require, "pde.arduino")
    local fqbn = ok_arduino and arduino.fqbn(bufnr) or nil
    if fqbn and executable("arduino-language-server") and executable("arduino-cli") and executable("clangd") then
      vim.lsp.start({
        name = "arduino_language_server",
        cmd = { "arduino-language-server", "-cli", "arduino-cli", "-clangd", "clangd", "-fqbn", fqbn },
        root_dir = root_for(bufnr, { "sketch.yaml", ".git" }),
      }, { bufnr = bufnr })
      return
    end
  end

  if not cfg or not executable(cfg.cmd[1]) then
    return
  end

  local root = root_for(bufnr, cfg.root_markers)
  if cfg.name == "ts_ls" and not project_declares_typescript(root) then
    return
  end

  vim.lsp.start({
    name = cfg.name,
    cmd = cfg.cmd,
    root_dir = root,
    settings = cfg.settings,
  }, { bufnr = bufnr })
end

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TinyPDELsp", { clear = true }),
    pattern = { "lua", "python", "javascript", "javascriptreact", "typescript", "typescriptreact", "go", "rust", "c", "cpp" },
    callback = function(args)
      M.start(args.buf)
    end,
  })
end

M.setup()

return M
