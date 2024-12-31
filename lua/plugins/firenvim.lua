return {
  "glacambre/firenvim",
  -- Only load Firenvim if it's not started by Firenvim
  build = function()
    vim.cmd("call firenvim#install(0)")
    -- Firenvim config setup to prevent auto takeover
    vim.g.firenvim_config = {
      localSettings = {
        -- Default: Never take over textareas
        [".*"] = { takeover = "never" },
        -- You can add specific URL patterns here:
        ["https://www.google.com"] = { takeover = "always" }, -- Always take over on Google
        ["https://github.com"] = { takeover = "user-defined" }, -- Custom takeover for GitHub
      },
    }
    -- Optionally, log when Firenvim is setup
    vim.notify("Firenvim setup complete with custom settings.", vim.log.levels.INFO)
  end,
}
