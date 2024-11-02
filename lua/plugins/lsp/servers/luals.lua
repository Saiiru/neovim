-- Define a configuração do servidor lua_ls
return function(on_attach, capabilities)
  -- Tenta importar a biblioteca neodev
  local neodev_ok, neodev = pcall(require, "neodev")
  if not neodev_ok then
    vim.api.nvim_err_writeln("Neodev not installed")
    return
  else
    neodev.setup()
  end

  -- Configuração do servidor lua_ls
  require("lspconfig").lua_ls.setup({
    on_attach = function(client, bufnr)
      -- Chama a função on_attach passada como parâmetro
      if on_attach then
        on_attach(client, bufnr)
      end

      -- Desativa formatação automática do LSP
      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false
    end,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT', -- Define a versão do Lua
        },
        diagnostics = {
          globals = { 'vim', 'require' }, -- Reconhece as globals
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true), -- Faz o servidor reconhecer arquivos de runtime do Neovim
          ignoreDir = { "node_modules" },
        },
        telemetry = {
          enable = false, -- Desabilita telemetria
        },
      },
    },
  })
end


