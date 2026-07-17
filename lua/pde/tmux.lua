local M = {}

local function in_tmux()
  return vim.env.TMUX ~= nil and vim.fn.executable("tmux") == 1
end

local function debug_log(message)
  if vim.env.PDE_TMUX_DEBUG ~= "1" then return end
  local path = vim.fn.stdpath("state") .. "/pde-tmux-debug.log"
  local f = io.open(path, "a")
  if not f then return end
  f:write(os.date("%H:%M:%S "), message, "\n")
  f:close()
end

local function systemlist(argv)
  local out = vim.fn.systemlist(argv)
  return out, vim.v.shell_error
end

local function first_line(out)
  return type(out) == "table" and out[1] or nil
end

local function valid_session_id(id)
  return type(id) == "string" and id:match("^%$%d+$") ~= nil
end

local function valid_window_id(id)
  return type(id) == "string" and id:match("^@%d+$") ~= nil
end

local function current_session_id()
  local out, code = systemlist({ "tmux", "display-message", "-p", "#{session_id}" })
  local id = first_line(out)
  debug_log("current_session_id id=" .. tostring(id) .. " ec=" .. tostring(code))
  if code == 0 and valid_session_id(id) then return id end
  return nil
end

local function current_window_id()
  local out, code = systemlist({ "tmux", "display-message", "-p", "#{window_id}" })
  local id = first_line(out)
  debug_log("current_window_id id=" .. tostring(id) .. " ec=" .. tostring(code))
  if code == 0 and valid_window_id(id) then return id end
  return nil
end

local function target_window_id(session_id, window_name)
  local rows, code = systemlist({ "tmux", "list-windows", "-t", session_id, "-F", "#{window_id}\t#{window_name}" })
  debug_log("list_windows ec=" .. tostring(code) .. " rows=" .. table.concat(rows or {}, "|"))
  if code ~= 0 then return nil end
  for _, row in ipairs(rows) do
    local id, name = row:match("^([^\t]+)\t(.+)$")
    if name == window_name and valid_window_id(id) then return id end
  end
  return nil
end

local function shell_command()
  local shell = vim.env.SHELL or vim.o.shell or "sh"
  local name = vim.fs.basename(shell)
  if name == "zsh" or name == "bash" then return { shell, "-i" } end
  return { shell }
end

local function send_keys(window_id, keys, label)
  local argv = { "tmux", "send-keys", "-t", window_id }
  vim.list_extend(argv, keys)
  local out, code = systemlist(argv)
  debug_log("send " .. label .. " ec=" .. tostring(code) .. " out=" .. table.concat(out or {}, "|"))
  return code == 0
end

function M.run(root, task, opts)
  opts = opts or {}
  local cmd = "cd " .. vim.fn.shellescape(root) .. " && mise run " .. vim.fn.shellescape(task)
  debug_log("run root=" .. tostring(root) .. " task=" .. tostring(task) .. " tmux=" .. tostring(vim.env.TMUX))

  if not in_tmux() then
    debug_log("fallback terminal")
    vim.cmd("botright split")
    vim.cmd("terminal " .. cmd)
    return "terminal"
  end

  local session_id = current_session_id()
  if not session_id then
    vim.notify("failed to resolve current tmux session", vim.log.levels.ERROR)
    return nil
  end

  local window_name = opts.window or ("pde:" .. task:gsub("[^%w_-]", "-"))
  local current_window = current_window_id()
  local window_id = target_window_id(session_id, window_name)
  local created = false
  debug_log("window_name=" .. tostring(window_name) .. " current_window=" .. tostring(current_window) .. " existing_window_id=" .. tostring(window_id))

  if not window_id then
    local argv = { "tmux", "new-window", "-t", session_id, "-d", "-P", "-F", "#{window_id}", "-n", window_name, "-c", root }
    vim.list_extend(argv, shell_command())
    local out, code = systemlist(argv)
    window_id = first_line(out)
    created = true
    debug_log("new_window id=" .. tostring(window_id) .. " ec=" .. tostring(code) .. " out=" .. table.concat(out or {}, "|"))
    if code ~= 0 or not valid_window_id(window_id) then
      vim.notify("failed to create tmux window for task: " .. task, vim.log.levels.ERROR)
      return nil
    end
  end

  -- Always target the immutable tmux window id (for example @12). Window names
  -- such as "pde:dev" contain ':' and are ambiguous as tmux target strings.
  if not created and not send_keys(window_id, { "C-c" }, "C-c") then return nil end
  if not send_keys(window_id, { "clear", "C-m" }, "clear") then return nil end
  if not send_keys(window_id, { cmd, "C-m" }, "cmd") then return nil end

  if opts.focus then
    local _, code = systemlist({ "tmux", "select-window", "-t", window_id })
    debug_log("select task window ec=" .. tostring(code))
  elseif current_window then
    local _, code = systemlist({ "tmux", "select-window", "-t", current_window })
    debug_log("select original window ec=" .. tostring(code))
  end

  vim.notify("tmux " .. window_name .. ": mise run " .. task, vim.log.levels.INFO)
  return "tmux"
end

return M
