-- lua/utils/path.lua :: Funções utilitárias para manipulação de paths.

local M = {}

--- Verifica se o diretório atual é um repositório git.
---@return boolean
function M.is_git_repo()
  vim.fn.system "git rev-parse --is-inside-work-tree"
  return vim.v.shell_error == 0
end

--- Retorna o diretório raiz do projeto git.
---@return string|nil
function M.get_git_root()
  return vim.fn.systemlist("git rev-parse --show-toplevel")[1]
end

--- Retorna o diretório raiz do projeto (git) ou o diretório atual.
---@return string|nil
function M.get_root_directory()
  if M.is_git_repo() then
    return M.get_git_root()
  end

  return vim.fn.getcwd()
end

return M
