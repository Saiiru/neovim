local M = {}

M.items = {
  c = {
    main = [[#include <stdio.h>

int main(void) {
	$0
	return 0;
}]],
    inc = [[#include <${1:stdio.h}>$0]],
    incl = [[#include "${1:header.h}"$0]],
    guard = [[#ifndef ${1:HEADER_H}
#define ${1:HEADER_H}

$0

#endif /* ${1:HEADER_H} */]],
    fori = [[for (int ${1:i} = 0; ${1:i} < ${2:n}; ${1:i}++) {
	$0
}]],
    printf = [[printf("${1:%s}\\n", ${2:value});$0]],
    fprintf = [[fprintf(stderr, "${1:error}: %s\\n", ${2:message});$0]],
    checknull = [[if (${1:ptr} == NULL) {
	fprintf(stderr, "${2:null pointer}: %s\\n", "${1:ptr}");
	return ${3:1};
}
$0]],
  },
  cpp = {
    main = [[#include <iostream>

int main() {
	$0
	return 0;
}]],
    inc = [[#include <${1:iostream}>$0]],
    incl = [[#include "${1:header.hpp}"$0]],
    cout = [[std::cout << ${1:value} << std::endl;$0]],
    cerr = [[std::cerr << ${1:error} << std::endl;$0]],
    class = [[class ${1:Name} {
public:
	${1:Name}();
	~${1:Name}();

private:
	$0
};]],
    try = [[try {
	$1
} catch (const std::exception& ${2:e}) {
	std::cerr << ${2:e}.what() << std::endl;
	$0
}]],
  },
  lua = {
    req = [[local ${1:name} = require("${2:module}")$0]],
    pcall = [[local ok, ${1:mod} = pcall(require, "${2:module}")
if not ok then
	vim.notify("failed to load ${2:module}", vim.log.levels.WARN)
	return
end
$0]],
    fn = [[local function ${1:name}(${2:args})
	$0
end]],
    mod = [[local M = {}

function M.${1:name}(${2:args})
	$0
end

return M]],
    autocmd = [[vim.api.nvim_create_autocmd("${1:FileType}", {
	group = vim.api.nvim_create_augroup("${2:GroupName}", { clear = true }),
	pattern = { "${3:lua}" },
	callback = function(args)
		$0
	end,
})]],
    usercmd = [[vim.api.nvim_create_user_command("${1:Command}", function(args)
	$0
end, { nargs = "${2:*}", desc = "${3:description}" })]],
  },
  python = {
    main = [[def main() -> None:
    $0


if __name__ == "__main__":
    main()]],
    imp = [[import ${1:os}$0]],
    from = [[from ${1:pathlib} import ${2:Path}$0]],
    fn = [[def ${1:name}(${2:args}) -> ${3:None}:
    $0]],
    cls = [[class ${1:Name}:
    def __init__(self) -> None:
        $0]],
    try = [[try:
    $1
except ${2:Exception} as ${3:e}:
    ${4:raise $3}]],
    trylog = [[try:
    $1
except ${2:Exception} as ${3:e}:
    logger.exception("${4:operation failed}")
    raise]],
    withopen = [[with open(${1:path}, "${2:r}", encoding="utf-8") as ${3:f}:
    $0]],
    dataclass = [[from dataclasses import dataclass


@dataclass
class ${1:Name}:
    ${2:field}: ${3:str}
]],
    pytest = [[def test_${1:name}() -> None:
    $0]],
    fastapi = [[from fastapi import FastAPI

app = FastAPI()


@app.get("/${1:path}")
def ${2:handler}() -> dict[str, str]:
    return {"status": "ok"}
]],
  },
  javascript = {
    imp = [[import ${1:name} from "${2:module}";$0]],
    imn = [[import { ${1:name} } from "${2:module}";$0]],
    fn = [[function ${1:name}(${2:args}) {
	$0
}]],
    afn = [[const ${1:name} = (${2:args}) => {
	$0
};]],
    log = [[console.log(${1:value});$0]],
    warn = [[console.warn(${1:value});$0]],
    error = [[console.error(${1:error});$0]],
    try = [[try {
	$1
} catch (${2:error}) {
	console.error(${2:error});
	$0
}]],
    async = [[const ${1:name} = async (${2:args}) => {
	$0
};]],
    awaittry = [[try {
	const ${1:result} = await ${2:promise};
	$0
} catch (${3:error}) {
	console.error(${3:error});
}]],
  },
  typescript = {
    imp = [[import ${1:name} from "${2:module}";$0]],
    imn = [[import { ${1:name} } from "${2:module}";$0]],
    typeimp = [[import type { ${1:Name} } from "${2:module}";$0]],
    fn = [[function ${1:name}(${2:args}): ${3:void} {
	$0
}]],
    afn = [[const ${1:name} = (${2:args}): ${3:void} => {
	$0
};]],
    type = [[type ${1:Name} = {
	$0
};]],
    iface = [[interface ${1:Name} {
	$0
}]],
    try = [[try {
	$1
} catch (${2:error}) {
	console.error(${2:error});
	$0
}]],
    awaittry = [[try {
	const ${1:result} = await ${2:promise};
	$0
} catch (${3:error}) {
	console.error(${3:error});
}]],
    react = [[export function ${1:Component}() {
	return (
		<div>
			$0
		</div>
	);
}]],
  },
  go = {
    main = [[package main

import "fmt"

func main() {
	$0
}]],
    im = [[import "${1:fmt}"$0]],
    ims = [[import (
	"${1:fmt}"
)
$0]],
    fn = [[func ${1:name}(${2:args}) ${3:error} {
	$0
}]],
    err = [[if err != nil {
	return ${1:err}
}]],
    errnil = [[if err != nil {
	return ${1:nil}, err
}]],
    errwrap = [[if err != nil {
	return ${1:nil}, fmt.Errorf("${2:operation failed}: %w", err)
}]],
    deferclose = [[defer func() {
	if err := ${1:closer}.Close(); err != nil {
		${2:log.Printf("close failed: %v", err)}
	}
}()]],
    http = [[func ${1:handler}(${2:w} http.ResponseWriter, ${3:r} *http.Request) {
	$0
}]],
    httperr = [[http.Error(${1:w}, ${2:err}.Error(), ${3:http.StatusInternalServerError})]],
    test = [[func Test${1:Name}(t *testing.T) {
	$0
}]],
    tabletest = [[func Test${1:Name}(t *testing.T) {
	tests := []struct {
		name string
		$2
	}{
		{
			name: "${3:case}",
			$4
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			$0
		})
	}
}]],
  },
  rust = {
    main = [[fn main() {
	$0
}]],
    use = [[use ${1:std::path::Path};$0]],
    fn = [[fn ${1:name}(${2:args}) -> ${3:()} {
	$0
}]],
    resultfn = [[fn ${1:name}(${2:args}) -> Result<${3:()}, ${4:Box<dyn std::error::Error>}> {
	$0
	Ok(())
}]],
    matcherr = [[match ${1:result} {
	Ok(${2:value}) => ${3:value},
	Err(${4:err}) => {
		${5:eprintln!("error: {}", err);}
		$0
	}
}]],
    iflet = [[if let ${1:Some(value)} = ${2:expr} {
	$0
}]],
    derive = [[#[derive(Debug, Clone)]
struct ${1:Name} {
	$0
}]],
    test = [[#[test]
fn ${1:name}() {
	$0
}]],
  },
  java = {
    main = [[public static void main(String[] args) {
	$0
}]],
    pkg = [[package ${1:com.example};$0]],
    imp = [[import ${1:java.util.List};$0]],
    class = [[public class ${1:Name} {
	$0
}]],
    method = [[public ${1:void} ${2:name}(${3}) {
	$0
}]],
    try = [[try {
	$1
} catch (${2:Exception} ${3:e}) {
	${3:e}.printStackTrace();
	$0
}]],
    tryres = [[try (${1:resource}) {
	$2
} catch (${3:Exception} ${4:e}) {
	${4:e}.printStackTrace();
}]],
    sout = [[System.out.println(${1:value});$0]],
    serr = [[System.err.println(${1:error});$0]],
  },
  arduino = {
    sketch = [[void setup() {
	Serial.begin(${1:115200});
	$0
}

void loop() {
	$0
}]],
    serial = [[Serial.println(${1:value});$0]],
    pinout = [[pinMode(${1:pin}, OUTPUT);$0]],
    pinin = [[pinMode(${1:pin}, INPUT_PULLUP);$0]],
    digital = [[digitalWrite(${1:pin}, ${2:HIGH});$0]],
    debounce = [[static unsigned long last_ms = 0;
if (millis() - last_ms > ${1:200}) {
	last_ms = millis();
	$0
}]],
  },
}

local aliases = {
  javascriptreact = "typescript",
  typescriptreact = "typescript",
  ino = "arduino",
}

function M.filetype()
  local ft = vim.bo.filetype
  if vim.fn.expand("%:e") == "ino" then return "arduino" end
  return aliases[ft] or ft
end

function M.names(ft)
  ft = ft or M.filetype()
  local list = {}
  for name, _ in pairs(M.items[ft] or {}) do
    table.insert(list, name)
  end
  table.sort(list)
  return list
end

function M.insert(name, ft)
  ft = ft or M.filetype()
  local body = M.items[ft] and M.items[ft][name]
  if not body then
    vim.notify("snippet not found for " .. ft .. ": " .. tostring(name), vim.log.levels.WARN)
    return
  end
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then
    vim.cmd("normal! o")
  end
  vim.snippet.expand(body)
end

function M.pick()
  local ft = M.filetype()
  local names = M.names(ft)
  if #names == 0 then
    vim.notify("no snippets for filetype: " .. ft, vim.log.levels.WARN)
    return
  end
  vim.ui.select(names, { prompt = "Snippet [" .. ft .. "]" }, function(choice)
    if choice then M.insert(choice, ft) end
  end)
end

function M.list()
  local ft = M.filetype()
  local names = M.names(ft)
  if #names == 0 then
    print("No snippets for filetype: " .. ft)
    return
  end
  print("Snippets for " .. ft .. ": " .. table.concat(names, ", "))
end

return M
