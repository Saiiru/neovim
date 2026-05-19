local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "tych",
    fmt(
      [[
try {{
  {}
}} catch ({}) {{
  {}
}}
]],
      {
        i(1),
        i(2, "error"),
        i(3),
      }
    )
  ),
  s(
    "req",
    fmt(
      [[
const {} = require("{}");
]],
      {
        i(1, "moduleName"),
        i(2, "module"),
      }
    )
  ),
  s("rex", t('const express = require("express");')),
  s("exrout", t('const router = require("express").Router();')),
  s("dotenv", t('require("dotenv").config();')),
}
