-- lua/config/icons.lua
-- Fonte única de verdade para ícones, kinds, labels de LSP e filetype.
-- Usado por: lualine, blink, telescope, trouble, oil, etc.
-- Otimizado com Nerd Fonts v3.0+ | Batman Industrial Noir color scheme

local M = {}

-- ── Ícones genéricos do sistema (expanded com nerd fonts) ─────────────────────
M.misc = {
  bat       = "󰭟",
  branch    = "",
  lsp       = "󰄲",
  position  = "󰇚",
  encoding  = "󰈙",
  file      = "󰈙",
  modified  = "●",
  readonly  = "󰌾",
  separator = "│",
  zoom      = "󰁌",
  session   = "󰓪",
  time      = "",
  cwd       = "",

  -- UI & Viewport (refined nerd fonts)
  pin       = "󰐃",
  unpin     = "󰐂",
  split     = "󰤼",
  hsplit    = "󰤽",
  vsplit    = "󰤽",
  maximize  = "󰦍",
  minimize  = "󰦌",
  fold_open = "󰅂",
  fold_closed = "󰅀",
  sidebar   = "󰘙",

  -- Search & Replace
  search    = "󰍉",
  replace   = "󰒕",
  regex     = "󰞙",

  -- Diagnostics
  error     = "",
  warning   = "",
  info      = "󰋼",
  hint      = "󰌶",

  -- Build & Run
  build     = "󰦗",
  run       = "󰐆",
  debug     = "󰃤",
  terminal  = "󰆍",
  output    = "󰗚",

  -- Git
  git       = "󰊢",
  merge     = "󰔀",
  conflict  = "󰞾",
  stash     = "󰒉",
  pull      = "󰘻",
  push      = "󰘒",
  fetch     = "󰘻",
  rebase    = "󰡎",

  -- File Operations
  new       = "󰻭",
  trash     = "󰩹",
  save      = "󰆓",
  undo      = "󰕌",
  redo      = "󰕍",
  copy      = "󰆐",
  paste     = "󰅖",
  delete    = "󰆴",

  -- Testing
  test_pass = "󰄬",
  test_fail = "󰄭",
  test      = "󰙨",

  -- Misc IDE
  breakpoint = "󰨂",
  paused     = "󰏊",
  watch      = "󰔍",
  bookmark   = "󰆤",
  lightbulb  = "󰌶",
  note       = "󰒳",
  comment    = "󰅺",
}

-- ── Kinds do completion (blink / cmp) ───────────────────────────────────────
M.kind = {
  Text          = "",
  Method        = "󰆧",
  Function      = "󰊕",
  Constructor   = "",
  Field         = "󰇽",
  Variable      = "󰂡",
  Class         = "󰠱",
  Interface     = "",
  Module        = "",
  Property      = "󰜢",
  Unit          = "",
  Value         = "󰎠",
  Enum          = "",
  Keyword       = "󰌋",
  Snippet       = "",
  Color         = "󰏘",
  File          = "󰈙",
  Reference     = "",
  Folder        = "󰉋",
  EnumMember    = "",
  Constant      = "󰏿",
  Struct        = "󰙅",
  Event         = "",
  Operator      = "󰆕",
  TypeParameter = "󰊄",
  -- Adicionais
  Macro         = "󰎕",
  Null          = "󰟢",
  Variable_Instance = "󰂀",
}

-- ── Labels curtos de LSP para statusline ─────────────────────────────────────
M.lsp_labels = {
  ts_ls                             = "TS",
  vtsls                             = "TS",
  eslint                            = "ESL",
  lua_ls                            = "LUA",
  pyright                           = "PY",
  basedpyright                      = "PY",
  ruff                              = "RF",
  gopls                             = "GO",
  rust_analyzer                     = "RS",
  jdtls                             = "JAVA",
  kotlin_language_server            = "KT",
  jsonls                            = "JSON",
  yamlls                            = "YML",
  bashls                            = "SH",
  taplo                             = "TOML",
  marksman                          = "MD",
  texlab                            = "TEX",
  ltex_plus                         = "LTEX",
  ltex                              = "LTEX",
  html                              = "HTML",
  cssls                             = "CSS",
  tailwindcss                       = "TW",
  dockerls                          = "DBG",
  docker_compose_language_service   = "CMP",
  nil_ls                            = "NIX",
  zls                               = "ZIG",
  clangd                            = "C",
  csharp_ls                         = "C#",
  vimls                             = "VIM",
  vuels                             = "VUE",
  svelte_ls                         = "SVT",
  astro                             = "ASTRO",
}

-- ── Labels curtos de filetype para statusline ────────────────────────────────
M.filetype_labels = {
  lua             = "LUA",
  python          = "PY",
  javascript      = "JS",
  javascriptreact = "JSX",
  typescript      = "TS",
  typescriptreact = "TSX",
  tsx             = "TSX",
  jsx             = "JSX",
  go              = "GO",
  rust            = "RS",
  java            = "JAVA",
  kotlin          = "KT",
  json            = "JSON",
  jsonc           = "JSONC",
  yaml            = "YML",
  toml            = "TOML",
  markdown        = "MD",
  sh              = "SH",
  bash            = "SH",
  zsh             = "ZSH",
  c               = "C",
  cpp             = "C++",
  css             = "CSS",
  scss            = "SCSS",
  html            = "HTML",
  vue             = "VUE",
  svelte          = "SVT",
  astro           = "ASTRO",
  qml             = "QML",
  vim             = "VIM",
  csharp          = "C#",
  dotnet          = "DOT",
}

