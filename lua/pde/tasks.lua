local M = {}

local function read(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local text = f:read("*a")
  f:close()
  return text
end

function M.list(root)
  root = root or require("pde.detect").root(0)
  local text = read(root .. "/.mise.toml")
  if not text then return {} end
  local tasks, seen = {}, {}
  for name in text:gmatch("%[tasks%.([^%]]+)%]") do
    name = name:gsub('^"', ''):gsub('"$', ''):gsub("^'", ""):gsub("'$", "")
    if not seen[name] then
      seen[name] = true
      table.insert(tasks, name)
    end
  end
  table.sort(tasks)
  return tasks
end

function M.resolve(task, root)
  local set = {}
  for _, name in ipairs(M.list(root)) do set[name] = true end
  if set[task] then return task end
  local alt = task:find(":", 1, true) and task:gsub(":", "-") or task:gsub("-", ":")
  if set[alt] then return alt end
end

local function qf(title, output, root, code)
  if code == 0 then
    vim.fn.setqflist({}, " ", { title = title, items = {} })
    return
  end
  local parsed, raw = {}, {}
  for line in (output or ""):gmatch("[^\n]+") do
    local file, lnum, col, text = line:match("^%s*([^:%s][^:]*):(%d+):(%d+):%s*(.*)$")
    if file then
      if not file:match("^/") then file = root .. "/" .. file end
      table.insert(parsed, { filename = file, lnum = tonumber(lnum), col = tonumber(col), text = text })
    else
      table.insert(raw, { text = line })
    end
  end
  vim.fn.setqflist({}, " ", { title = title, items = #parsed > 0 and parsed or raw })
  vim.cmd("copen")
end

function M.run(task, opts)
  opts = opts or {}
  local root = require("pde.detect").root(0)
  local resolved = M.resolve(task, root)
  if not resolved then
    vim.notify("project does not define local mise task: " .. task, vim.log.levels.WARN)
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
  vim.cmd("botright split")
  vim.cmd("terminal cd " .. vim.fn.fnameescape(root) .. " && mise run " .. resolved)
end

return M
