local u = require("config.functions.utils")
local M = {}

-- Função para configurar mapeamentos de teclas
local function setup_mappings()
  -- Mapeamentos comuns para seções
  vim.keymap.set("n", "<localleader>m", ":/methods: {<CR>")  -- Métodos
  vim.keymap.set("n", "<localleader>c", ":/computed: {<CR>") -- Computed (Vue)
  vim.keymap.set("n", "<localleader>i", ":/import <CR>")     -- Importações
  vim.keymap.set("n", "<localleader>p", ":/props: {<CR>")    -- Props (Vue)
  vim.keymap.set("n", "<localleader>s", ":/<style <CR>")     -- Estilos (Vue)

  -- Mapeamentos para React
  vim.keymap.set("n", "<localleader>rm", ":/render() {<CR>") -- Métodos de renderização
  vim.keymap.set("n", "<localleader>rc", ":/useEffect(<CR>") -- useEffect
  vim.keymap.set("n", "<localleader>ri", ":/import {<CR>")   -- Importações em React

  -- Mapeamentos para Angular
  vim.keymap.set("n", "<localleader>am", ":/ngOnInit()<CR>")   -- ngOnInit
  vim.keymap.set("n", "<localleader>ac", ":/constructor(<CR>") -- Construtor
  vim.keymap.set("n", "<localleader>ai", ":/import {<CR>")     -- Importações em Angular

  -- Mapeamentos para Node.js
  vim.keymap.set("n", "<localleader>nm", ":/function <CR>") -- Funções
  vim.keymap.set("n", "<localleader>ni", ":/require('<CR>") -- Require
end

-- Função para obter referências de componentes
local function get_component_references()
  local bufName = vim.api.nvim_buf_get_name(0)
  local filename = u.basename(bufName)
  local componentParts = u.split(filename, ".")
  local componentName = componentParts[1]
  local componentStart = '<' .. componentName

  if string.find(bufName, ".jsx") or string.find(bufName, ".tsx") then
    componentStart = componentName .. ' '
  end

  local fzfLua = require("fzf-lua")
  fzfLua.grep({ search = componentStart })
end

vim.keymap.set("n", "<localleader>vr", get_component_references)

-- Função para criar ou navegar para o arquivo de teste
M.make_or_jump_to_test_file = function()
  local fp = u.copy_relative_filepath(true)
  local file_path = fp:gsub("%.vue$", ".test.js"):gsub("%.jsx$", ".test.js"):gsub("%.tsx$", ".test.js")
  file_path = file_path:gsub("src/", "")
  local path = "test/specs/" .. file_path
  vim.cmd(string.format("e %s", path))
  u.replace_text_with_file("test_templates")
end

vim.keymap.set("n", "<localleader>tj", M.make_or_jump_to_test_file)

-- Função para importar módulos de forma dinâmica
M.import_module = function()
  local tech
  local bufName = vim.api.nvim_buf_get_name(0)

  if string.match(bufName, ".vue") then
    tech = "vue"
  elseif string.match(bufName, ".jsx") or string.match(bufName, ".tsx") then
    tech = "react"
  elseif string.match(bufName, ".js") or string.match(bufName, ".ts") then
    tech = "node"
  end

  -- Captura a palavra sob o cursor ou solicita ao usuário para digitar
  local import_name = vim.fn.expand("<cword>")                -- Obtém a palavra atual sob o cursor
  if import_name == "" then
    import_name = vim.fn.input("Nome do módulo a importar: ") -- Solicita ao usuário para inserir o nome
  end

  local import_statement = ""

  if tech == "vue" then
    import_statement = "import { " .. import_name .. " } from 'vue'"
  elseif tech == "react" then
    import_statement = "import " .. import_name .. " from '" .. import_name .. "'"
  elseif tech == "angular" then
    import_statement = "import { " .. import_name .. " } from '@angular/core'"
  elseif tech == "nextjs" then
    import_statement = "import " .. import_name .. " from 'next'"
  elseif tech == "node" then
    import_statement = "const " .. import_name .. " = require('" .. import_name .. "')"
  end

  vim.api.nvim_feedkeys("o" .. import_statement, "i", false) -- Insere a importação no arquivo
end

vim.keymap.set("n", "<localleader>vi", M.import_module)

setup_mappings()

return M
