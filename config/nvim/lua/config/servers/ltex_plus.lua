-- ================================================================================================
-- TITLE : ltex_plus
-- ABOUT : Grammar/spell LSP for prose: Markdown, LaTeX, Obsidian, mail and docs.
-- NOTE  : Default is English because that was the Coc baseline. Use the spell keymaps for pt-BR.
-- ================================================================================================

return function(_ctx)
  return {
    filetypes = {
      "bib",
      "context",
      "gitcommit",
      "html",
      "latex",
      "mail",
      "markdown",
      "mdx",
      "norg",
      "org",
      "plaintex",
      "quarto",
      "rmd",
      "rnoweb",
      "rst",
      "tex",
      "text",
    },
    settings = {
      ltex = {
        language = "en-US",
        completionEnabled = true,
        sentenceCacheSize = 6000,
        checkFrequency = "save",
        additionalRules = {
          enablePickyRules = true,
          motherTongue = "en-US",
        },
        diagnosticSeverity = {
          CONFUSED_WORDS = "warning",
          UPPERCASE_SENTENCE_START = "warning",
          DATE_WEEKDAY = "warning",
          MORFOLOGIK_RULE_EN_US = "error",
          EN_CONTRACTION_SPELLING = "error",
          EN_A_VS_AN = "error",
          IN_A_X_MANNER = "hint",
          PASSIVE_VOICE = "hint",
          EN_SPECIFIC_CASE = "hint",
          APOS_AR = "hint",
          DOUBLE_HYPHEN = "hint",
          AI_EN_LECTOR_MISSING_PUNCTUATION_COMMA = "hint",
          SENT_START_CONJUNCTIVE_LINKING_ADVERB_COMMA = "hint",
          default = "information",
        },
        configurationTarget = {
          dictionary = "userExternalFile",
          disabledRules = "userExternalFile",
          hiddenFalsePositives = "userExternalFile",
        },
      },
    },
  }
end
