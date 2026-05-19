return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "b0o/schemastore.nvim",
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    local lsp = require "config.lsp"
    local lsp_servers = require "config.lsp_servers"
    local server_arduino = require "config.servers.arduino_language_server"
    local server_qmlls = require "config.servers.qmlls"
    local schemastore = require "schemastore"
    local util = require "lspconfig.util"

    vim.filetype.add {
      extension = {
        ino = "arduino",
        pde = "arduino",
      },
    }

    local servers = lsp_servers.get(schemastore, util)

    for server, opts in pairs(servers) do
      lsp.setup(server, opts)
    end

    local arduino_opts = server_arduino { util = util, schemastore = schemastore }
    if arduino_opts then
      lsp.setup("arduino_language_server", arduino_opts)
    end

    local qmlls_opts = server_qmlls { util = util, schemastore = schemastore }
    if qmlls_opts then
      lsp.setup("qmlls", qmlls_opts)
    end
  end,
}
