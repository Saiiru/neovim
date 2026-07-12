return {
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local i = ls.insert_node
      local fmt = require("luasnip.extras.fmt").fmt

      local function snip(trig, name, dscr, body, nodes)
        return s({ trig = trig, name = name, dscr = dscr }, fmt(body, nodes or {}))
      end

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })

      ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        region_check_events = "CursorMoved,CursorHold,InsertEnter",
        delete_check_events = "TextChanged,InsertLeave",
        enable_autosnippets = false,
      })

      ls.add_snippets("go", {
        snip("err", "Go error guard", "Expands to: if err != nil { return err }", [[if err != nil {{
	return {}
}}]], { i(1, "err") }),
        snip("errnil", "Go return nil error", "Expands to: if err != nil { return nil, err }", [[if err != nil {{
	return {}, err
}}]], { i(1, "nil") }),
        snip("errwrap", "Go wrapped error", "Expands to: return nil, fmt.Errorf(...: %w, err)", [[if err != nil {{
	return {}, fmt.Errorf("{}: %w", err)
}}]], { i(1, "nil"), i(2, "operation failed") }),
        snip("tabletest", "Go table test", "Creates a t.Run table-driven test skeleton", [[func Test{}(t *testing.T) {{
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
}}]], { i(1, "Name"), i(2), i(3, "case"), i(4) }),
      })

      ls.add_snippets("python", {
        snip("main", "Python main guard", "Creates def main() and if __name__ == '__main__' guard", [[def main() -> None:
    {}


if __name__ == "__main__":
    main()]], { i(1, "pass") }),
        snip("trylog", "Python try/log/raise", "Wraps code in try/except, logs exception, then raises", [[try:
    {}
except {} as {}:
    logger.exception("{}")
    raise]], { i(1, "pass"), i(2, "Exception"), i(3, "e"), i(4, "operation failed") }),
        snip("withopen", "Python with open", "Creates a with open(..., encoding='utf-8') block", [[with open({}, "{}", encoding="utf-8") as {}:
    {}]], { i(1, "path"), i(2, "r"), i(3, "f"), i(4, "pass") }),
        snip("pytest", "Pytest test function", "Creates a simple pytest test skeleton", [[def test_{}() -> None:
    {}
    assert {}]], { i(1, "behavior"), i(2, "result = None"), i(3, "result is None") }),
        snip("fastapi", "FastAPI app skeleton", "Creates FastAPI app and one GET route", [[from fastapi import FastAPI

app = FastAPI()


@app.get("/{}")
def {}() -> dict[str, str]:
    return {{"status": "ok"}}]], { i(1, "path"), i(2, "handler") }),
      })

      ls.add_snippets("typescript", {
        snip("typeimp", "Type-only import", "Creates: import type { Name } from 'module'", [[import type {{ {} }} from "{}";]], { i(1, "Name"), i(2, "module") }),
        snip("awaittry", "Await with try/catch", "Wraps an awaited promise in try/catch", [[try {{
	const {} = await {};
	{}
}} catch ({}) {{
	console.error({});
}}]], { i(1, "result"), i(2, "promise"), i(3), i(4, "error"), i(5, "error") }),
        snip("react", "React component", "Creates an exported React function component", [[export function {}() {{
	return (
		<div>
			{}
		</div>
	);
}}]], { i(1, "Component"), i(2) }),
        snip("test", "JS/TS test block", "Creates describe/it test skeleton", [[describe("{}", () => {{
	it("{}", () => {{
		{};
	}});
}});]], { i(1, "unit"), i(2, "works"), i(3, "expect(true).toBe(true)") }),
      })
      ls.filetype_extend("typescriptreact", { "typescript" })
      ls.filetype_extend("javascript", { "typescript" })
      ls.filetype_extend("javascriptreact", { "typescript" })

      ls.add_snippets("c", {
        snip("main", "C main", "Creates int main(void) skeleton", [[int main(void) {{
	{}
	return 0;
}}]], { i(1) }),
        snip("checknull", "C null guard", "Checks pointer against NULL, prints error, returns code", [[if ({} == NULL) {{
	fprintf(stderr, "{} is NULL\n");
	return {};
}}]], { i(1, "ptr"), i(2, "ptr"), i(3, "1") }),
        snip("guard", "C header guard", "Creates #ifndef/#define/#endif header guard", [[#ifndef {}
#define {}

{}

#endif /* {} */]], { i(1, "HEADER_H"), i(2, "HEADER_H"), i(3), i(4, "HEADER_H") }),
      })

      ls.add_snippets("cpp", {
        snip("try", "C++ try/catch", "Wraps code in try/catch(const std::exception& e)", [[try {{
	{}
}} catch (const std::exception& {}) {{
	std::cerr << {}.what() << std::endl;
}}]], { i(1), i(2, "e"), i(3, "e") }),
      })

      ls.add_snippets("rust", {
        snip("test", "Rust test", "Creates #[test] function skeleton", [[#[test]
fn {}() {{
    {}
}}]], { i(1, "it_works"), i(2, "assert!(true);") }),
        snip("res", "Rust Result function", "Creates fn run() -> Result<(), Error> skeleton", [[fn {}() -> Result<(), {}> {{
    {}
    Ok(())
}}]], { i(1, "run"), i(2, "Box<dyn std::error::Error>"), i(3) }),
      })

      ls.add_snippets("lua", {
        snip("pcall", "Lua protected require", "Requires module with pcall and warns on failure", [[local ok, {} = pcall(require, "{}")
if not ok then
	vim.notify("failed to load {}", vim.log.levels.WARN)
	return
end
{}]], { i(1, "mod"), i(2, "module"), i(3, "module"), i(4) }),
        snip("usercmd", "Neovim user command", "Creates vim.api.nvim_create_user_command skeleton", [[vim.api.nvim_create_user_command("{}", function(args)
	{}
end, {{ nargs = "{}", desc = "{}" }})]], { i(1, "Command"), i(2), i(3, "*"), i(4, "description") }),
      })

      ls.add_snippets("arduino", {
        snip("sketch", "Arduino sketch", "Creates setup()/loop() with Serial.begin", [[void setup() {{
	Serial.begin({});
	{}
}}

void loop() {{
	{}
}}]], { i(1, "115200"), i(2), i(3) }),
        snip("debounce", "Arduino debounce block", "Creates millis()-based debounce guard", [[static unsigned long last_ms = 0;
if (millis() - last_ms > {}) {{
	last_ms = millis();
	{}
}}]], { i(1, "200"), i(2) }),
      })
      ls.filetype_extend("cpp", { "arduino" })
    end,
  },
  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = { { "<leader>cn", "<cmd>Neogen<cr>", desc = "Generate annotation" } },
    opts = {
      enabled = true,
      languages = { python = { template = { annotation_convention = "google_docstrings" } } },
    },
  },
}
