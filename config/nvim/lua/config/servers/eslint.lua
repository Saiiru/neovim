-- ================================================================================================
-- TITLE : eslint
-- ABOUT : Lint para ecossistema JS/TS/Vue/Svelte/Astro com root inteligente.
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
      "vue",
      "svelte",
      "astro",
    },
    root_dir = util.root_pattern(
      "eslint.config.js",
      "eslint.config.cjs",
      "eslint.config.mjs",
      "eslint.config.ts",
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.json",
      ".eslintrc.yaml",
      ".eslintrc.yml"
    ),
    single_file_support = false,
  }
end
