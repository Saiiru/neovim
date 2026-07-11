local M = {}

M.items = {
  c = {
    main = [[#include <stdio.h>

int main(void) {
	$0
	return 0;
}]],
    fori = [[for (int ${1:i} = 0; ${1:i} < ${2:n}; ${1:i}++) {
	$0
}]],
    printf = [[printf("${1:%s}\\n", ${2:value});$0]],
    guard = [[#ifndef ${1:HEADER_H}
#define ${1:HEADER_H}

$0

#endif /* ${1:HEADER_H} */]],
  },
  cpp = {
    main = [[#include <iostream>

int main() {
	$0
	return 0;
}]],
    cout = [[std::cout << ${1:value} << std::endl;$0]],
    class = [[class ${1:Name} {
public:
	${1:Name}();
	~${1:Name}();

private:
	$0
};]],
  },
  lua = {
    req = [[local ${1:name} = require("${2:module}")$0]],
    fn = [[local function ${1:name}(${2:args})
	$0
end]],
    mod = [[local M = {}

function M.${1:name}(${2:args})
	$0
end

return M]],
  },
  python = {
    main = [[def main() -> None:
    $0


if __name__ == "__main__":
    main()]],
    fn = [[def ${1:name}(${2:args}) -> ${3:None}:
    $0]],
    cls = [[class ${1:Name}:
    def __init__(self) -> None:
        $0]],
  },
  javascript = {
    fn = [[function ${1:name}(${2:args}) {
	$0
}]],
    afn = [[const ${1:name} = (${2:args}) => {
	$0
};]],
    log = [[console.log(${1:value});$0]],
  },
  typescript = {
    fn = [[function ${1:name}(${2:args}): ${3:void} {
	$0
}]],
    afn = [[const ${1:name} = (${2:args}): ${3:void} => {
	$0
};]],
    type = [[type ${1:Name} = {
	$0
};]],
  },
  go = {
    main = [[package main

import "fmt"

func main() {
	$0
}]],
    fn = [[func ${1:name}(${2:args}) ${3:error} {
	$0
}]],
    err = [[if err != nil {
	return ${1:err}
}]],
  },
  rust = {
    main = [[fn main() {
	$0
}]],
    fn = [[fn ${1:name}(${2:args}) -> ${3:()} {
	$0
}]],
    test = [[#[test]
fn ${1:name}() {
	$0
}]],
  },
  arduino = {
    sketch = [[void setup() {
	Serial.begin(${1:115200});
	$0
}

void loop() {
	$0
}]],
  },
}

local aliases = {
  javascriptreact = "javascript",
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
