-- DedSec Terminal UI
-- ASCII animations, cursor effects, Batman/DedSec aesthetics
-- Inspired by DedSec fankit and Watch Dogs 2 UI

local M = {}

-- DedSec ASCII Art Collection
M.ascii = {
  batman = [[
          ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
         ██████████████████████████████████████████████████████████████
        ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
       ██░░  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ░░██
      ██░░  ████████████████████████████████████████████████████████  ░░██
     ██░░  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██  ░░██
    ██░░  ██░░  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██  ░░██
    ██░░  ██░░  ██░░  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██  ░░██
    ██░░  ██░░  ██░░  ██░░  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ██  ░░██
    ██░░  ██░░  ██░░  ██░░  ████████████████████████████████████  ██  ░░██
    ██░░  ██░░  ██░░  ██░░  BATMAN  ░░░░░░░░░░░░░░░░░░░░░░░░░░  ██  ░░██
    ██░░  ██░░  ██░░  ██░░  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ██  ░░██
    ██░░  ██░░  ██░░  ██░░  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ██  ░░██
    ██░░  ██░░  ██░░  ██░░  ████████████████████████████████████  ██  ░░██
    ██░░  ██░░  ██░░  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██  ░░██
    ██░░  ██░░  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██  ░░██
    ██░░  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██  ░░██
    ██░░  ████████████████████████████████████████████████████████  ░░██
    ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
    ████████████████████████████████████████████████████████████████
    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
]],

  dedsec_skull = [[
      ╔═══════════════════════════════════════════════════════════════════╗
      ║          ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ║
      ║         ████████████████████████████████████████████████████████████ ██
      ║        ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██  ██
      ║       ██░░  ▄▄▄▄▄▄      ▄▄▄▄▄▄      ▄▄▄▄▄▄      ▄▄▄▄▄▄      ▄▄▄▄▄▄  ░░░░██ ║
      ║       ██░░  ████████    ████████    ████████    ████████    ████████ ░░░░██ ║
      ║       ██░░  ▀▀▀▀▀▀      ▀▀▀▀▀▀      ▀▀▀▀▀▀      ▀▀▀▀▀▀      ▀▀▀▀▀▀  ░░░░██ ║
      ║       ██░░                                                ░░░░░░░░░░░░░░░░░░██ ║
      ║       ██░░      ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄      ░░░░██ ║
      ║       ██░░     ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀       ░░░░██ ║
      ║       ██░░                                                ░░░░░░░░░░░░░░░░░░░░██ ║
      ║        ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██ ║
      ║         ██████████████████████████████████████████████████████████████████ ██
      ║          ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀  ║
      ╚═══════════════════════════════════════════════════════════════════╝
]],

  dedsec_logo = [[
      ██████╗ ██████╗  ██████╗ ██████╗ ██████╗ ██╗  ██╗
      ██╔════╝██╔═══██╗██╔════╝██╔════╝██╔═══██╗██║ ██╔╝
      ██║     ██║   ██║██║     ██║     ██║   ██║█████╔╝ 
      ██║     ██║   ██║██║     ██║     ██║   ██║██╔═██╗ 
      ╚██████╗╚██████╔╝╚██████╗╚██████╗╚██████╔╝██║  ██╗
       ╚═════╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝
]],

  glitch = [[
██████████████████████████████████████████████████████████████████████
█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
█ ██████████████████████████████████████████████████████████████████ ██
█ ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██ █ █
█ ██░░  ████████████████████████████████████████████████████████ ░░██ █ █
█ ██░░  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ░░██ █ █
█ ██░░  ██░░  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ░░██ █ █
█ ██░░  ██░░  ██░░  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ░░██ █ █
█ ██░░  ██░░  ██░░  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ░░██ █ █
█ ██░░  ██░░  ██░░  D E S E C  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ░░██ █ █
█ ██░░  ██░░  ██░░  ████████████████████████████████████████████ ░░██ █ █
█ ██░░  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ░░██ █ █
█ ██░░  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ░░██ █ █
█ ████████████████████████████████████████████████████████████████ █ █
█ ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██ █ █
█ █████████████████████████████████████████████████████████████████ █ █
█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██████████████████████████████████████████████████████████████████████
]],

  minimal = [[
┌─────────────────────────────────────────────────────────────┐
│  ██████  ██████  ██████  ██████  ██████  ██████  ██████    │
│  ██╔══  ██╔══  ██╔══  ██╔══  ██╔══  ██╔══  ██╔══  ██╔══    │
│  ██████  ██████  ██████  ██████  ██████  ██████  ██████    │
│  ██╔══  ██╔══  ██╔══  ██╔══  ██╔══  ██╔══  ██╔══  ██╔══    │
│  ██████  ██████  ██████  ██████  ██████  ██████  ██████    │
│  ▀▀▀▀▀  ▀▀▀▀▀  ▀▀▀▀▀  ▀▀▀▀▀  ▀▀▀▀▀  ▀▀▀▀▀  ▀▀▀▀▀  ▀▀▀▀▀    │
└─────────────────────────────────────────────────────────────┘
]],

  -- Animation frames for cursor
  cursor_frames = { "█", "▓", "▒", "░", "▒", "▓" },
  spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
  pulse_frames = { "●", "○", "●", "○" },
  scan_frames = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█", "▇", "▆", "▅", "▄", "▃", "▂" },
}

-- Animation state
M.animations = {
  cursor = { frame = 1, timer = nil, enabled = true },
  spinner = { frame = 1, timer = nil, enabled = false },
  pulse = { frame = 1, timer = nil, enabled = false },
}

-- Get banner based on terminal width
function M.get_banner(width)
  width = width or vim.o.columns
  if width < 60 then
    return M.ascii.minimal
  elseif width < 85 then
    return M.ascii.dedsec_logo
  elseif width < 120 then
    return M.ascii.dedsec_skull
  else
    return M.ascii.batman
  end
