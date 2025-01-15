local M = {}

local function is_win()
  return vim.loop.os_uname().version:find("Windows") ~= nil
end

M.spec = { "lsp", { ".git", "lua" }, "cwd" }
M.detectors = {}

-- Normalize the path for cross-platform consistency
function M.norm(path)
  if path:sub(1, 1) == "~" then
    local home = vim.uv.os_homedir():gsub("\\$", "") -- Handle Windows home dir correctly
    path = home .. path:sub(2)
  end
  return path:gsub("\\", "/"):gsub("/+", "/"):gsub("/$", "")
end

function M.detectors.cwd()
  return { M.norm(vim.uv.cwd()) }
end

-- LSP detection based on buffer's root path
function M.detectors.lsp(buf)
  local bufpath = M.bufpath(buf)
  if not bufpath then
    return {}
  end

  local roots = {}
  local clients = require("utils.lsp").get_clients({ bufnr = buf })

  -- Filter out ignored LSP clients
  clients = vim.tbl_filter(function(client)
    return not vim.tbl_contains(vim.g.root_lsp_ignore or {}, client.name)
  end, clients)

  -- Collect roots from LSP workspace folders and root directories
  for _, client in pairs(clients) do
    local workspace = client.config.workspace_folders
    for _, ws in pairs(workspace or {}) do
      table.insert(roots, vim.uri_to_fname(ws.uri))
    end
    if client.root_dir then
      table.insert(roots, client.root_dir)
    end
  end

  -- Filter paths based on whether they match the buffer's path
  return vim.tbl_filter(function(path)
    path = M.norm(path)
    return bufpath:find(path, 1, true) == 1
  end, roots)
end

-- Pattern-based detection for buffer paths
function M.detectors.pattern(buf, patterns)
  local path = M.bufpath(buf) or vim.uv.cwd()
  patterns = type(patterns) == "string" and { patterns } or patterns

  local pattern = vim.fs.find(function(name)
    for _, p in ipairs(patterns) do
      if name == p or (p:sub(1, 1) == "*" and name:match(vim.pesc(p:sub(2)) .. "$")) then
        return true
      end
    end
    return false
  end, { path = path, upward = true })[1]

  return pattern and { vim.fs.dirname(pattern) } or {}
end

function M.bufpath(buf)
  return M.realpath(vim.api.nvim_buf_get_name(buf or 0))
end

function M.cwd()
  return M.realpath(vim.uv.cwd()) or ""
end

function M.realpath(path)
  if not path then
    return nil
  end
  return M.norm(vim.uv.fs_realpath(path) or path)
end

-- Resolve function for spec detectors
function M.resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  elseif type(spec) == "function" then
    return spec
  end
  return function(buf)
    return M.detectors.pattern(buf, spec)
  end
end

function M.detect(opts)
  opts = opts or {}
  opts.spec = opts.spec or vim.g.root_spec or M.spec
  opts.buf = opts.buf or vim.api.nvim_get_current_buf()

  local ret = {}
  for _, spec in ipairs(opts.spec) do
    local paths = M.resolve(spec)(opts.buf) or {}
    local roots = {}

    for _, p in ipairs(paths) do
      local pp = M.realpath(p)
      if pp and not vim.tbl_contains(roots, pp) then
        table.insert(roots, pp)
      end
    end

    -- Sort roots by length (longest path first)
    table.sort(roots, function(a, b)
      return #a > #b
    end)

    if #roots > 0 then
      table.insert(ret, { spec = spec, paths = roots })
      if opts.all == false then
        break
      end
    end
  end
  return ret
end

---@type table<number, string>
M.cache = {}

-- Get root directory from various sources (LSP, git, or default)
function M.get(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  if not M.cache[buf] then
    local roots = M.detect({ all = false, buf = buf })
    M.cache[buf] = roots[1] and roots[1].paths[1] or vim.uv.cwd()
  end

  local ret = M.cache[buf]
  if opts.normalize then
    return ret
  end
  return is_win() and ret:gsub("/", "\\") or ret
end

function M.git()
  local root = M.get()
  local git_root = vim.fs.find(".git", { path = root, upward = true })[1]
  return git_root and vim.fn.fnamemodify(git_root, ":h") or root
end

-- Pretty print the path (useful for visual representation)
function M.pretty_path(opts)
  return "" -- Placeholder, implement as needed
end

return M
