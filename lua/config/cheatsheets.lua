-- ================================================================================================
-- TITLE : cheatsheets
-- ABOUT : Pequenas folhas de referência dentro do Neovim para aprender motions e plugins.
-- NOTE  : Mantém documentação perto dos keymaps, sem depender de browser/wiki.
-- ================================================================================================

local M = {}

local sheets = {
  motions = {
    "# Vim Motions - Guia rápido",
    "",
    "Movimento básico:",
    "  h / j / k / l       esquerda / baixo / cima / direita",
    "  w / b / e           próxima palavra / palavra anterior / fim da palavra",
    "  0 / ^ / $           início da linha / primeiro texto / fim da linha",
    "  gg / G              topo / fim do arquivo",
    "  { / }               parágrafo/bloco anterior e próximo",
    "  %                   par correspondente: (), {}, [], etc.",
    "",
    "Tela:",
    "  H / M / L           topo / meio / fim da tela",
    "  Ctrl-u / Ctrl-d     meia página para cima/baixo",
    "  zz                  centraliza cursor",
    "",
    "Operadores:",
    "  d{motion}           delete: dw, d$, dap",
    "  c{motion}           change: cw, ci\", ca)",
    "  y{motion}           yank/copy: yiw, yip",
    "  v{motion}           visual select",
    "",
    "Text objects úteis:",
    "  iw / aw             inner word / a word",
    "  i\" / a\"             dentro de aspas / aspas completas",
    "  i) / a)             dentro de parênteses / parênteses completos",
    "  ip / ap             parágrafo interno / parágrafo completo",
    "",
    "Search:",
    "  /texto              busca para frente",
    "  ?texto              busca para trás",
    "  n / N               próximo / anterior resultado",
    "  * / #               busca palavra sob cursor para frente/trás",
  },

  surround = {
    "# nvim-surround - Guia rápido",
    "",
    "Adicionar:",
    "  ysiw\"               coloca aspas na palavra atual",
    "  ysiw)               coloca parênteses na palavra atual",
    "  ysap]               coloca colchetes no parágrafo",
    "  S\"                  visual mode: envolve seleção com aspas",
    "",
    "Trocar:",
    "  cs\"'                troca aspas duplas por simples",
    "  cs)]                troca parênteses por colchetes",
    "  cst<div>            troca tag HTML/XML",
    "",
    "Remover:",
    "  ds\"                 remove aspas",
    "  ds)                 remove parênteses",
    "  dst                 remove tag HTML/XML",
    "",
    "Dica mental:",
    "  ysurround + motion + alvo",
    "  change surround + antigo + novo",
    "  delete surround + alvo",
  },

  multicursor = {
    "# vim-visual-multi - Guia rápido",
    "",
    "Fluxo principal:",
    "  Ctrl-n              seleciona próxima ocorrência da palavra/seleção",
    "  Ctrl-p              remove ocorrência anterior",
    "  n / N               navega entre cursores",
    "  Tab                 alterna modo cursor/extend",
    "  Esc                 sai do multi-cursor",
    "",
    "Uso recomendado:",
    "  1. Selecione uma palavra com o cursor.",
    "  2. Aperte Ctrl-n até pegar as ocorrências certas.",
    "  3. Edite como se fossem vários cursores.",
    "",
    "Se for refactor grande, prefira LSP rename em vez de multi-cursor.",
  },

  tasks = {
    "# Project Tasks - Guia rápido",
    "",
    "Atalhos:",
    "  <leader>mm          menu de tarefas",
    "  <leader>mi          info do projeto detectado",
    "  <leader>mb          build",
    "  <leader>mr          run",
    "  <leader>md          dev server em tmux/terminal",
    "  <leader>mt          test",
    "  <leader>mc          check/typecheck",
    "  <leader>ml          lint",
    "  <leader>mf          format",
    "  <leader>mx          clean",
    "",
    "Detecta: Node, Python, Go, Rust, Java, C/C++, Arduino, Docker, Make, CMake e mais.",
  },
}

local function open_sheet(title, lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

  local width = math.min(92, math.floor(vim.o.columns * 0.82))
  local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.82))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
    width = width,
    height = height,
    row = row,
    col = col,
  })

  vim.api.nvim_set_option_value("wrap", false, { win = win })
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true, desc = "Close cheatsheet" })
end

function M.open(name)
  local sheet = sheets[name]
  if not sheet then
    vim.notify("Cheatsheet not found: " .. tostring(name), vim.log.levels.WARN, { title = "Cheatsheets" })
    return
  end
  open_sheet(name, sheet)
end

function M.setup()
  vim.api.nvim_create_user_command("VimMotions", function()
    M.open("motions")
  end, {})
  vim.api.nvim_create_user_command("SurroundHelp", function()
    M.open("surround")
  end, {})
  vim.api.nvim_create_user_command("MulticursorHelp", function()
    M.open("multicursor")
  end, {})
  vim.api.nvim_create_user_command("ProjectTasksHelp", function()
    M.open("tasks")
  end, {})
end

return M
