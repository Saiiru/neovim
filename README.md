# Neovim

Configuração pessoal de Neovim usada na workstation de Sairu e versionada separadamente dos dotfiles.

O foco é uma PDE pequena e previsível: edição rápida, descoberta por contexto de projeto e execução explícita de tarefas. Runtimes e ferramentas pertencem ao Mise; o Neovim apenas os consome.

## Requisitos

- Neovim recente
- Git
- Mise
- ferramentas opcionais conforme a linguagem do projeto

A configuração não instala plugins ou toolchains automaticamente durante a inicialização. O `lazy.nvim` precisa existir no diretório de dados do Neovim.

## Estrutura

```text
init.lua
lua/
├── autocmds.lua
├── mappings.lua
├── options.lua
├── pde/             detecção, comandos, tarefas e views
├── plugins/         specs do lazy.nvim por domínio
└── theme/           paleta e highlights compartilhados
```

## Uso

Abra o guia interno:

```vim
:PDEHelp
```

Comandos úteis:

```vim
:PDEStatus
:PDEOverview
:PDETemplates
:PDETask <nome>
:PDETmuxTask <nome>
:PDEOpenMise
```

A camada PDE detecta o contexto do projeto e usa tarefas declaradas pelo projeto/Mise em vez de manter comandos específicos espalhados por mappings.

## Instalação isolada

```bash
git clone git@github.com:Saiiru/neovim.git ~/.config/nvim
```

Dentro dos dotfiles, este repositório é usado como submódulo em `config/nvim`.

## Verificação

```bash
nvim --headless '+lua print("NVIM_OK")' +qa
```

Arquivos Lua podem ser validados com:

```bash
find . -name '*.lua' -print0 | xargs -0 -n1 luac -p
```

## Política

- Sem instalação silenciosa durante o startup.
- Sem segredos ou dados pessoais no repositório.
- Plugins desativados não permanecem como configuração morta.
- Mudanças devem preservar inicialização headless e passar pela validação Lua.