end

-- Start cursor animation
function M.start_cursor_animation()
  if M.animations.cursor.timer then return end
  M.animations.cursor.enabled = true
  M.animations.cursor.timer = vim.loop.new_timer()
  M.animations.cursor.timer:start(0, 120, vim.schedule_wrap(function()
    if not M.animations.cursor.enabled then
      M.animations.cursor.timer:stop()
      M.animations.cursor.timer:close()
      M.animations.cursor.timer = nil
      return
    end
    M.animations.cursor.frame = M.animations.cursor.frame % #M.ascii.cursor_frames + 1
    vim.cmd("redrawstatus")
  end))
end

-- Stop cursor animation
function M.stop_cursor_animation()
  M.animations.cursor.enabled = false
end

-- Start spinner animation
function M.start_spinner()
  if M.animations.spinner.timer then return end
  M.animations.spinner.enabled = true
  M.animations.spinner.timer = vim.loop.new_timer()
  M.animations.spinner.timer:start(0, 80, vim.schedule_wrap(function()
    if not M.animations.spinner.enabled then
      M.animations.spinner.timer:stop()
      M.animations.spinner.timer:close()
      M.animations.spinner.timer = nil
      return
    end
    M.animations.spinner.frame = M.animations.spinner.frame % #M.ascii.spinner_frames + 1
    vim.cmd("redrawstatus")
  end))
end

-- Stop spinner
function M.stop_spinner()
  M.animations.spinner.enabled = false
end

-- Get current cursor frame
function M.get_cursor_frame()
  return M.ascii.cursor_frames[M.animations.cursor.frame]
end

-- Get current spinner frame
function M.get_spinner_frame()
  return M.ascii.spinner_frames[M.animations.spinner.frame]
end

-- DedSec boot sequence
function M.boot_sequence()
  local frames = {
    "┌─[SYSTEM] Initializing DedSec OS...",
    "└─[OK] Kernel loaded",
    "┌─[SYSTEM] Loading neural interface...",
    "└─[OK] Neural link established",
    "┌─[SYSTEM] Connecting to ctOS...",
    "└─[WARNING] ctOS firewall detected",
    "┌─[EXPLOIT] Deploying backdoor...",
    "└─[SUCCESS] Backdoor installed",
    "┌─[SYSTEM] Access granted. Welcome, operator.",
    "└─[DEDSEC] System online.",
  }
  
  for i, frame in ipairs(frames) do
    vim.defer_fn(function()
      vim.notify(frame, vim.log.levels.INFO, { title = "DEDSEC BOOT" })
    end, (i - 1) * 300)
  end
end

-- Scanline effect for statusline
function M.get_scanline()
  local frame = M.ascii.scan_frames[(vim.fn.line(".") % #M.ascii.scan_frames) + 1]
  return frame
end

-- Glitch text effect
function M.glitch_text(text, intensity)
  intensity = intensity or 0.1
  local glitch_chars = { "█", "▓", "▒", "░", "▀", "▄", "■", "□" }
  local result = ""
  for i = 1, #text do
    if math.random() < intensity then
      result = result .. glitch_chars[math.random(#glitch_chars)]
    else
      result = result .. text:sub(i, i)
    end
  end
  return result
end

-- Setup UI autocmds
function M.setup_ui()
  -- Start cursor animation on VimEnter
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      M.start_cursor_animation()
      M.boot_sequence()
    end,
    once = true,
  })

  -- Stop animation on VimLeave
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      M.stop_cursor_animation()
      M.stop_spinner()
    end,
  })

  -- Statusline components
  _G.dedsec_status = {
    cursor = function() return M.get_cursor_frame() end,
    spinner = function() return M.get_spinner_frame() end,
    scanline = function() return M.get_scanline() end,
  }
end

-- Terminal integration for kitty
function M.setup_kitty_integration()
  if vim.env.TERM ~= "xterm-kitty" then return end
  
  -- Enable kitty graphics protocol
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      io.write("\027]1337;SetColors=background=#0a0a0f\007")
      io.write("\027]1337;SetColors=foreground=#e0d8e8\007")
      io.write("\027]1337;SetColors=cursor=#00ffff\007")
    end,
  })
end

-- Commands
function M.setup_commands()
  vim.api.nvim_create_user_command("DedsecBoot", M.boot_sequence, { desc = "Run DedSec boot sequence" })
  vim.api.nvim_create_user_command("DedsecBanner", function(opts)
    local width = tonumber(opts.args) or vim.o.columns
    print(M.get_banner(width))
  end, { nargs = "?", desc = "Show DedSec banner" })
  vim.api.nvim_create_user_command("DedsecCursor", function(opts)
    if opts.args == "on" then
      M.start_cursor_animation()
    elseif opts.args == "off" then
      M.stop_cursor_animation()
    else
      M.animations.cursor.enabled = not M.animations.cursor.enabled
      if M.animations.cursor.enabled then M.start_cursor_animation() else M.stop_cursor_animation() end
    end
  end, { nargs = "?", complete = function() return {"on", "off", "toggle"} end, desc = "Toggle cursor animation" })
  vim.api.nvim_create_user_command("DedsecGlitch", function(opts)
    local text = opts.args ~= "" and opts.args or "DEDSEC SYSTEM ONLINE"
    local intensity = tonumber(opts.fargs[2]) or 0.15
    print(M.glitch_text(text, intensity))
  end, { nargs = "+", desc = "Glitch text effect" })
end

function M.setup()
  M.setup_ui()
  M.setup_kitty_integration()
  M.setup_commands()
end

return M