local M = {}

M.avante = {
  refactor = "Refactor this code for clarity, maintainability, and safety.",
  code_review = "Perform a strict code review and list bugs, risks, and test gaps.",
  rust_design_review = "Review this Rust code with focus on ownership, lifetimes, and API design.",
  architecture_suggestion = "Suggest architectural improvements with clear tradeoffs.",
  readability_analysis = "Analyze readability and suggest concrete naming/structure improvements.",
  optimize_code = "Optimize this code for performance without sacrificing correctness.",
  explain_code = "Explain what this code does, key decisions, and possible pitfalls.",
  fix_bugs = "Identify and fix likely bugs in this code.",
  add_tests = "Suggest and add meaningful tests for this code.",
  security_review = "Do a security-focused review and point vulnerable patterns.",
  summarize = "Summarize this content objectively and concisely.",
  language_specific = {},
}

return M
