local M = {}

local function root(bufnr) return require("pde.detect").root(bufnr or 0) end
local function read(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local text = f:read("*a")
  f:close()
  return text
end

function M.profile(bufnr)
  local text = read(root(bufnr) .. "/pde.toml") or ""
  return vim.env.ARDUINO_PROFILE or text:match("active_profile%s*=%s*\"([^\"]+)\"") or text:match("profile%s*=%s*\"([^\"]+)\"") or (read(root(bufnr) .. "/sketch.yaml") or ""):match("default_profile:%s*([%w%._%-]+)")
end

function M.fqbn(bufnr)
  local text = read(root(bufnr) .. "/pde.toml") or ""
  local pde_fqbn = text:match("fqbn%s*=%s*\"([^\"]+)\"")
  if pde_fqbn then return pde_fqbn end
  local sketch = read(root(bufnr) .. "/sketch.yaml") or ""
  return sketch:match("fqbn:%s*([^%s]+)")
end

function M.status_lines(bufnr)
  local r = root(bufnr)
  return {
    "arduino root: " .. r,
    "profile: " .. tostring(M.profile(bufnr)),
    "fqbn: " .. tostring(M.fqbn(bufnr)),
    "sketch.yaml: " .. tostring(vim.uv.fs_stat(r .. "/sketch.yaml") ~= nil),
    "compile_commands.json: " .. tostring(vim.uv.fs_stat(r .. "/compile_commands.json") ~= nil),
  }
end

return M
