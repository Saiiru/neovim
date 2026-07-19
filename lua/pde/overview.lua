local M = {}

local function lsp_names(bufnr)
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr or 0 })) do table.insert(names, client.name) end
  table.sort(names)
  return names
end

local function contains(list, value)
  for _, item in ipairs(list or {}) do if item == value then return true end end
  return false
end

local function section(lines, title)
  table.insert(lines, "")
  table.insert(lines, "## " .. title)
end

function M.lines(bufnr)
  bufnr = bufnr or 0
  local detect = require("pde.detect")
  local tasks = require("pde.tasks")
  local catalog = require("pde.catalog")
  local info = detect.detect(bufnr)
  local lang = catalog.language(info.language)
  local task_entries = tasks.entries(info.root)
  local task_names = {}
  for _, entry in ipairs(task_entries) do table.insert(task_names, entry.name) end
  local active_lsp = lsp_names(bufnr)
  local lines = {
    "PDE Overview",
    "root: " .. info.root,
    "type: " .. info.type,
    "framework: " .. info.framework,
    "language: " .. info.language .. " (" .. lang.label .. ")",
    "marker: " .. tostring(info.marker),
    "package manager: " .. tostring(info.package_manager or "none"),
    "tmux: " .. tostring(vim.env.TMUX ~= nil),
  }

  section(lines, "Suggested next actions")
  for _, action in ipairs(require("pde.help").next_actions(bufnr)) do
    table.insert(lines, "- " .. action)
  end

  section(lines, "LSP")
  table.insert(lines, "expected: " .. (#lang.lsp > 0 and table.concat(lang.lsp, ", ") or "none"))
  table.insert(lines, "active: " .. (#active_lsp > 0 and table.concat(active_lsp, ", ") or "none"))
  table.insert(lines, "notes: " .. (lang.notes or ""))

  section(lines, "Markers")
  table.insert(lines, "has .mise.toml: " .. tostring(detect.exists(info.root, ".mise.toml")))
  table.insert(lines, "has mise/tasks: " .. tostring(detect.exists(info.root, "mise/tasks")))
  table.insert(lines, "has pde.toml: " .. tostring(info.has_pde))
  table.insert(lines, "compile_commands.json: " .. tostring(info.has_compile_db))
  table.insert(lines, "known markers: " .. (#lang.markers > 0 and table.concat(lang.markers, ", ") or "none"))

  section(lines, "Local mise tasks")
  if #task_entries == 0 then
    table.insert(lines, "none")
  else
    for _, entry in ipairs(task_entries) do
      table.insert(lines, "- " .. entry.name .. " [" .. entry.source .. "]")
    end
  end

  section(lines, "Expected task contract")
  for _, task in ipairs(info.expected_tasks or {}) do
    table.insert(lines, string.format("- %s %s", contains(task_names, task) and "✓" or "·", task))
  end

  section(lines, "Routing")
  table.insert(lines, "quickfix/compiler: build, test, lint, typecheck, arduino-compile")
  table.insert(lines, "tmux/terminal: dev, run, serve, monitor, arduino-monitor")
  table.insert(lines, "explicit hardware only: arduino-upload, arduino-flash")

  if info.type == "embedded" then
    section(lines, "Arduino")
    vim.list_extend(lines, require("pde.arduino").status_lines(bufnr))
  end

  return lines
end

function M.open(bufnr)
  local lines = M.lines(bufnr or 0)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local width = math.min(96, math.max(60, vim.o.columns - 8))
  local height = math.min(#lines + 2, math.max(18, vim.o.lines - 6))
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    title = " PDE Overview ",
    title_pos = "center",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
  })
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
end

return M
