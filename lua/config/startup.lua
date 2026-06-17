-- Fast Startup Optimization
-- Profile-guided lazy loading, deferred requires, startup profiling

local M = {}

M.startup_time = 0
M.profile_data = {}

-- Measure startup time
function M.measure_startup()
  local start = vim.loop.hrtime()
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    once = true,
    callback = function()
      local elapsed = (vim.loop.hrtime() - start) / 1e6
      M.startup_time = elapsed
      vim.notify(string.format("⚡ Startup: %.2fms", elapsed), vim.log.levels.INFO)
      
      -- Store for dashboard
      _G.startup_time = elapsed
    end,
  })
end

-- Defer non-critical plugin loading
M.deferred_plugins = {
  "telescope",
  "trouble",
  "neotest",
  "dap",
  "noice",
  "markdown",
  "markdown_preview",
  "neogen",
  "codecompanion",
  "avante",
  "copilot",
  "claude_code",
}

-- Mark plugins as lazy by default
function M.optimize_lazy_spec(spec)
  if type(spec) ~= "table" then return spec end
  
  -- If plugin has no explicit lazy = false, make it lazy
  if spec.lazy == nil and spec.event == nil and spec.cmd == nil and spec.keys == nil and spec.ft == nil then
    spec.lazy = true
  end
  
  return spec
end

-- Profile lazy.nvim loading
function M.profile_lazy()
  local original_require = require
  local profiles = {}
  
  require = function(module)
    local start = vim.loop.hrtime()
    local result = original_require(module)
    local elapsed = (vim.loop.hrtime() - start) / 1e6
    profiles[module] = elapsed
    return result
  end
  
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    once = true,
    callback = function()
      require = original_require
      -- Sort by time
      local sorted = {}
      for k, v in pairs(profiles) do
        table.insert(sorted, { module = k, time = v })
      end
      table.sort(sorted, function(a, b) return a.time > b.time end)
      
      M.profile_data = sorted
      _G.startup_profile = sorted
      
      -- Notify slow modules
      for i = 1, math.min(5, #sorted) do
        if sorted[i].time > 10 then
          vim.notify(string.format("🐢 %s: %.2fms", sorted[i].module, sorted[i].time), vim.log.levels.WARN)
        end
      end
    end,
  })
end

-- Fast filetype detection
function M.optimize_filetype()
  -- Disable builtin filetype detection for speed
  vim.g.did_load_filetypes = 1
  
  -- Use filetype.lua instead of filetype.vim
  vim.g.do_filetype_lua = 1
end

-- Defer UI setup
function M.defer_ui()
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      -- Load UI plugins after startup
      require("config.ui_polish")
      require("config.statusline")
      require("config.whichkey")
    end,
  })
end

-- Optimize LSP startup
function M.optimize_lsp()
  -- Don't auto-start LSP on startup, only on buffer enter
  vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = function()
      if vim.bo.buftype == "" then
        -- Trigger LSP for current buffer only
        vim.cmd("LspStart")
      end
    end,
  })
end

-- Cache compiled lua
function M.setup_lua_cache()
  if vim.fn.has("linux") == 1 then
    local cache_dir = vim.fn.stdpath("cache") .. "/luac"
    vim.fn.mkdir(cache_dir, "p")
    vim.loader.enable()
  end
end

-- Startup commands
function M.setup_commands()
  vim.api.nvim_create_user_command("StartupProfile", function()
    if M.profile_data and #M.profile_data > 0 then
      local lines = { "╔══════════════════════════════════════════════════════════════════╗",
                      "║                    STARTUP PROFILE                                ║",
                      "╠══════════════════════════════════════════════════════════════════╣" }
      for i, item in ipairs(M.profile_data) do
        if i > 20 then break end
        local mark = item.time > 10 and "🐢" or (item.time > 5 and "⚠️" or "✓")
        table.insert(lines, string.format("║ %s %-40s %8.2fms ║", mark, item.module, item.time))
      end
      table.insert(lines, "╚══════════════════════════════════════════════════════════════════╝")
      
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = 70,
        height = #lines + 2,
        row = 2,
        col = vim.o.columns - 72,
        border = "rounded",
        title = " STARTUP PROFILE ",
        title_pos = "center",
      })
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
    else
      vim.notify("No profile data available", vim.log.levels.INFO)
    end
  end, { desc = "Show startup profile" })

  vim.api.nvim_create_user_command("StartupTime", function()
    vim.notify(string.format("⚡ Total startup: %.2fms", M.startup_time), vim.log.levels.INFO)
  end, { desc = "Show startup time" })
end

function M.setup()
  M.measure_startup()
  M.optimize_filetype()
  M.setup_lua_cache()
  M.defer_ui()
  M.optimize_lsp()
  M.profile_lazy()
  M.setup_commands()
end

return M