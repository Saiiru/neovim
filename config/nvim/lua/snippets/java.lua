local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "main",
    fmt(
      [[
public static void main(String[] args) {{
    {}
}}
]],
      {
        i(1),
      }
    )
  ),
  s(
    "class",
    fmt(
      [[
public class {} {{
    {}
}}
]],
      {
        i(1, "ClassName"),
        i(2),
      }
    )
  ),
  s(
    "record",
    fmt(
      [[
public record {}({}) {{
}}
]],
      {
        i(1, "RecordName"),
        i(2),
      }
    )
  ),
  s("sout", t 'System.out.println("");'),
  s(
    "rest",
    fmt(
      [[
@RestController
@RequestMapping("{}")
public class {}Controller {{
    {}
}}
]],
      {
        i(1, "/api"),
        i(2, "Sample"),
        i(3),
      }
    )
  ),
  s(
    "service",
    fmt(
      [[
@Service
public class {}Service {{
    {}
}}
]],
      {
        i(1, "Sample"),
        i(2),
      }
    )
  ),
  s(
    "repo",
    fmt(
      [[
public interface {}Repository extends JpaRepository<{}, Long> {{
}}
]],
      {
        i(1, "Sample"),
        i(2, "SampleEntity"),
      }
    )
  ),
  s(
    "entity",
    fmt(
      [[
@Entity
public class {} {{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    {}
}}
]],
      {
        i(1, "SampleEntity"),
        i(2),
      }
    )
  ),
  s(
    "test",
    fmt(
      [[
@Test
void {}() {{
    {}
}}
]],
      {
        i(1, "shouldDoThing"),
        i(2),
      }
    )
  ),
  s(
    "getter",
    fmt(
      [[
public {} get{}() {{
    return {};
}}
]],
      {
        i(1, "String"),
        i(2, "Value"),
        i(3, "value"),
      }
    )
  ),
  s(
    "setter",
    fmt(
      [[
public void set{}({} {}) {{
    this.{} = {};
}}
]],
      {
        i(1, "Value"),
        i(2, "String"),
        i(3, "value"),
        rep(3),
        rep(3),
      }
    )
  ),
}
