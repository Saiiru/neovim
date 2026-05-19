local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "main",
    fmt(
      [[
package main

import "fmt"

func main() {{
  {}
}}
]],
      {
        i(1, 'fmt.Println("hello")'),
      }
    )
  ),
  s(
    "iferr",
    fmt(
      [[
if err != nil {{
  {}
}}
]],
      {
        i(1, "return err"),
      }
    )
  ),
  s(
    "fn",
    fmt(
      [[
func {}({}) {} {{
  {}
}}
]],
      {
        i(1, "name"),
        i(2),
        i(3),
        i(4),
      }
    )
  ),
  s(
    "test",
    fmt(
      [[
func Test{}(t *testing.T) {{
  {}
}}
]],
      {
        i(1, "Name"),
        i(2),
      }
    )
  ),
  s("print", t 'fmt.Println("")'),
}
