local M = {}

function M.is_online()
  if vim.fn.executable "ping" == 0 then
    return true
  end
  local cmd = { "ping", "-c", "1", "-W", "1", "1.1.1.1" }
  return vim.fn.system(cmd) and vim.v.shell_error == 0
end

function M.is_mcp_present()
  return package.loaded.mcphub ~= nil or pcall(require, "mcphub")
end

-- Session notepad:
-- - Persistent while Neovim is running
-- - Hidden when closed (buffer kept in memory)
-- - Can be saved to any file path on demand
M.notepad_loaded = false
M.notepad_buf, M.notepad_win = nil, nil
M.notepad_last_path = nil

local function project_label()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  return cwd ~= "" and cwd or "Workspace"
end

local function default_notes_path()
  if M.notepad_last_path and M.notepad_last_path ~= "" then
    return M.notepad_last_path
  end
  local vault = vim.env.OBSIDIAN_VAULT
  if vault and vault ~= "" then
    return vault .. "/Inbox/Nvim Session Notes.md"
  end
  return vim.fn.getcwd() .. "/.nvim-session-notes.md"
end

local function ensure_notepad_buffer()
  if M.notepad_buf and vim.api.nvim_buf_is_valid(M.notepad_buf) then
    return
  end

  M.notepad_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("bufhidden", "hide", { buf = M.notepad_buf })
  vim.api.nvim_set_option_value("filetype", "markdown", { buf = M.notepad_buf })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = M.notepad_buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = M.notepad_buf })

  vim.api.nvim_buf_set_lines(M.notepad_buf, 0, -1, false, {
    "# Project Notes: " .. project_label(),
    "",
    "> Scratch notes for this Neovim session.",
    "> Use :NotepadSave to persist to a file (Obsidian/project/etc).",
    "",
  })
end

function M.launch_notepad()
  if not M.notepad_loaded or not (M.notepad_win and vim.api.nvim_win_is_valid(M.notepad_win)) then
    ensure_notepad_buffer()

    local height = math.ceil(vim.o.lines * 0.62)
    local width = math.ceil(vim.o.columns * 0.52)
    local row = 1
    local col = math.max(1, vim.o.columns - width - 2)

    M.notepad_win = vim.api.nvim_open_win(M.notepad_buf, true, {
      border = "rounded",
      relative = "editor",
      style = "minimal",
      title = " Notepad ",
      title_pos = "center",
      height = height,
      width = width,
      row = row,
      col = col,
    })

    vim.api.nvim_set_option_value("winblend", 8, { win = M.notepad_win })

    local keymaps_opts = { silent = true, buffer = M.notepad_buf }
    vim.keymap.set("n", "q", function()
      M.launch_notepad()
    end, keymaps_opts)
    vim.keymap.set("n", "<leader>ns", function()
      M.save_notepad()
    end, keymaps_opts)
  else
    vim.api.nvim_win_hide(M.notepad_win)
  end

  M.notepad_loaded = not M.notepad_loaded
end

function M.save_notepad(path)
  if not (M.notepad_buf and vim.api.nvim_buf_is_valid(M.notepad_buf)) then
    vim.notify("Notepad buffer does not exist yet.", vim.log.levels.WARN, { title = "Notepad" })
    return
  end

  local write_to = function(target)
    local abs = vim.fn.fnamemodify(target, ":p")
    vim.fn.mkdir(vim.fn.fnamemodify(abs, ":h"), "p")
    local lines = vim.api.nvim_buf_get_lines(M.notepad_buf, 0, -1, false)
    vim.fn.writefile(lines, abs)
    M.notepad_last_path = abs
    vim.notify("Notepad saved: " .. abs, vim.log.levels.INFO, { title = "Notepad" })
  end

  if path and path ~= "" then
    write_to(path)
    return
  end

  vim.ui.input({
    prompt = "Save notepad to: ",
    default = default_notes_path(),
  }, function(input)
    if not input or input == "" then
      return
    end
    write_to(input)
  end)
end

return M
