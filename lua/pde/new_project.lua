local M = {}

local uv = vim.uv or vim.loop

local function stat(path)
  return path and uv.fs_stat(path)
end

local function mkdirp(path)
  vim.fn.mkdir(path, "p")
end

local function is_empty_dir(path)
  local handle = uv.fs_scandir(path)
  if not handle then return true end
  return uv.fs_scandir_next(handle) == nil
end

local function safe_relative_path(path)
  if type(path) ~= "string" or path == "" then return false end
  if path:sub(1, 1) == "/" then return false end
  for part in path:gmatch("[^/]+") do
    if part == ".." then return false end
  end
  return true
end

local function dirname(path)
  return vim.fn.fnamemodify(path, ":h")
end

local function write(path, content, force)
  if stat(path) and not force then return false, "exists: " .. path end
  mkdirp(dirname(path))
  local f, err = io.open(path, "w")
  if not f then return false, err end
  f:write(content)
  f:close()
  return true
end

local function chmod_exec(path)
  if path:match("/mise/tasks/[^/]+$") then pcall(uv.fs_chmod, path, 493) end -- 0755
end

function M.create(template_name, root, opts)
  opts = opts or {}
  if not template_name or template_name == "" then return false, "missing template" end
  if not root or root == "" then return false, "missing path" end

  local spec, canonical = require("pde.templates").get(template_name)
  if not spec then return false, "unknown template: " .. template_name end
  if root:sub(1, 1) == "~" then root = vim.fn.expand(root) end
  if root:sub(1, 1) ~= "/" then root = vim.fn.getcwd() .. "/" .. root end
  root = vim.fs.normalize(root)
  root = root:gsub("/$", "")

  if stat(root) and not opts.force and not is_empty_dir(root) then
    return false, "target is not empty: " .. root
  end

  mkdirp(root)
  local written = {}
  for rel, content in pairs(spec.files) do
    if not safe_relative_path(rel) then return false, "unsafe template path: " .. tostring(rel) end
    local path = root .. "/" .. rel
    local ok, err = write(path, content, opts.force)
    if not ok then return false, err end
    chmod_exec(path)
    table.insert(written, rel)
  end
  table.sort(written)

  if opts.open ~= false then
    local open_file = root .. "/README.md"
    if stat(open_file) then vim.cmd.edit(vim.fn.fnameescape(open_file)) end
  end

  return true, { template = canonical, root = root, files = written }
end

function M.complete(arglead)
  local out = {}
  for _, name in ipairs(require("pde.templates").names()) do
    if name:find(arglead or "", 1, true) == 1 then table.insert(out, name) end
  end
  return out
end

return M
