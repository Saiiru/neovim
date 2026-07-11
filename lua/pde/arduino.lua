local M = {}

local function root()
  return require("pde.detect").root()
end

local function read(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local text = f:read("*a")
  f:close()
  return text
end

function M.profile()
  local env = vim.env.ARDUINO_PROFILE
  if env and env ~= "" then return env end
  local text = read(root() .. "/pde.toml") or ""
  local pde_profile = text:match("active_profile%s*=%s*\"([^\"]+)\"") or text:match("profile%s*=%s*\"([^\"]+)\"")
  if pde_profile then return pde_profile end
  local sketch = read(root() .. "/sketch.yaml") or ""
  return sketch:match("default_profile:%s*([%w%._%-]+)")
end

function M.fqbn()
  local text = read(root() .. "/pde.toml") or ""
  local pde_fqbn = text:match("fqbn%s*=%s*\"([^\"]+)\"")
  if pde_fqbn then return pde_fqbn end
  local sketch = read(root() .. "/sketch.yaml") or ""
  local profile = M.profile()
  if not profile then
    return sketch:match("fqbn:%s*([^%s]+)")
  end
  local block = sketch:match(profile .. ":%s*\n(.-)\n%s*[%w%._%-]+:") or sketch:match(profile .. ":%s*\n(.+)") or sketch
  return block:match("fqbn:%s*([^%s]+)")
end

function M.status_lines()
  local r = root()
  return {
    "root: " .. r,
    "profile: " .. tostring(M.profile()),
    "fqbn: " .. tostring(M.fqbn()),
    "sketch.yaml: " .. tostring(vim.uv.fs_stat(r .. "/sketch.yaml") ~= nil),
    "compile_commands.json: " .. tostring(vim.uv.fs_stat(r .. "/compile_commands.json") ~= nil),
  }
end

return M
