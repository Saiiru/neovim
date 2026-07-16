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

local function toml_scalar(text, key)
  return unquote((text or ""):match("\n?%s*" .. key .. "%s*=%s*([^\n#]+)"))
end

local function yaml_profile_block(text, profile)
  if not text or not profile then return nil end
  local escaped = vim.pesc(profile)
  local padded = "\n" .. text .. "\n__END__:\n"
  return padded:match("\n%s*" .. escaped .. ":%s*\n(.-)\n%s*[%w%._%-]+:%s*\n")
end

local function toml_profile_block(text, profile)
  if not text or not profile then return nil end
  local escaped = vim.pesc(profile)
  local padded = "\n" .. text .. "\n[__END__]\n"
  return padded:match("\n%[profiles%." .. escaped .. "%]%s*\n(.-)\n%[")
    or padded:match("\n%[profiles%.\"" .. escaped .. "\"%]%s*\n(.-)\n%[")
    or padded:match("\n%[profiles%.'" .. escaped .. "'%]%s*\n(.-)\n%[")
end

function M.profile(bufnr)
  local r = root(bufnr)
  local pde = read(r .. "/pde.toml") or ""
  local sketch = read(r .. "/sketch.yaml") or ""
  return vim.env.ARDUINO_PROFILE
    or toml_scalar(pde, "active_profile")
    or toml_scalar(pde, "profile")
    or yaml_scalar(sketch, "default_profile")
    or yaml_scalar(sketch, "profile")
end

local function pde_profile_value(bufnr, key)
  local r = root(bufnr)
  local pde = read(r .. "/pde.toml") or ""
  local profile = M.profile(bufnr)
  local block = toml_profile_block(pde, profile)
  return toml_scalar(block or "", key) or toml_scalar(pde, key)
end

local function sketch_profile_value(bufnr, key)
  local r = root(bufnr)
  local sketch = read(r .. "/sketch.yaml") or ""
  local profile = M.profile(bufnr)
  local block = yaml_profile_block(sketch, profile)
  return yaml_scalar(block or "", key) or yaml_scalar(sketch, key)
end

function M.fqbn(bufnr)
  return pde_profile_value(bufnr, "fqbn") or sketch_profile_value(bufnr, "fqbn")
end

function M.port(bufnr)
  return pde_profile_value(bufnr, "port") or sketch_profile_value(bufnr, "port") or vim.env.ARDUINO_PORT
end

function M.baud(bufnr)
  return pde_profile_value(bufnr, "baud") or pde_profile_value(bufnr, "baudrate") or sketch_profile_value(bufnr, "baud") or sketch_profile_value(bufnr, "baudrate")
end

function M.compile_db(bufnr)
  local r = root(bufnr)
  local configured = pde_profile_value(bufnr, "compile_db") or pde_profile_value(bufnr, "compile_commands") or sketch_profile_value(bufnr, "compile_db")
  local candidates = {}
  if configured then table.insert(candidates, configured:match("^/") and configured or (r .. "/" .. configured)) end
  table.insert(candidates, r .. "/compile_commands.json")
  table.insert(candidates, r .. "/build/compile_commands.json")
  table.insert(candidates, r .. "/.pio/build/compile_commands.json")
  for _, path in ipairs(candidates) do
    if vim.uv.fs_stat(path) then return path end
  end
  return configured or "missing"
end

function M.status_lines(bufnr)
  local r = root(bufnr)
  local compile_db = M.compile_db(bufnr)
  return {
    "arduino root: " .. r,
    "profile: " .. tostring(M.profile(bufnr)),
    "fqbn: " .. tostring(M.fqbn(bufnr)),
    "port: " .. tostring(M.port(bufnr)),
    "baud: " .. tostring(M.baud(bufnr)),
    "sketch.yaml: " .. tostring(vim.uv.fs_stat(r .. "/sketch.yaml") ~= nil),
    "platformio.ini: " .. tostring(vim.uv.fs_stat(r .. "/platformio.ini") ~= nil),
    "pde.toml: " .. tostring(vim.uv.fs_stat(r .. "/pde.toml") ~= nil),
    "compile_commands.json: " .. tostring(compile_db ~= "missing"),
    "compile db path: " .. tostring(compile_db),
  }
end

return M
