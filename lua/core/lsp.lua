local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end

local function root(...)
  return vim.fs.root(0, { ... }) or vim.uv.cwd()
end

local function enable(name, cfg)
  if cfg.cmd and cfg.cmd[1] and not executable(cfg.cmd[1]) then
    return
  end
  vim.lsp.config(name, cfg)
  vim.lsp.enable(name)
end

enable("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = function()
    return root(".luarc.json", ".git")
  end,
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

enable("basedpyright", {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_dir = function()
    return root("pyproject.toml", "setup.py", "requirements.txt", ".git")
  end,
})

enable("ruff", {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_dir = function()
    return root("pyproject.toml", "ruff.toml", ".git")
  end,
})

enable("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = function()
    return root("package.json", "tsconfig.json", "jsconfig.json", ".git")
  end,
})

enable("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork" },
  root_dir = function()
    return root("go.mod", "go.work", ".git")
  end,
})

enable("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_dir = function()
    return root("Cargo.toml", ".git")
  end,
})

enable("clangd", {
  cmd = { "clangd", "--background-index" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_dir = function()
    return root("compile_commands.json", "compile_flags.txt", ".git")
  end,
})

local ok_arduino, arduino = pcall(require, "pde.arduino")
local fqbn = ok_arduino and arduino.fqbn() or nil
if fqbn and executable("arduino-language-server") and executable("arduino-cli") and executable("clangd") then
  enable("arduino_language_server", {
    cmd = { "arduino-language-server", "-cli", "arduino-cli", "-clangd", "clangd", "-fqbn", fqbn },
    filetypes = { "cpp" },
    root_dir = function()
      return root("sketch.yaml", "*.ino", ".git")
    end,
  })
end
