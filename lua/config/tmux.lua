-- Tmux Integration
-- vim-tpipeline, sesh, statusline, pane navigation
-- Full PDE tmux workflow

local M = {}

-- Check if in tmux
function M.in_tmux()
  return vim.env.TMUX ~= nil and vim.env.TMUX ~= ""
end

-- Vim-TPipeline is handled by vimpostor/vim-tpipeline.
-- Keep this module limited to tmux workflow/navigation to avoid duplicate refreshes.
function M.setup_tpipeline()
  if not M.in_tmux() then
    return
  end
  vim.opt.titlestring = "nvim"
  vim.opt.title = true

  local ok_statusline, statusline = pcall(require, "config.statusline")
  if ok_statusline then
    _G.vega_tpipeline_statusline = function()
      return statusline.tpipeline_line()
    end
  end
end

-- Sesh-like session management
M.sesh_sessions = {}

function M.sesh_save(name)
  name = name or vim.fn.input("Session name: ")
  if name == "" then
    return
  end

  local session_file = vim.fn.stdpath("data") .. "/sesh/" .. name .. ".vim"
  vim.fn.mkdir(vim.fn.fnamemodify(session_file, ":h"), "p")
  vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))

  M.sesh_sessions[name] = session_file
  vim.notify("💾 Session saved: " .. name, vim.log.levels.INFO)
end

function M.sesh_load(name)
  name = name or vim.fn.input("Session to load: ")
  if name == "" then
    return
  end

  local session_file = vim.fn.stdpath("data") .. "/sesh/" .. name .. ".vim"
  if vim.fn.filereadable(session_file) == 0 then
    vim.notify("Session not found: " .. name, vim.log.levels.ERROR)
    return
  end

  vim.cmd("source " .. vim.fn.fnameescape(session_file))
  vim.notify("📂 Session loaded: " .. name, vim.log.levels.INFO)
end

function M.sesh_list()
  local sesh_dir = vim.fn.stdpath("data") .. "/sesh/"
  if vim.fn.isdirectory(sesh_dir) == 0 then
    vim.notify("No sessions found", vim.log.levels.INFO)
    return
  end

  local files = vim.fn.glob(sesh_dir .. "*.vim", false, true)
  local sessions = {}
  for _, f in ipairs(files) do
    local name = vim.fn.fnamemodify(f, ":t:r")
    table.insert(sessions, name)
  end

  vim.ui.select(sessions, {
    prompt = "Select session:",
  }, function(choice)
    if choice then
      M.sesh_load(choice)
    end
  end)
end

function M.sesh_delete(name)
  name = name or vim.fn.input("Delete session: ")
  if name == "" then
    return
  end

  local session_file = vim.fn.stdpath("data") .. "/sesh/" .. name .. ".vim"
  if vim.fn.filereadable(session_file) == 1 then
    vim.fn.delete(session_file)
    vim.notify("🗑️ Session deleted: " .. name, vim.log.levels.INFO)
  end
end

-- Tmux pane navigation (vim-tmux-navigator style)
function M.tmux_navigate(direction)
  if not M.in_tmux() then
    vim.cmd("wincmd " .. direction)
    return
  end

  local dir_map = { h = "L", j = "D", k = "U", l = "R" }
  vim.fn.system("tmux select-pane -" .. dir_map[direction])
end

-- Tmux pane resize
function M.tmux_resize(direction, amount)
  if not M.in_tmux() then
    local map = { h = "h", j = "j", k = "k", l = "l" }
    vim.cmd("resize " .. (direction == "j" or direction == "k" and "+" or "") .. amount)
    return
  end

  local dir_map = { h = "L", j = "D", k = "U", l = "R" }
  vim.fn.system(string.format("tmux resize-pane -%s %d", dir_map[direction], amount or 5))
end

-- Smart pane management
function M.tmux_split(direction)
  if not M.in_tmux() then
    vim.cmd(direction == "h" or direction == "l" and "vsplit" or "split")
    return
  end

  local split_cmd = direction == "h" or direction == "l" and "split-window -h" or "split-window -v"
  vim.fn.system("tmux " .. split_cmd .. " -c '#{pane_current_path}'")
end

function M.tmux_kill_pane()
  if not M.in_tmux() then
    vim.cmd("close")
    return
  end
  vim.fn.system("tmux kill-pane")
end

function M.tmux_zoom()
  if not M.in_tmux() then
    vim.cmd("MaximizerToggle")
    return
  end
  vim.fn.system("tmux resize-pane -Z")
end

-- Project-aware tmux windows
function M.tmux_new_window(name)
  if not M.in_tmux() then
    return
  end
  local cmd = name and string.format("tmux new-window -n '%s' -c '#{pane_current_path}'", name)
    or "tmux new-window -c '#{pane_current_path}'"
  vim.fn.system(cmd)
end

