return {
  -- VEGA policy: no AI assistant plugins by default.
  { "Exafunction/codeium.nvim", enabled = false },
  { "zbirenbaum/copilot.lua", enabled = false },
  { "zbirenbaum/copilot-cmp", enabled = false },
  { "CopilotC-Nvim/CopilotChat.nvim", enabled = false },

  -- Notes and dashboards are optional later, not part of the tiny PDE core.
  { "epwalsh/obsidian.nvim", enabled = false },

  -- Mason UI/plugin may exist in NickCrew catalog, but Neovim is not the toolchain owner here.
  { "williamboman/mason.nvim", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },
}
