# LSP Servers Layout

Este diretório organiza os servers LSP em módulos pequenos e fáceis de manter.

## Servers não são Lang

`config/servers` guarda somente a configuração de cada LSP: `clangd`,
`lua_ls`, `pyright`, `ts_ls`, `arduino_language_server`, etc.

Uma camada `lang` é maior: ela pode juntar Treesitter, formatter, lint,
snippets, DAP, ftplugin e keymaps específicos daquela linguagem. Exemplo:
`lang/cpp.lua` poderia instalar `clangd`, `clang-format`, snippets C++ e DAP,
mas a configuração fina do server continuaria em `config/servers/clangd.lua`.

Regra prática: server é motor; lang é experiência de uso.

## Regra de cada arquivo

- Nome do arquivo: `<server>.lua`
- Retorno: função `function(ctx) return opts end`
- `ctx` contém:
  - `ctx.util` (`lspconfig.util`)
  - `ctx.schemastore` (quando aplicável)

Exemplo mínimo:

```lua
return function(_ctx)
  return {}
end
```

Exemplo com root:

```lua
return function(ctx)
  local util = ctx.util
  return {
    root_dir = util.root_pattern(".git", "package.json"),
  }
end
```

## Onde registrar

1. Adicione o módulo em `config/servers/init.lua`.
2. Se for server "simples", pode ficar em `simple.lua`.
3. Se tiver lógica própria, crie arquivo dedicado.

## Convenção prática

- Comentários no topo em PT-BR (TITLE/ABOUT).
- Evitar lógica pesada no loader principal.
- Preferir fallbacks seguros (não quebrar se binário não existir).