function M.tmux_rename_window(name)
  if not M.in_tmux() then
    return
  end
  name = name or vim.fn.input("Window name: ")
  if name ~= "" then
    vim.fn.system("tmux rename-window '" .. name .. "'")
  end
end

-- Tmux session management (like sesh)
function M.tmux_session_save(name)
  if not M.in_tmux() then
    return
  end
  name = name or vim.fn.input("Session name: ")
  if name == "" then
    return
  end
  vim.fn.system("tmux save-session -t " .. name)
  vim.notify("💾 Tmux session saved: " .. name, vim.log.levels.INFO)
end

function M.tmux_session_list()
  if not M.in_tmux() then
    return
  end
  local output = vim.fn.system("tmux list-sessions -F '#{session_name}' 2>/dev/null")
  local sessions = vim.split(output, "\n", { trimempty = true })
  vim.ui.select(sessions, {
    prompt = "Select tmux session:",
  }, function(choice)
    if choice then
      vim.fn.system("tmux switch-client -t " .. choice)
      vim.notify("🔄 Switched to: " .. choice, vim.log.levels.INFO)
    end
  end)
end

function M.tmux_session_new(name)
  if not M.in_tmux() then
    return
  end
  name = name or vim.fn.input("New session name: ")
  if name == "" then
    return
  end
  vim.fn.system("tmux new-session -d -s " .. name .. " -c '" .. vim.fn.getcwd() .. "'")
  vim.fn.system("tmux switch-client -t " .. name)
  vim.notify("🆕 Tmux session created: " .. name, vim.log.levels.INFO)
end

-- Tmux popup for quick commands (like fzf in popup)
function M.tmux_popup(cmd, opts)
  if not M.in_tmux() then
    return
  end
  opts = opts or {}
  local width = opts.width or "80%"
  local height = opts.height or "60%"
  local title = opts.title and ("-T '" .. opts.title .. "'") or ""
  vim.fn.system(string.format("tmux display-popup -w %s -h %s %s -E '%s'", width, height, title, cmd))
end

-- Quick tmux popups
function M.popup_file_finder()
  M.tmux_popup("fzf --preview 'bat --color=always {}'", { title = "FILES" })
end

function M.popup_git_log()
  M.tmux_popup("git log --oneline -30 | fzf --preview 'git show --color=always {1}'", { title = "GIT LOG" })
end

function M.popup_sesh()
  M.tmux_popup("sesh list | fzf", { title = "SESSIONS" })
end

-- Integration with workflows
function M.run_in_tmux(workflow_cmd)
  if not M.in_tmux() then
    vim.cmd("split | terminal " .. workflow_cmd)
    return
  end

  -- Send to new pane or existing
  vim.fn.system(string.format("tmux split-window -h -c '%s' '%s'", vim.fn.getcwd(), workflow_cmd))
end

function M.run_in_tmux_bg(workflow_cmd, name)
  if not M.in_tmux() then
    vim.cmd("split | terminal " .. workflow_cmd)
    return
  end

  name = name or "task"
  vim.fn.system(string.format("tmux new-window -n '%s' -c '%s' '%s'", name, vim.fn.getcwd(), workflow_cmd))
end

-- Statusline integration for tmux
function M.get_tmux_status()
  if not M.in_tmux() then
    return ""
  end

  local session = vim.fn.system("tmux display-message -p '#S' 2>/dev/null"):gsub("\n", "")
  local window = vim.fn.system("tmux display-message -p '#W' 2>/dev/null"):gsub("\n", "")
  local pane = vim.fn.system("tmux display-message -p '#P' 2>/dev/null"):gsub("\n", "")

  return string.format(" 󰆍 %s:%s.%s ", session, window, pane)
end

