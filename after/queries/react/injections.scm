; Extensões de arquivos para injeção de estilo
((style_element
  (raw_text) @injection.content)
 (#set! injection.language "scss"))

; Para arquivos Vue (.vue)
((vue
  (style_element
    (raw_text) @injection.content)
  (#set! injection.language "scss")))

; Para arquivos React (.jsx, .tsx)
((jsx
  (style_element
    (raw_text) @injection.content)
  (#set! injection.language "scss")))

((tsx
  (style_element
    (raw_text) @injection.content)
  (#set! injection.language "scss")))

; Para arquivos JavaScript (.js)
((javascript
  (style_element
    (raw_text) @injection.content)
  (#set! injection.language "scss")))

; Para arquivos Node.js (.js)
((javascript
  (script_element
    (raw_text) @injection.content)
  (#set! injection.language "scss")))

; Para arquivos CSS (.css)
((css
  (raw_text) @injection.content)
  (#set! injection.language "scss"))

