-- ================================================================================================
-- TITLE : jsonls
-- ABOUT : JSON/JSONC com SchemaStore automático.
-- ================================================================================================

return function(ctx)
  return {
    settings = {
      json = {
        schemas = ctx.schemastore.json.schemas(),
        validate = { enable = true },
      },
    },
  }
end
