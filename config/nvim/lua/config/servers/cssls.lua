-- ================================================================================================
-- TITLE : cssls
-- ABOUT : CSS/SCSS/LESS com lint mais permissivo para projetos modernos.
-- ================================================================================================

return function(_ctx)
  return {
    settings = {
      css = { validate = true, lint = { unknownAtRules = "ignore" } },
      scss = { validate = true, lint = { unknownAtRules = "ignore" } },
      less = { validate = true, lint = { unknownAtRules = "ignore" } },
    },
  }
end
