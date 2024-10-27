local M = {}

--- Check if current directory is a git repo
---@return boolean
function M.is_git_repo()
  local result = vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

--- Get root directory of git project
---@return string|nil
function M.get_git_root()
  local result = vim.fn.system("git rev-parse --show-toplevel")
  if vim.v.shell_error == 0 then
    return result:gsub("%s+", "") -- Remove espaços em branco
  end
end

--- Get root directory of git project or fallback to current directory
---@return string
function M.get_root_directory()
  if M.is_git_repo() then
    return M.get_git_root() or vim.fn.getcwd()
  end

  return vim.fn.getcwd()
end

return M
