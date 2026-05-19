local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "comp",
    fmt(
      [[
<script lang="ts">
  {}
</script>

{}

<style>
  {}
</style>
]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
}
