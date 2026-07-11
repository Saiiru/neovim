local M = {}

local function root(bufnr) return require("pde.detect").root(bufnr or 0) end

local function read(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local text = f:read("*a")
  f:close()
  return text
end

local function trim(s)
  return s and s:gsub("^%s+", ""):gsub("%s+$", "") or nil
end

local function unquote(s)
  s = trim(s)
  if not s then return nil end
  return s:gsub('^"', ''):gsub('"$', ''):gsub("^'", ""):gsub("'$", "")
end

local function yaml_scalar(text, key)
  return unquote((text or ""):match("\n?%s*" .. key .. ":%s*([^\n#]+)"))
end

local function profile_block(text, profile)
  if not text or not profile then return nil end
  local escaped = vim.pesc(profile)
  local padded = "\n" .. text .. "\n__END__:\n"
  return padded:match("\n%s*" .. escaped .. ":%s*\n(.-)\n%s*[%w%._%-]+:%s*\n")
end

function M.profile(bufnr)
  local r = root(bufnr)
  local pde = read(r .. "/pde.toml") or ""
  local sketch = read(r .. "/sketch.yaml") or ""
  return vim.env.ARDUINO_PROFILE
    or unquote(pde:match("active_profile%s*=%s*([^\n#]+)"))
    or unquote(pde:match("profile%s*=%s*([^\n#]+)"))
    or yaml_scalar(sketch, "default_profile")
    or yaml_scalar(sketch, "profile")
end

function M.fqbn(bufnr)
  local r = root(bufnr)
  local pde = read(r .. "/pde.toml") or ""
  local pde_fqbn = unquote(pde:match("fqbn%s*=%s*([^\n#]+)"))
  if pde_fqbn then return pde_fqbn end

  local sketch = read(r .. "/sketch.yaml") or ""
  local profile = M.profile(bufnr)
  local block = profile_block(sketch, profile)
  return yaml_scalar(block or "", "fqbn") or yaml_scalar(sketch, "fqbn")
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
