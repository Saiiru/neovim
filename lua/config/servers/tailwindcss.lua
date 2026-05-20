-- ================================================================================================
-- TITLE : tailwindcss
-- ABOUT : Tailwind IntelliSense para web frameworks suportados.
-- ================================================================================================

return function(ctx)
  local util = ctx.util

  return {
    filetypes = {
      "html",
      "css",
      "scss",
      "sass",
      "javascriptreact",
      "javascript.jsx",
      "typescriptreact",
      "typescript.tsx",
      "mdx",
      "svelte",
      "vue",
      "astro",
      "templ",
      "php",
      "eruby",
      "heex",
    },
    -- Prevent attaching in random folders (e.g. ~/.vscode-insiders extensions),
    -- which can make tailwindcss-language-server scan huge trees and OOM.
    root_dir = util.root_pattern(
      "tailwind.config.js",
      "tailwind.config.cjs",
      "tailwind.config.mjs",
      "tailwind.config.ts",
      "postcss.config.js",
      "postcss.config.cjs",
      "postcss.config.mjs",
      "package.json",
      ".git"
    ),
    single_file_support = false,
  }
end