-- Commands
function M.setup_commands()
  vim.api.nvim_create_user_command("TmuxNavigate", function(opts)
    M.tmux_navigate(opts.args)
  end, {
    nargs = 1,
    complete = function()
      return { "h", "j", "k", "l" }
    end,
    desc = "Navigate tmux pane",
  })

  vim.api.nvim_create_user_command("TmuxResize", function(opts)
    local args = vim.split(opts.args, " ")
    M.tmux_resize(args[1], tonumber(args[2]) or 5)
  end, {
    nargs = "+",
    complete = function()
      return { "h", "j", "k", "l" }
    end,
    desc = "Resize tmux pane",
  })

  vim.api.nvim_create_user_command("TmuxSplit", function(opts)
    M.tmux_split(opts.args)
  end, {
    nargs = "?",
    complete = function()
      return { "h", "j", "k", "l" }
    end,
    desc = "Split tmux pane",
  })

  vim.api.nvim_create_user_command("TmuxKillPane", M.tmux_kill_pane, { desc = "Kill tmux pane" })
  vim.api.nvim_create_user_command("TmuxZoom", M.tmux_zoom, { desc = "Zoom tmux pane" })

  vim.api.nvim_create_user_command("TmuxSessionSave", function(opts)
    M.tmux_session_save(opts.args)
  end, { nargs = "?", desc = "Save tmux session" })
  vim.api.nvim_create_user_command("TmuxSessionList", M.tmux_session_list, { desc = "List tmux sessions" })
  vim.api.nvim_create_user_command("TmuxSessionNew", function(opts)
    M.tmux_session_new(opts.args)
  end, { nargs = "?", desc = "New tmux session" })

  vim.api.nvim_create_user_command("SeshSave", function(opts)
    M.sesh_save(opts.args)
  end, { nargs = "?", desc = "Save nvim session" })
  vim.api.nvim_create_user_command("SeshLoad", function(opts)
    M.sesh_load(opts.args)
  end, { nargs = "?", desc = "Load nvim session" })
  vim.api.nvim_create_user_command("SeshList", M.sesh_list, { desc = "List nvim sessions" })
  vim.api.nvim_create_user_command("SeshDelete", function(opts)
    M.sesh_delete(opts.args)
  end, { nargs = "?", desc = "Delete nvim session" })

  -- Popups
  vim.api.nvim_create_user_command("TmuxPopupFiles", M.popup_file_finder, { desc = "Popup file finder" })
  vim.api.nvim_create_user_command("TmuxPopupGit", M.popup_git_log, { desc = "Popup git log" })
  vim.api.nvim_create_user_command("TmuxPopupSesh", M.popup_sesh, { desc = "Popup session switcher" })
end

-- Keymaps
function M.setup_keymaps()
  local map = vim.keymap.set
  local opts = { silent = true, desc = "" }

  -- Pane navigation (works in/out tmux)
  map("n", "<C-h>", function()
    M.tmux_navigate("h")
  end, { desc = "Pane Left" })
  map("n", "<C-j>", function()
    M.tmux_navigate("j")
  end, { desc = "Pane Down" })
  map("n", "<C-k>", function()
    M.tmux_navigate("k")
  end, { desc = "Pane Up" })
  map("n", "<C-l>", function()
    M.tmux_navigate("l")
  end, { desc = "Pane Right" })

  -- Tmux prefix-like keys
  map("n", "<leader>th", "<cmd>TmuxNavigate h<cr>", { desc = "Tmux ←" })
  map("n", "<leader>tj", "<cmd>TmuxNavigate j<cr>", { desc = "Tmux ↓" })
  map("n", "<leader>tk", "<cmd>TmuxNavigate k<cr>", { desc = "Tmux ↑" })
  map("n", "<leader>tl", "<cmd>TmuxNavigate l<cr>", { desc = "Tmux →" })

  map("n", "<leader>tH", "<cmd>TmuxResize h<cr>", { desc = "Resize ←" })
  map("n", "<leader>tJ", "<cmd>TmuxResize j<cr>", { desc = "Resize ↓" })
  map("n", "<leader>tK", "<cmd>TmuxResize k<cr>", { desc = "Resize ↑" })
  map("n", "<leader>tL", "<cmd>TmuxResize l<cr>", { desc = "Resize →" })

  map("n", "<leader>ts", "<cmd>TmuxSplit h<cr>", { desc = "Split H" })
  map("n", "<leader>tv", "<cmd>TmuxSplit v<cr>", { desc = "Split V" })
  map("n", "<leader>tx", "<cmd>TmuxKillPane<cr>", { desc = "Kill Pane" })
  map("n", "<leader>tz", "<cmd>TmuxZoom<cr>", { desc = "Zoom Pane" })

  map("n", "<leader>tw", "<cmd>TmuxSessionNew<cr>", { desc = "New Session" })
  map("n", "<leader>tl", "<cmd>TmuxSessionList<cr>", { desc = "List Sessions" })
  map("n", "<leader>tS", "<cmd>TmuxSessionSave<cr>", { desc = "Save Session" })

  map("n", "<leader>ss", "<cmd>SeshSave<cr>", { desc = "Save Session" })
  map("n", "<leader>sl", "<cmd>SeshLoad<cr>", { desc = "Load Session" })
  map("n", "<leader>sL", "<cmd>SeshList<cr>", { desc = "List Sessions" })

  map("n", "<leader>pf", "<cmd>TmuxPopupFiles<cr>", { desc = "Popup Files" })
  map("n", "<leader>pg", "<cmd>TmuxPopupGit<cr>", { desc = "Popup Git Log" })
  map("n", "<leader>ps", "<cmd>TmuxPopupSesh<cr>", { desc = "Popup Sessions" })
end

function M.setup()
  M.setup_tpipeline()
  M.setup_commands()
  M.setup_keymaps()

  -- Add tmux status to statusline
  _G.tmux_status = M.get_tmux_status
end

if not vim.g.vega_tmux_module_loaded then
  vim.g.vega_tmux_module_loaded = true
  M.setup()
end

return M
