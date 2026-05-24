local M = {}

local state_dir = vim.fn.stdpath("state") .. "/sairu"
local state_file = state_dir .. "/autoformat"
local cached

local function normalize(value)
  if value == nil then
    return nil
  end

  if type(value) == "boolean" then
    return value
  end

  if type(value) == "number" then
    return value ~= 0
  end

  if type(value) == "string" then
    local lowered = value:lower()
    if lowered == "1" or lowered == "true" or lowered == "on" or lowered == "yes" then
      return true
    end
    if lowered == "0" or lowered == "false" or lowered == "off" or lowered == "no" then
      return false
    end
  end

  return nil
end

local function load_state()
  if cached ~= nil then
    return cached
  end

  local from_global = normalize(vim.g.sairu_autoformat_enabled)
  if from_global ~= nil then
    cached = from_global
    return cached
  end

  local ok, lines = pcall(vim.fn.readfile, state_file)
  if ok and type(lines) == "table" and #lines > 0 then
    local from_file = normalize(lines[1])
    if from_file ~= nil then
      cached = from_file
      return cached
    end
  end

  cached = true
  return cached
end

local function save_state(enabled)
  vim.fn.mkdir(state_dir, "p")
  vim.fn.writefile({ enabled and "1" or "0" }, state_file)
  vim.g.sairu_autoformat_enabled = enabled and true or false
end

function M.enabled()
  return load_state()
end

function M.set(enabled)
  cached = enabled and true or false
  save_state(cached)
  return cached
end

function M.toggle()
  local enabled = not load_state()
  M.set(enabled)
  vim.notify(
    enabled and "Autoformat: enabled" or "Autoformat: disabled",
    vim.log.levels.INFO,
    { title = "Conform" }
  )
  return enabled
end

function M.status()
  return load_state() and "FMT:on" or "FMT:off"
end

function M.setup()
  vim.g.sairu_autoformat_enabled = load_state()
end

M.setup()

return M
