local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "cfor",
    fmt(
      [[
for (int i = {}; i < {}; i{}) {{
  {}
}}
]],
      {
        i(1, "0"),
        i(2, "n"),
        i(3, "++"),
        i(4),
      }
    )
  ),
  s(
    "boil",
    fmt(
      [[
#include <bits/stdc++.h>
using namespace std;

int main() {{
  {}
  return 0;
}}
]],
      { i(1) }
    )
  ),
}