-- ── Pastas especiais / node_modules, dist, build, etc ───────────────────────
M.special_folders = {
  node_modules = "󰎕",
  ["venv"]         = "󰌠",
  ["env"]          = "󰌠",
  [".env"]         = "󰌠",
  [".git"]         = "󰊢",
  [".github"]      = "󰊢",
  [".gitignore"]   = "󰊢",
  [".vscode"]      = "󰨎",
  dist         = "󰏗",
  build        = "󰦗",
  out          = "󰗚",
  target       = "󰦗",
  [".next"]      = "󰒮",
  [".nuxt"]      = "󰑦",
  coverage     = "󰟫",
  [".backup"]    = "󰆧",
  cache        = "󰜛",
  tmp          = "󰓎",
  [".terraform"] = "󱁢",
  ["__pycache__"] = "󰌠",
  [".pytest_cache"] = "󰌠",
}

-- ── Status de Git (para extensões de UI) ─────────────────────────────────────
M.git_status = {
  added     = "󰜇",
  modified  = "󰏫",
  removed   = "󰛑",
  renamed   = "󰒕",
  untracked = "󰌗",
  ignored   = "󰦠",
  conflict  = "󰞾",
  ahead     = "󰶣",
  behind    = "󰶡",
  diverged  = "󰔀",
}

-- ── Extensões de arquivo (para tree/explorer) ───────────────────────────────
M.extensions = {
  js   = "󰌞",
  mjs  = "󰌞",
  cjs  = "󰌞",
  ts   = "󰛦",
  mts  = "󰛦",
  cts  = "󰛦",
  jsx  = "󰌞",
  tsx  = "󰛦",
  py   = "󰌠",
  pyi  = "󰌠",
  pyx  = "󰌠",
  lua  = "󰢱",
  go   = "󰎷",
  rs   = "󱘗",
  java = "󰌷",
  class = "󰌷",
  jar  = "󰌷",
  c    = "󰙱",
  cpp  = "󰙲",
  h    = "󰙴",
  hpp  = "󰙴",
  json = "󰘦",
  jsonc = "󰘦",
  yaml = "󰶐",
  yml  = "󰶐",
  toml = "󰟓",
  md   = "󰍉",
  markdown = "󰍉",
  txt  = "󰈙",
  sh   = "󰆕",
  zsh  = "󰆕",
  bash = "󰆕",
  fish = "󰈸",
  html = "󰌝",
  css  = "󰌜",
  scss = "󰌜",
  sass = "󰌜",
  less = "󰌜",
  vue  = "󰡄",
  svelte = "󰔎",
  astro = "󠘎",
  docker = "󰡨",
  dockerfile = "󰡨",
  git  = "󰊢",
  lock = "󰒉",
  sql  = "󰆼",
  r    = "󰟔",
  R    = "󰟔",
  rb   = "󰘧",
  kt   = "󰏯",
  swift = "apple",
  php  = "󰌆",
  groovy = "󰟉",
  gradle = "󰟉",
  xml  = "󰗀",
  vim  = "󰉋",
  config = "󰒓",
  env  = "󰌠",
}

-- ── Decoradores & Badges (para notificações, modificadores) ─────────────────
M.decorators = {
  unsaved    = "●",
  error_dot  = "●",
  warning_dot = "●",
  info_dot   = "●",
  hint_dot   = "●",
  running    = "⠋",  -- braille spinner
  waiting    = "⠙",  -- braille spinner
  success    = "✓",
  failed     = "✗",
  ellipsis   = "…",
  arrow_right = "→",
  arrow_left  = "←",
  chevron_right = ">",
  chevron_left  = "<",
  star       = "★",
  heart      = "♥",
  bolt       = "⚡",
  gear       = "⚙",
}

-- ── Helpers ───────────────────────────────────────────────────────────────────
function M.lsp_label(name)
  return M.lsp_labels[name] or name:upper()
end

function M.filetype_label(ft, ext)
  return M.filetype_labels[ft]
    or ((ft ~= "" and ft) or (ext and ext ~= "" and ext) or "TEXT"):upper()
end

--- Retorna ícone para extensão de arquivo.
function M.get_extension_icon(ext)
  return M.extensions[ext] or M.misc.file
end

--- Retorna ícone para pasta especial.
function M.get_folder_icon(name)
  return M.special_folders[name] or M.misc.folder
end

--- Retorna ícone para diagnóstico.
function M.get_diagnostic_icon(severity)
  if severity == "error" then
    return M.misc.error
  elseif severity == "warning" then
    return M.misc.warning
  elseif severity == "information" or severity == "info" then
    return M.misc.info
  else
    return M.misc.hint
  end
end

--- Retorna { icon, hl, label } para um filetype.
--- Usa mini.icons se disponível, senão retorna fallback limpo.
function M.get_filetype(ft, filename, ext)
  local ok, mini_icons = pcall(require, "mini.icons")
  local icon, hl = "", nil

  if ok and filename and filename ~= "" then
    local i, h = mini_icons.get("file", filename)
    if i and i ~= "" then
      icon, hl = i, h
    end
  end

  return {
    icon  = icon or "",
    hl    = hl,
    label = M.filetype_label(ft, ext),
  }
end

return M
