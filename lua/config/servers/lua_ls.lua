-- ================================================================================================
-- TITLE : lua_ls
-- ABOUT : Configuração do Lua Language Server para Neovim config/plugins.
-- ================================================================================================

return function(_ctx)
  return {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = {
          globals = { "vim", "Snacks", "require" },
        },
        hint = { enable = true },
        workspace = { checkThirdParty = false },
      },
    },
  }
end
