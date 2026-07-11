return {
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local fmt = require("luasnip.extras.fmt").fmt

      require("luasnip.loaders.from_vscode").lazy_load()

      ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = false,
      })

      ls.add_snippets("go", {
        s("err", fmt([[if err != nil {{
	return {}
}}]], { i(1, "err") })),
        s("errnil", fmt([[if err != nil {{
	return {}, err
}}]], { i(1, "nil") })),
        s("errwrap", fmt([[if err != nil {{
	return {}, fmt.Errorf("{}: %w", err)
}}]], { i(1, "nil"), i(2, "operation failed") })),
        s("tabletest", fmt([[func Test{}(t *testing.T) {{
	tests := []struct {{
		name string
		{}
	}}{{
		{{name: "{}"}},
	}}

	for _, tt := range tests {{
		t.Run(tt.name, func(t *testing.T) {{
			{}
		}})
	}}
}}]], { i(1, "Name"), i(2), i(3, "case"), i(4) })),
      })

      ls.add_snippets("python", {
        s("trylog", fmt([[try:
    {}
except {} as {}:
    logger.exception("{}")
    raise]], { i(1, "pass"), i(2, "Exception"), i(3, "e"), i(4, "operation failed") })),
        s("withopen", fmt([[with open({}, "{}", encoding="utf-8") as {}:
    {}]], { i(1, "path"), i(2, "r"), i(3, "f"), i(4, "pass") })),
        s("fastapi", fmt([[from fastapi import FastAPI

app = FastAPI()


@app.get("/{}")
def {}() -> dict[str, str]:
    return {{"status": "ok"}}]], { i(1, "path"), i(2, "handler") })),
      })

      ls.add_snippets("typescript", {
        s("typeimp", fmt([[import type {{ {} }} from "{}";]], { i(1, "Name"), i(2, "module") })),
        s("awaittry", fmt([[try {{
	const {} = await {};
	{}
}} catch ({}) {{
	console.error({});
}}]], { i(1, "result"), i(2, "promise"), i(3), i(4, "error"), i(5, "error") })),
        s("react", fmt([[export function {}() {{
	return (
		<div>
			{}
		</div>
	);
}}]], { i(1, "Component"), i(2) })),
      })
      ls.filetype_extend("typescriptreact", { "typescript" })
      ls.filetype_extend("javascript", { "typescript" })
      ls.filetype_extend("javascriptreact", { "typescript" })

      ls.add_snippets("c", {
        s("checknull", fmt([[if ({} == NULL) {{
	fprintf(stderr, "{} is NULL\n");
	return {};
}}]], { i(1, "ptr"), i(2, "ptr"), i(3, "1") })),
        s("guard", fmt([[#ifndef {}
#define {}

{}

#endif /* {} */]], { i(1, "HEADER_H"), i(2, "HEADER_H"), i(3), i(4, "HEADER_H") })),
      })

      ls.add_snippets("cpp", {
        s("try", fmt([[try {{
	{}
}} catch (const std::exception& {}) {{
	std::cerr << {}.what() << std::endl;
}}]], { i(1), i(2, "e"), i(3, "e") })),
      })

      ls.add_snippets("lua", {
        s("pcall", fmt([[local ok, {} = pcall(require, "{}")
if not ok then
	vim.notify("failed to load {}", vim.log.levels.WARN)
	return
end
{}]], { i(1, "mod"), i(2, "module"), i(3, "module"), i(4) })),
        s("usercmd", fmt([[vim.api.nvim_create_user_command("{}", function(args)
	{}
end, {{ nargs = "{}", desc = "{}" }})]], { i(1, "Command"), i(2), i(3, "*"), i(4, "description") })),
      })

      ls.add_snippets("arduino", {
        s("sketch", fmt([[void setup() {{
	Serial.begin({});
	{}
}}

void loop() {{
	{}
}}]], { i(1, "115200"), i(2), i(3) })),
        s("debounce", fmt([[static unsigned long last_ms = 0;
if (millis() - last_ms > {}) {{
	last_ms = millis();
	{}
}}]], { i(1, "200"), i(2) })),
      })
      ls.filetype_extend("cpp", { "arduino" })
    end,
  },
  {
    "danymat/neogen",
    cmd = "Neogen",
    opts = {
      enabled = true,
      languages = { python = { template = { annotation_convention = "google_docstrings" } } },
    },
  },
}
