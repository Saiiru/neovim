local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "compo",
    fmt(
      [[
const {} = ({}) => {{
  {}
  return (
    <>
      {}
    </>
  )
}}

export {{ {} }}
]],
      {
        i(1, "Compo"),
        i(2),
        i(3),
        i(4),
        rep(1),
      }
    )
  ),
  s(
    "rimg",
    fmt(
      [[
<img src="{}" alt="{}" />
]],
      {
        i(1),
        i(2),
      }
    )
  ),
  s(
    "rinput",
    fmt(
      [[
<input type="{}" name="{}" />
]],
      {
        i(1, "text"),
        i(2, "name"),
      }
    )
  ),
  s("rhr", t "<hr />"),
  s("rbr", t "<br />"),
}
