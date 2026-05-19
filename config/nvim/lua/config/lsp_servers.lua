-- ================================================================================================
-- TITLE : LSP Servers Registry
-- ABOUT : Registro central de servers. Parte modular em `config/servers/*` + extras locais.
-- ================================================================================================

local M = {}

function M.get(schemastore, util)
  return require("config.servers").load(schemastore, util)
end

return M
