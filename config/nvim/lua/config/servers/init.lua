-- ================================================================================================
-- TITLE : Servers Loader
-- ABOUT : Centraliza o carregamento de servers LSP em módulos pequenos.
-- NOTE  : Cada arquivo em `config/servers/*.lua` retorna uma função `(ctx) -> opts`.
-- ================================================================================================

local M = {}

function M.load(schemastore, util)
  local ctx = { schemastore = schemastore, util = util }
  local servers = {
    lua_ls = require("config.servers.lua_ls")(ctx),
    basedpyright = require("config.servers.pyright")(ctx),
    gopls = require("config.servers.gopls")(ctx),
    jsonls = require("config.servers.jsonls")(ctx),
    ts_ls = require("config.servers.ts_ls")(ctx),
    bashls = require("config.servers.bashls")(ctx),
    clangd = require("config.servers.clangd")(ctx),
    dockerls = require("config.servers.dockerls")(ctx),
    emmet_ls = require("config.servers.emmet_ls")(ctx),
    yamlls = require("config.servers.yamlls")(ctx),
    tailwindcss = require("config.servers.tailwindcss")(ctx),
    cssls = require("config.servers.cssls")(ctx),
    eslint = require("config.servers.eslint")(ctx),
    biome = require("config.servers.biome")(ctx),
    ltex_plus = require("config.servers.ltex_plus")(ctx),
    docker_compose_language_service = require("config.servers.docker_compose_language_service")(ctx),
    solidity = require("config.servers.solidity")(ctx),
  }

  local simple = require("config.servers.simple")(ctx)
  for name, opts in pairs(simple) do
    servers[name] = opts
  end

  if vim.fn.exepath("nil") ~= "" then
    servers.nil_ls = require("config.servers.nil_ls")(ctx)
  end

  return servers
end

return M
