-- ================================================================================================
-- TITLE : clangd_extensions.nvim
-- ABOUT : UX melhor para C/C++ (inlay hints, AST e ações utilitárias do clangd).
-- LINKS :
--   > github : https://github.com/p00f/clangd_extensions.nvim
-- ================================================================================================

return {
  "p00f/clangd_extensions.nvim",
  ft = { "c", "cpp", "objc", "objcpp" },
  opts = {
    inlay_hints = {
      inline = false,
      only_current_line = false,
      only_current_line_autocmd = "CursorHold",
      show_parameter_hints = true,
      parameter_hints_prefix = " ",
      other_hints_prefix = " ",
    },
    ast = {
      role_icons = {
        type = "",
        declaration = "",
        expression = "",
        statement = "",
        specifier = "",
        ["template argument"] = "",
      },
      kind_icons = {
        Compound = "",
        Recovery = "",
        TranslationUnit = "",
        PackExpansion = "",
        TemplateTypeParm = "",
        TemplateTemplateParm = "",
        TemplateParamObject = "",
      },
    },
  },
}
