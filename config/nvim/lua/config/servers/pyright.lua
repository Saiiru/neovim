-- ================================================================================================
-- TITLE : basedpyright / pyright
-- ABOUT : Configuração Python com foco em auto-import e análise de workspace.
-- ================================================================================================

return function(_ctx)
  return {
    settings = {
      pyright = {
        disableOrganizeImports = false,
      },
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
          autoImportCompletions = true,
        },
      },
    },
  }
end
