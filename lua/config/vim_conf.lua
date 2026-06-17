-- Vim Configuration
-- Core Neovim settings
-- Extracted and adapted from nvpunk's vim_conf.lua

local M = {}

-- Apply all vim options
function M.setup()
  local opts = {
    -- Core
    backup = false,
    clipboard = "unnamedplus",
    cmdheight = 1,
    completeopt = { "menuone", "noselect" },
    conceallevel = 0,
    fileencoding = "utf-8",
    hlsearch = true,
    ignorecase = true,
    smartcase = true,
    mouse = "a",
    pumheight = 10,
    showmode = false,
    showtabline = 2,
    smartindent = true,
    splitbelow = true,
    splitright = true,
    swapfile = false,
    termguicolors = true,
    undofile = true,
    updatetime = 300,
    writebackup = false,
    expandtab = true,
    shiftwidth = 2,
    tabstop = 2,
    cursorline = true,
    number = true,
    relativenumber = true,
    signcolumn = "yes:2",
    wrap = false,
    linebreak = true,
    scrolloff = 8,
    sidescrolloff = 8,
    colorcolumn = "100",
    timeoutlen = 500,
    undofile = true,
    mousescroll = "ver:3,hor:6",
    guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,i-v-c-ci-cr-sm-o:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175",
    fillchars = {
      eob = " ",
      fold = " ",
      foldopen = "▾",
      foldclose = "▸",
      foldsep = "│",
      diff = "╱",
    },
    shortmess = "filnxtToOFWIcC",
    whichwrap = "b,s,<,>,[,],h,l",
    sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions",
    viewoptions = "cursor,folds,slash,unix",
    diffopt = "internal,filler,closeoff,algorithm:patience,indent-heuristic,linematch:60",
    completeopt = "menuone,noselect,preview",
    wildmode = "longest:full,full",
    wildignorecase = true,
    wildignore = {
      "*.o", "*.obj", "*.pyc", "*.class",
      "*.git", "*.hg", "*.svn",
      "node_modules", "__pycache__", ".venv", "venv",
      "*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp",
      "*.pdf", "*.zip", "*.tar.gz", "*.tar.bz2",
      "*.exe", "*.dll", "*.so", "*.dylib",
    },
    listchars = {
      tab = "→ ",
      trail = "·",
      extends = "»",
      precedes = "«",
      nbsp = "␣",
    },
  }
  
  for k, v in pairs(opts) do
    vim.opt[k] = v
  end
  
  -- Filetype detection
  vim.filetype.add({
    extension = {
      cshtml = "aspnetcorerazor",
      edge = "edge",
      eex = "eelixir",
      ejs = "ejs",
      gohtml = "gohtml",
      gohtmltmpl = "gohtmltmpl",
      gowork = "gowork",
      gotmpl = "gotmpl",
      handlebars = "handlebars",
      hbs = "hbs",
      jade = "jade",
      leaf = "leaf",
      mdx = "mdx",
      mustache = "mustache",
      njk = "njk",
      nunjucks = "nunjucks",
      pcss = "postcss",
      razor = "razor",
      re = "reason",
      sss = "sugarss",
      templ = "templ",
      ino = "arduino",
      cs = "csharp",
    },
    filename = {
      ["go.work"] = "gowork",
    },
    pattern = {
      [".*%.blade%.php"] = "blade",
      [".*%.django%.html"] = "django-html",
      [".*%.djhtml"] = "django-html",
      [".*%.html%.eex"] = "html-eex",
      [".*%.ino$"] = "arduino",
    },
  })
  
  -- Disable some builtin plugins
  local disabled_builtins = {
    "gzip", "zip", "zipPlugin", "tar", "tarPlugin",
    "getscript", "getscriptPlugin", "vimball", "vimballPlugin",
    "2html_plugin", "matchit", "matchparen", "logipat",
    "rrhelper", "spellfile_plugin", "netrw", "netrwPlugin",
    "netrwSettings", "netrwFileHandlers", "tutor",
  }
  
  for _, plugin in ipairs(disabled_builtins) do
    vim.g["loaded_" .. plugin] = 1
  end
  
  -- Provider settings
  vim.g.loaded_python3_provider = 1
  vim.g.loaded_node_provider = 1
  vim.g.loaded_perl_provider = 1
  vim.g.loaded_ruby_provider = 1
  
  -- Leader keys
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
  
  -- Theme default
  vim.g.theme = "noir"
  vim.g.theme_variant = "dark"
end

return M