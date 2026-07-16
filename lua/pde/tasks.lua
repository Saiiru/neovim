local M = {}

local uv = vim.uv or vim.loop

local function read(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local text = f:read("*a")
  f:close()
  return text
end

local function stat(path)
  return path and uv.fs_stat(path)
end

local function add_task(tasks, seen, name, source)
  if not name or name == "" or seen[name] then return end
  seen[name] = true
  table.insert(tasks, { name = name, source = source or "local" })
end

local function strip_quotes(name)
  return (name or ""):gsub('^"', ''):gsub('"$', ''):gsub("^'", ""):gsub("'$", "")
end

local function toml_tasks(root, tasks, seen)
  local path = root .. "/.mise.toml"
  local text = read(path)
  if not text then return end
  for name in text:gmatch("%[tasks%.([^%]]+)%]") do
    add_task(tasks, seen, strip_quotes(name), ".mise.toml")
  end
end

local function file_tasks(root, tasks, seen)
  local dir = root .. "/mise/tasks"
  local handle = uv.fs_scandir(dir)
  if not handle then return end
  while true do
    local name, kind = uv.fs_scandir_next(handle)
    if not name then break end
    if kind == "file" or kind == "link" then
      add_task(tasks, seen, name, "mise/tasks/" .. name)
    end
  end
end

function M.entries(root)
  root = root or require("pde.detect").root(0)
  local tasks, seen = {}, {}
  toml_tasks(root, tasks, seen)
  file_tasks(root, tasks, seen)
  table.sort(tasks, function(a, b) return a.name < b.name end)
  return tasks
end

function M.list(root)
  local names = {}
  for _, task in ipairs(M.entries(root)) do
    table.insert(names, task.name)
  end
  return names
end

function M.has_local_tasks(root)
  root = root or require("pde.detect").root(0)
  return stat(root .. "/.mise.toml") ~= nil or stat(root .. "/mise/tasks") ~= nil
end

function M.resolve(task, root)
  root = root or require("pde.detect").root(0)
  local set = {}
  for _, name in ipairs(M.list(root)) do set[name] = true end
  if set[task] then return task end

  local alt = task:find(":", 1, true) and task:gsub(":", "-") or task:gsub("-", ":")
  if set[alt] then return alt end
  return nil
end

local function parse_qf_line(line, root)
  local file, lnum, col, text = line:match("^%s*([^:%s][^:]*):(%d+):(%d+):%s*(.*)$")
  if not file then
    file, lnum, text = line:match("^%s*([^:%s][^:]*):(%d+):%s*(.*)$")
  end
  if not file then return nil end
  if not file:match("^/") then file = root .. "/" .. file end
  return {
    filename = file,
    lnum = tonumber(lnum) or 1,
    col = tonumber(col) or 1,
    text = text ~= "" and text or line,
  }
end

local function qf(title, output, root, code)
  if code == 0 then
    vim.fn.setqflist({}, " ", { title = title, items = {} })
    return
  end

  local parsed, raw = {}, {}
  for line in (output or ""):gmatch("[^\n]+") do
    local item = parse_qf_line(line, root)
    if item then table.insert(parsed, item) else table.insert(raw, { text = line }) end
  end
  vim.fn.setqflist({}, " ", { title = title, items = #parsed > 0 and parsed or raw })
  vim.cmd("copen")
end

local function terminal_run(root, resolved)
  vim.cmd("botright split")
  local cmd = string.format("cd %s && mise run %s", vim.fn.shellescape(root), vim.fn.shellescape(resolved))
  vim.cmd("terminal " .. cmd)
end

function M.missing_message(task)
  return "project does not define local mise task: " .. task
end

function M.run(task, opts)
  opts = opts or {}
  local root = require("pde.detect").root(0)
  local resolved = M.resolve(task, root)
  if not resolved then
    vim.notify(M.missing_message(task), vim.log.levels.WARN)
    return
  end

  if opts.quickfix then
    vim.notify("mise run " .. resolved, vim.log.levels.INFO)
    vim.system({ "mise", "run", resolved }, { text = true, cwd = root }, function(result)
      vim.schedule(function()
        qf("mise run " .. resolved, (result.stdout or "") .. (result.stderr or ""), root, result.code)
        vim.notify("mise run " .. resolved .. (result.code == 0 and " OK" or (" failed: " .. result.code)), result.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR)
      end)
    end)
    return
  end

  terminal_run(root, resolved)
end

return M
