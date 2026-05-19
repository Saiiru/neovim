-- ================================================================================================
-- TITLE : dockerls
-- ABOUT : LSP para Dockerfile com formatter multiline mais estável.
-- ================================================================================================

return function(_ctx)
  return {
    settings = {
      docker = {
        languageserver = {
          formatter = {
            ignoreMultilineInstructions = true,
          },
        },
      },
    },
  }
end
