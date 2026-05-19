-- ================================================================================================
-- TITLE : gopls
-- ABOUT : LSP Go com inlay hints úteis para manutenção.
-- ================================================================================================

return function(_ctx)
  return {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  }
end
