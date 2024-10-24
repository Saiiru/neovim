-- Tentando carregar o módulo 'plenary.async' para funcionalidades assíncronas, com tratamento de erro
local async_ok, async = pcall(require, "plenary.async")
local u = require("config.functions.utils") -- Carrega utilidades personalizadas

-- Comando para capturar uma screenshot, mapeado para 'SCREENSHOT'
vim.api.nvim_create_user_command('SCREENSHOT', function()
  require("functions").screenshot()
end, { nargs = 0 })

-- Comando para recarregar módulos com um argumento opcional (caminho do módulo)
vim.api.nvim_create_user_command("RL", function(opts)
  require("functions").reload(opts.args)
end, { nargs = "*" })

-- Comando para recarregar o módulo atual (buffer atual)
vim.api.nvim_create_user_command("RLC", function()
  require("functions").reload_current()
end, { nargs = 0 })

-- Comando para criar atalhos personalizados
vim.api.nvim_create_user_command("SC", function()
  require("functions").shortcut()
end, { nargs = 0 })

-- Comando para tornar um arquivo executável com permissão de execução (chmod +x)
vim.api.nvim_create_user_command("EXEC", function()
  vim.api.nvim_command("silent ! chmod +x %:p")
end, { nargs = 0 })

-- Comando para stash no Git, gerando um nome com base na data e hora atual, se nenhum argumento for passado
vim.api.nvim_create_user_command("Stash", function(opts)
  local name = opts.args ~= "" and opts.args or u.get_date_time()
  name = string.gsub(name, "%s+", "_") -- Substitui espaços por underscores
  require("functions").stash(name)
  require("notify")(string.format("Stashed %s", name)) -- Notifica o usuário
end, { nargs = "?" })

-- Comando para configurar a conexão com o banco de dados SQL, com base no nome fornecido
vim.api.nvim_create_user_command("SQL", function(opts)
  local db = opts.args
  local var_table = require("env." .. db) -- Carrega variáveis de ambiente para o banco especificado
  require("psql").setup(var_table)
  require("notify")("PSQL set to " .. db) -- Notifica a troca de banco
end, { nargs = 1 })

-- Comando para formatar o conteúdo do buffer atual usando 'jq' (para JSON)
vim.api.nvim_create_user_command("JQ", function()
  vim.api.nvim_command(".!jq .")
end, { nargs = 0 })

-- Comando para abrir o sistema de arquivos usando um script personalizado
vim.api.nvim_create_user_command("Filesystem", function()
  require("functions").run_script("open_filesystem")
end, { nargs = 0 })

-- Comando para fechar todos os buffers, exceto o atual
vim.api.nvim_create_user_command("BufOnly", function()
  require("functions").buf_only()
end, { nargs = 0 })

-- Comando para desativar sugestões automáticas para aprendizado prático
vim.api.nvim_create_user_command("Learn", function()
  vim.cmd("LspStop") -- Desativa o LSP
  vim.cmd("Copilot disable") -- Desativa o Copilot
  require("cmp").setup({ enabled = false }) -- Desativa o autocompletar
  require("notify")("Editor hints disabled, good luck!", "info")
end, { nargs = 0 })

-- Comando para abrir uma janela de diff com uma branch (ou 'develop' por padrão)
vim.api.nvim_create_user_command("Diff", function(opts)
  local branch = opts.args ~= "" and opts.args or "develop"
  vim.api.nvim_feedkeys(":Gvdiffsplit " .. branch .. ":%", "n", false) -- Abre um diff entre o buffer atual e a branch
  u.press_enter() -- Simula o pressionamento de Enter
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>L<C-w>h", false, true, true), "n", false) -- Alterna entre as janelas
  vim.api.nvim_feedkeys("sh", "n", false) -- Ação de conclusão
end, { nargs = "*" })

-- Comando para redirecionar a saída de um comando Vim para um novo buffer
vim.api.nvim_create_user_command('Redir', function(ctx)
  local lines = vim.split(vim.api.nvim_exec(ctx.args, true), '\n', { plain = true }) -- Executa o comando e separa a saída por linhas
  vim.cmd('new') -- Abre um novo buffer
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines) -- Insere as linhas no novo buffer
  vim.opt_local.modified = false -- Marca o buffer como não modificado
end, { nargs = '+', complete = 'command' })

-- Configuração de quickfix com git diff, gerando uma lista de mudanças para revisão
vim.cmd([[
  command -nargs=? -bar ReviewChanges call setqflist(map(systemlist("git diff --name-only <args>"), '{"filename": v:val, "lnum": 1}'))
]])

-- Carrega listas de quickfix salvas
vim.cmd([[
  if exists('g:loaded_hqf')
      finish
  endif
  let g:loaded_hqf = 1

  function! s:load_file(type, bang, file) abort
      let l:efm = &l:efm
      let &l:errorformat = "%-G%f:%l: All of '%#%.depend'%.%#,%f%.%l col %c%. %m"
      let l:cmd = a:bang ? 'getfile' : 'file'
      exec a:type.l:cmd.' '.a:file
      let &l:efm = l:efm
      execute 'copen' -- Abre a janela de quickfix
  endfunction

  command! -complete=file -nargs=1 -bang Qfl call <SID>load_file('c', <bang>0, <f-args>)
]])

-- Função para redirecionar a saída de um comando para uma nova tab ou split
vim.cmd([[
function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    tabnew -- Abre em uma nova aba
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)
]])

-- Comando para converter um arquivo markdown em PDF via Pandoc
vim.api.nvim_create_user_command("PDF", function()
  local filename = u.copy_file_name(true) -- Pega o nome do arquivo atual
  local no_extension = u.strip_extension(filename) -- Remove a extensão
  local pdf = no_extension .. ".pdf"
  if u.file_exists(pdf) then
    u.remove_file(pdf) -- Remove o PDF antigo, se já existir
  end

  local plenary_ok, job = pcall(require, "plenary.job")
  if not plenary_ok then
    require("notify")("Could not load Plenary.", vim.log.levels.ERROR)
    return
  end

  job:new({
    command = 'pandoc',
    args = { '-V', 'colorlinks=true', '-V', 'linkcolor=blue', '-i', filename, "-o", pdf },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")("Could not create " .. pdf, vim.log.levels.ERROR)
      else
        vim.notify(pdf .. " created!", vim.log.levels.INFO)
        vim.cmd("silent !open " .. pdf) -- Abre o PDF
      end
    end),
  }):start()
end, {
  nargs = 0,
})

-- Comando para alternar entre modo de quebra de linha (wrap)
vim.api.nvim_create_user_command('WRAP', function()
  if vim.wo.wrap then
    vim.cmd("set nowrap")
    vim.cmd("set nolinebreak")
  else
    vim.cmd("set wrap")
    vim.cmd("set linebreak")
  end
end, { nargs = 0 })

