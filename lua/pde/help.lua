local M = {}

local function has(list, value)
  for _, item in ipairs(list or {}) do if item == value then return true end end
  return false
end

local function existing_tasks(root)
  local out = {}
  for _, entry in ipairs(require("pde.tasks").entries(root)) do out[entry.name] = true end
  return out
end

function M.next_actions(bufnr)
  bufnr = bufnr or 0
  local detect = require("pde.detect")
  local info = detect.detect(bufnr)
  local tasks = existing_tasks(info.root)
  local actions = { ":PDEHelp — guia rápido e atalhos" }

  if next(tasks) == nil then
    table.insert(actions, ":PDETemplates — ver templates de projeto disponíveis")
    table.insert(actions, ":PDENewProject <template> <path> — criar projeto novo com mise/tasks")
  else
    if tasks.build then table.insert(actions, ":PDEBuild — compilar/build e abrir quickfix se falhar") end
    if tasks.test then table.insert(actions, ":PDETest — rodar testes do projeto") end
    if tasks.lint then table.insert(actions, ":PDELint — lint em quickfix") end
    if tasks.typecheck then table.insert(actions, ":PDETypecheck — checar tipos") end
    if tasks.dev then table.insert(actions, ":PDETmuxTask dev — servidor/dev em janela tmux") end
    if tasks.run then table.insert(actions, ":PDETmuxTask run — executar app em tmux") end
  end

  if info.type == "embedded" then
    table.insert(actions, ":PDEArduinoProfile — ver FQBN/profile sem flash")
    if tasks["arduino-compile"] then table.insert(actions, ":PDEArduinoCompile — compilar sem upload") end
  end

  table.insert(actions, ":PDEQuickfix — abrir lista de erros")
  return actions
end

function M.lines(bufnr)
  bufnr = bufnr or 0
  local info = require("pde.detect").detect(bufnr)
  local lines = {
    "PDE Help",
    "",
    "VEGA route: Neovim é o cockpit; mise é o dono de compilador/interpreter, toolchain e tasks.",
    "Nada aqui instala pacote, roda task global escondida ou mexe em hardware sem comando explícito.",
    "",
    "## Fluxo básico",
    "1. :PDEOverview — leia o projeto atual e as próximas ações.",
    "2. :PDEBuild / :PDETest / :PDELint — comandos com quickfix.",
    "3. :PDETmuxTask dev — servidor/watch em janela tmux.",
    "4. :PDEQuickfix ou :PDEErrors — abrir erros reais.",
    "",
    "## Atalhos",
    "<leader>ph — PDEHelp",
    "<leader>po — PDEOverview",
    "<leader>pb — PDEBuild",
    "<leader>pt — PDETest",
    "<leader>pl — PDELint",
    "<leader>py — PDETypecheck",
    "<leader>pd — PDETmuxTask dev",
    "<leader>pq — PDEQuickfix",
    "<leader>pn — PDENewProject prompt",
    "<leader>pT — PDETemplates",
    "",
    "## Criar projetos",
    ":PDETemplates — lista templates.",
    ":PDENewProject node ~/Code/app — Node básico.",
    ":PDENewProject next ~/Code/site — Next/React.",
    ":PDENewProject vite ~/Code/ui — Vite/TS.",
    ":PDENewProject go ~/Code/tool — Go.",
    ":PDENewProject rust ~/Code/crate — Rust.",
    ":PDENewProject c ~/Code/native — C/CMake.",
    ":PDENewProject arduino ~/Lab/blink — Arduino sketch.yaml + compile_commands placeholder.",
    ":PDENewProject java ~/Code/service — Java Maven.",
    "",
    "## Tasks locais esperadas",
    "build/test/lint/typecheck/check/clippy/arduino-compile → quickfix.",
    "dev/run/serve/monitor/arduino-monitor → tmux/terminal.",
    "arduino-upload/arduino-flash → hardware explícito, nunca automático.",
    "",
    "## Projeto atual",
    "root: " .. info.root,
    "type: " .. info.type,
    "framework: " .. info.framework,
    "language: " .. info.language,
    "",
    "## Próximas ações sugeridas",
  }
  for _, action in ipairs(M.next_actions(bufnr)) do table.insert(lines, "- " .. action) end
  return lines
end

function M.open(bufnr)
  local lines = M.lines(bufnr or 0)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local width = math.min(100, math.max(64, vim.o.columns - 8))
  local height = math.min(#lines + 2, math.max(18, vim.o.lines - 6))
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    title = " PDE Help ",
    title_pos = "center",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
  })
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
end

return M
