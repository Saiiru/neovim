;; extends

; Custom namespace highlight
((identifier) @namespace.builtin
  (#eq? @namespace.builtin "Plugins"))

; Common Lua runtime namespaces
((identifier) @namespace.builtin
  (#match? @namespace.builtin "^(vim|Snacks|Mini|Lazy|Utils|Config)$"))

; require("mod") path as namespace
(function_call
  name: (identifier) @function.builtin
  arguments: (arguments
    (string
      content: (string_content) @namespace))
  (#eq? @function.builtin "require"))

; vim.api / vim.fn / vim.loop / vim.uv as builtins
(dot_index_expression
  table: (identifier) @module
  field: (identifier) @field
  (#eq? @module "vim")
  (#match? @field "^(api|fn|uv|loop|lsp|diagnostic|treesitter)$")
  ) @namespace.builtin

; Method calls starting with setup/config/new
(function_call
  name: (method_index_expression
    method: (identifier) @function.method.call)
  (#match? @function.method.call "^(setup|config|new|init)$"))

; Keymap/setter helpers
((identifier) @function.builtin
  (#match? @function.builtin "^(map|keymap|set|setup|notify|cmd)$"))

; Highlight uppercase constants and env-like vars
((identifier) @constant
  (#match? @constant "^[A-Z][A-Z0-9_]+$"))

; TODO/FIXME/NOTE tags inside comments
((comment) @comment.todo
  (#match? @comment.todo "(TODO|FIXME|NOTE|HACK|WARN)"))
