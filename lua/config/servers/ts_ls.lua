-- ================================================================================================
-- TITLE : ts_ls
-- ABOUT : TypeScript Language Server (não tsserver) com inlay hints e roots corretos.
-- ================================================================================================

return function(ctx)
  local util = ctx.util
  return {
    root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
    single_file_support = false,
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    init_options = {
      preferences = {
        disableSuggestions = true,
      },
    },
    settings = {
      typescript = {
        preferences = {
          includePackageJsonAutoImports = "auto",
        },
        inlayHints = {
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayVariableTypeHints = true,
        },
      },
      javascript = {
        preferences = {
          includePackageJsonAutoImports = "auto",
        },
        inlayHints = {
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayVariableTypeHints = true,
        },
      },
    },
  }
end
