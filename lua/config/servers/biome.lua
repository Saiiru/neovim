-- ================================================================================================
-- TITLE : biome
-- ABOUT : Lint/format para JS/TS/JSON/CSS quando houver config biome no projeto.
-- ================================================================================================

return function(ctx)
  local util = ctx.util
  return {
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "json",
      "jsonc",
      "css",
    },
    root_dir = util.root_pattern(
      "biome.json",
      "biome.jsonc",
      ".biome.json",
      ".biome.jsonc"
    ),
    single_file_support = false,
  }
end
