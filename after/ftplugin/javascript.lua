local M = {}
local u = require("config.functions.utils")

-- Work-specific
M.jump_to_source_file = function()
  local fp = u.copy_relative_filepath(true)
  -- Verifica a extensão do arquivo e determina o caminho correspondente
  if string.match(fp, ".test.js$") then
    local file_path = fp:gsub(".test.js", ".vue"):gsub("test/specs", "src")
    vim.cmd(string.format("e %s", file_path))
  elseif string.match(fp, ".test.jsx$") then
    local file_path = fp:gsub(".test.jsx", ".jsx"):gsub("test/specs", "src")
    vim.cmd(string.format("e %s", file_path))
  elseif string.match(fp, ".test.ts$") then
    local file_path = fp:gsub(".test.ts", ".ts"):gsub("test/specs", "src")
    vim.cmd(string.format("e %s", file_path))
  elseif string.match(fp, ".test.tsx$") then
    local file_path = fp:gsub(".test.tsx", ".tsx"):gsub("test/specs", "src")
    vim.cmd(string.format("e %s", file_path))
  end
end

vim.keymap.set("n", "<localleader>tj", M.jump_to_source_file)
vim.keymap.set("n", "<localleader>ta", function()
  u.replace_text_with_file("test_templates")
end)

return M
