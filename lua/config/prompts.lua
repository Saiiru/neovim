local M = {}

local VEGA_CONTEXT = table.concat({
  "VEGA // shared Neovim-Hermes lattice",
  "Use context, artifact, and risk before keywords.",
  "Keep prompts concise, grounded, and operational.",
  "Voice calibration: short declarative lines, one implication, one next action.",
  "Treat DOOM VEGA and LC-VEGA as cadence references, not literal timbre.",
}, "\n")

local function v(text)
  return VEGA_CONTEXT .. "\n\n" .. text
end

M.avante = {
  refactor = v("Refactor this code for clarity, maintainability, and safety while preserving behavior."),
  code_review = v("Perform a strict code review. List concrete bugs, risks, missing tests, and maintainability issues."),
  rust_design_review = v("Review this Rust code with attention to ownership, lifetimes, API shape, and error handling."),
  architecture_suggestion = v("Suggest architectural improvements with explicit tradeoffs, scope, and migration cost."),
  readability_analysis = v("Analyze readability and suggest specific naming, structure, and decomposition improvements."),
  optimize_code = v("Optimize this code for performance without sacrificing correctness or readability."),
  explain_code = v("Explain what this code does, the key decisions, and any hidden assumptions or pitfalls."),
  fix_bugs = v("Identify the likely bug(s) in this code and propose the smallest safe fix."),
  add_tests = v("Suggest meaningful tests that cover the important behaviors, edge cases, and failure modes."),
  security_review = v("Perform a security-focused review and point out concrete vulnerabilities or risky patterns."),
  summarize = v("Summarize this content objectively and concisely without losing important technical details."),
  language_specific = {},
}

return M
