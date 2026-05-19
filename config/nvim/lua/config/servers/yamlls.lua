-- ================================================================================================
-- TITLE : yamlls
-- ABOUT : YAML LSP com schemas do SchemaStore.
-- ================================================================================================

return function(ctx)
  return {
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = ctx.schemastore.yaml.schemas(),
        validate = true,
        format = true,
      },
    },
  }
end
