-- lua/langs/init.lua
local M = {}
function M.setup()
  -- carrega módulos por demanda; java tem autocmd próprio
  pcall(require, "langs.typescript")
  pcall(require, "langs.cpp")
end
return M