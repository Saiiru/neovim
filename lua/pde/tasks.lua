local M = {}

local function qf_from_output(title, output, root, code)
  if code == 0 then
    vim.fn.setqflist({}, " ", { title = title, items = {} })
    return
  end

  local parsed = {}
  local raw = {}
  for line in (output or ""):gmatch("[^\n]+") do
    local file, lnum, col, text = line:match("^%s*([^:%s][^:]*):(%d+):(%d+):%s*(.*)$")
    if file then
      if not file:match("^/") then file = root .. "/" .. file end
      table.insert(parsed, { filename = file, lnum = tonumber(lnum), col = tonumber(col), text = text })
    else
      local file2, lnum2, text2 = line:match("^%s*([^:%s][^:]*):(%d+):%s*(.*)$")
      if file2 then
        if not file2:match("^/") then file2 = root .. "/" .. file2 end
        table.insert(parsed, { filename = file2, lnum = tonumber(lnum2), text = text2 })
      elseif not line:match("^%s*%[.-%]%s*%$") then
        table.insert(raw, { text = line })
      end
    end
  end
  local items = #parsed > 0 and parsed or raw
  vim.fn.setqflist({}, " ", { title = title, items = items })
  vim.cmd("copen")
end

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
  local tasks = {}
  local seen = {}
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
  local tasks = M.list(root)
  local set = {}
  for _, name in ipairs(tasks) do set[name] = true end
  if set[task] then return task end
  local alt
  if task:find(":", 1, true) then alt = task:gsub(":", "-") else alt = task:gsub("-", ":") end
  if set[alt] then return alt end
  return nil
end

function M.run(task, opts)
  opts = opts or {}
  local detect = require("pde.detect").detect(0)
  local root = detect.root
  local resolved = M.resolve(task, root)
  if not resolved then
    vim.notify("project does not define local mise task: " .. task, vim.log.levels.WARN)
    return
  end

  if opts.quickfix then
    vim.notify("mise run " .. resolved, vim.log.levels.INFO)
    vim.system({ "mise", "run", resolved }, { text = true, cwd = root }, function(result)
      vim.schedule(function()
        local output = (result.stdout or "") .. (result.stderr or "")
        qf_from_output("mise run " .. resolved, output, root, result.code)
        if result.code == 0 then
          vim.notify("mise run " .. resolved .. " OK", vim.log.levels.INFO)
        else
          vim.notify("mise run " .. resolved .. " failed: " .. result.code, vim.log.levels.ERROR)
        end
      end)
    end)
    return
  end

  vim.cmd("botright split")
  vim.cmd("terminal cd " .. vim.fn.fnameescape(root) .. " && mise run " .. resolved)
end

return M
