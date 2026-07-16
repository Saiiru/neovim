# Sairu Neovim PDE

Base: `NickCrew/nvim-pde`.

Camada local: VEGA / mise-first / snippets práticos / comandos PDE.

## Backup

Antes de substituir a `main`, foi criada e publicada a tag:

```txt
backup-main-before-nickcrew-pde-2026-07-11-052845
```

Rollback rápido:

```bash
cd ~/dotfiles/config/nvim
git switch main
git reset --hard backup-main-before-nickcrew-pde-2026-07-11-052845
git push --force-with-lease origin main
```

## Arquitetura

```txt
mise      = linguagens / SDKs / CLIs / versões / tasks por projeto
Neovim    = editor / LSP client / completion / snippets / quickfix / git / task invocation
Projeto   = declara .mise.toml, pde.toml, package.json, go.mod, sketch.yaml etc.
Hermes    = auditor / briefing / manifesto
```

Regra principal:

```txt
Neovim não instala toolchain.
Neovim não instala SDK.
Neovim não faz flash automático.
Neovim chama apenas mise tasks locais do projeto.
Não existe fallback para tasks globais.
```

Mensagem determinística quando uma task não existe:

```txt
project does not define local mise task: X
```

Plugins Neovim são geridos por Lazy. Toolchains são do mise/projeto.

## Completion

Completion usa `nvim-cmp`.

Keymaps em insert mode:

```txt
<C-Space>   abrir completion
<C-n>       próximo item
<C-p>       item anterior
<Tab>       próximo item / expandir snippet / próximo campo
<S-Tab>     item anterior / campo anterior
<CR>        aceitar item selecionado
<C-y>       aceitar item selecionado
<C-e>       fechar completion
<C-b>       subir documentação
<C-f>       descer documentação
```

Sources configuradas:

```txt
nvim_lsp
luasnip
path
nvim_lua
buffer
cmdline
```

## Snippets no completion

Snippets aparecem no popup do completion.

Fluxo:

```txt
1. entra em insert mode
2. digita o trigger, exemplo: errwrap
3. aperta <C-Space> se o menu não abrir sozinho
4. seleciona o snippet
5. aceita com <Tab>, <CR> ou <C-y>
6. navega campos com <Tab>/<S-Tab>
```

Atalhos extras:

```txt
<C-j>       expandir/pular para próximo campo do snippet
<C-k>       voltar campo anterior do snippet
<leader>sl  listar snippets disponíveis
```

Comando útil:

```vim
:LuaSnipListAvailable
```

## Snippets práticos adicionados

Além de `friendly-snippets`, há snippets VEGA extras.

Go:

```txt
err
errnil
errwrap
tabletest
```

Exemplo:

```go
if err != nil {
	return nil, fmt.Errorf("operation failed: %w", err)
}
```

Python:

```txt
trylog
withopen
fastapi
```

TypeScript / JavaScript:

```txt
typeimp
awaittry
react
```

C/C++:

```txt
checknull
guard
try
```

Lua:

```txt
pcall
usercmd
```

Arduino:

```txt
sketch
debounce
```

## PDE commands

Comandos de projeto:

```vim
:PDEStatus
:PDEBuild
:PDETest
:PDELint
:PDEFormat
:PDETypecheck
:PDEDev
:PDERun
:PDEVersion
:PDEDoctor
:PDEOpenMise
:PDEOpenProjectConfig
:PDEQuickfix
```

Arduino/embedded:

```vim
:PDEBoards
:PDEArduinoProfile
:PDEArduinoCompileDB
:PDEArduinoCompile
:PDEArduinoUpload
:PDEArduinoFlash
:PDEArduinoMonitor
```

## PDE keymaps

```txt
<leader>ps  PDEStatus
<leader>pb  PDEBuild -> quickfix
<leader>pt  PDETest -> quickfix
<leader>pl  PDELint -> quickfix
<leader>pf  PDEFormat
<leader>pm  abrir .mise.toml
<leader>pc  abrir pde.toml
```

Arduino:

```txt
<leader>ab  boards
<leader>ap  profile
<leader>ac  compile -> quickfix
<leader>aC  compile DB
<leader>au  upload
<leader>af  flash
<leader>am  monitor
```

Quickfix:

```txt
[q          item anterior
]q          próximo item
<leader>qo  abrir quickfix
<leader>qc  fechar quickfix
```

LSP:

```txt
gd          definition
gD          declaration
gi          implementation
gr          references
K           hover
[d / ]d     diagnostics
<leader>ca  code action
<leader>cr  rename
<leader>cd  line diagnostic
```

## Como um projeto deve declarar tasks

Exemplo `.mise.toml`:

```toml
[tasks.build]
run = "cc -Wall -Wextra -std=c11 main.c -o main"

[tasks.lint]
run = "cc -Wall -Wextra -std=c11 -fsyntax-only main.c"

[tasks.test]
run = "echo define tests"

[tasks.pde-version]
run = "mise ls --current"
```

Nomes com aspas também são aceitos:

```toml
[tasks."arduino-compile"]
run = "arduino-cli compile"

[tasks.'typecheck']
run = "tsc --noEmit"
```

Então no Neovim:

```vim
:PDEStatus
:PDEBuild
```

Erros de build/lint/test vão para quickfix.

## Arduino contract

Projeto Arduino deve preferir:

```txt
sketch.yaml
.mise.toml
pde.toml
compile_commands.json
```

Contrato de status, sem ação de hardware:

```toml
# pde.toml
profile = "esp32"

[profiles.esp32]
fqbn = "esp32:esp32:esp32"
port = "/dev/ttyUSB0"
baud = 115200
compile_db = "compile_commands.json"
```

Contrato equivalente em `sketch.yaml`:

```yaml
default_profile: esp32
profiles:
  esp32:
    fqbn: esp32:esp32:esp32
    port: /dev/ttyUSB0
    baud: 115200
```

`:PDEStatus` / `:PDEArduinoProfile` leem esses campos e reportam:

```txt
profile
fqbn
port
baud
sketch.yaml
platformio.ini
pde.toml
compile_commands.json
compile db path
```

Esses comandos não fazem scan de porta, não instalam cores/libs, não abrem monitor,
não fazem upload e não fazem flash.

Exemplo tasks:

```toml
[tasks.arduino-compile]
run = "arduino-cli compile --fqbn esp32:esp32:esp32 sketch"

[tasks.arduino-compile-db]
run = "arduino-cli compile --fqbn esp32:esp32:esp32 --build-path build --only-compilation-database sketch"

[tasks.arduino-upload]
run = "arduino-cli upload -p ${ARDUINO_PORT:-/dev/ttyUSB0} --fqbn esp32:esp32:esp32 sketch"

[tasks.arduino-monitor]
run = "arduino-cli monitor -p ${ARDUINO_PORT:-/dev/ttyUSB0} -c baudrate=115200"

[tasks.arduino-flash]
depends = ["arduino-compile", "arduino-upload"]
```

Flash/upload só acontecem se você chamar explicitamente o comando.

## Teste rápido

```bash
mkdir -p /tmp/pde-smoke
cd /tmp/pde-smoke
cat > main.go <<'EOF'
package main

func main() {}
EOF
cat > .mise.toml <<'EOF'
[tasks.build]
run = "go build ./..."
EOF
nvim main.go
```

Dentro do Neovim:

```vim
:PDEStatus
:PDEBuild
```

Para snippet:

```txt
insert mode -> digita errwrap -> <C-Space> -> seleciona -> <CR>
```
