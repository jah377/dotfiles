---
name: dignified-lua
description:
  Lua coding standards based on the LuaRocks style guide. Use when writing, reviewing, or
  refactoring Lua code (.lua files), including Neovim configs and plugins, LuaRocks modules,
  and embedded Lua scripts. Covers naming, locals and scope, tables, functions, modules, OOP,
  error handling, and luacheck.
---

# Dignified Lua

Lua standards derived from the [LuaRocks Lua Style Guide](https://github.com/luarocks/lua-style-guide).

## Precedence

1. Project tooling config wins for formatting: `.stylua.toml`, `.editorconfig`, `.luacheckrc`,
   `.luarc.json`. Check for these before writing code.
2. Existing conventions in the surrounding file.
3. This skill.

Formatting rules below (indent width, call parentheses, quotes) are fallbacks. Semantic rules
(locals, modules, errors, OOP) apply regardless of formatter.

## Formatting

- Indent with spaces, never tabs. Default 3 spaces when no project config exists.
- LF line endings.
- One statement per line. No semicolons.
- No hard line length limit; if a line is very long, split the expression into named locals.
- Space after `--`, after commas, and around operators and `=`. `..` may omit spaces.
- No space between a function name and its `(`, or inside the parentheses.
- Blank line between function definitions.
- Indent multi-line tables and callbacks relative to the start of the line, not the construct.
- Do not align `=` across declarations (noisy diffs). Alignment is okay for tabular call lists.
- Single-line blocks only for `then return`, `then break`, and short lambdas.

```lua
local numbers = {1, 2, 3}
dog.set("attr", {
   age = "1 year",
   breed = "Bernese Mountain Dog",
})
using_a_callback(x, function(...)
   print("hello")
end)
if not ok then return nil, "failed: " .. reason end
```

## Naming

- `snake_case` for variables and functions.
- `CamelCase` for classes; acronyms capitalize only the first letter (`XmlDocument`).
  Methods stay `snake_case`.
- `UPPER_CASE` only for true constants, sparingly.
- Never use names starting with `_` followed by uppercase (`_VERSION`-style is reserved).
- Boolean functions use `is_` prefix: `is_evil(x)`.
- Name length scales with scope. One-letter names only in scopes under ~10 lines.
- `i` only as a numeric/`ipairs` counter. Prefer descriptive names over `k`, `v` with `pairs`
  unless the code is generic over any table.
- `_` for ignored values: `for _, item in ipairs(items) do`.

## Variables and scope

- Always declare with `local`. Never create implicit globals.
- Declare variables at the smallest possible scope, as close to first use as possible.
- Use truthiness: `if name then`, not `if name ~= nil then`, unless distinguishing `nil` from
  `false`.
- Do not design APIs that depend on the difference between `nil` and `false`.
- `a and b or c` is fine as a ternary only when `b` can never be `nil`/`false`. Parenthesize
  nested conditions: `(m and m.loaded) and "brew" or "fill"`.
- Convert types explicitly (`tostring`, `tonumber`); do not rely on coercion like `n .. ""`.

## Strings

- Double quotes by default. Single quotes when the string contains double quotes.

## Tables

- Populate fields in the constructor when possible.
- Trailing comma on every field in multi-line tables.
- Use `key = value`; use `["key"] = value` only for non-identifier keys. Do not mix styles in
  one constructor.
- Dot access for known fields (`luke.jedi`); `[]` for variable keys and list indices.

## Functions

- Prefer `local function name()` over `local name = function()`.
- Validate early and return early.
- Always parenthesize calls with a single string argument: `get_data("KRP")`, not
  `get_data"KRP"`.
- Parenthesize calls with a single-line table argument. Omitting them is allowed only for a
  multi-line table argument that stands alone as a statement.
- Method calls use `:`: `obj:method()`, not `obj.method(obj)`.

## Modules

```lua
--- @module foo.bar
local bar = {}

local util = require("foo.util")

local function helper(x)
   -- private
end

function bar.say(greeting)
   print(greeting)
end

return bar
```

- `require` with parentheses, assigned to a local named after the module's last path
  component: `local bar = require("foo.bar")`. Do not abbreviate (`local skt = require("socket")`).
- Declare the module table as a local using the same lowercase name it is required by.
- `local function` means private; public functions are `function mod.name()`.
- Never set globals. Always return a table. Use `__call` on the module table if it must be
  callable.
- Requiring a module must have no side effects beyond loading dependencies.
- Modules hold no mutable state. If configuration is needed, expose a factory:
  `messagepack.new({integer = "unsigned"})`, not `mp.set_integer("unsigned")`.
- Avoid module names that clash with likely local names (e.g. `size`).

## OOP

```lua
--- @module myproject.myclass
local myclass = {}

local MyClass = {}
local MyClass_mt = { __index = MyClass }

function MyClass:some_method()
   -- code
end

function myclass.new()
   return setmetatable({}, MyClass_mt)
end

return myclass
```

- Class table and metatable are both `local`. Name a top-level metatable `MyClass_mt`.
- Module and class functions are defined outside the table constructor.
- Metatables define metamethods inside the constructor so all behavior is visible at once.
- Do not rely on `__gc` to release non-memory resources. Provide an explicit `close()` method.

## Errors

- Expected failures (I/O, parsing user input): return `nil, "error message"` (optionally
  followed by an error code).
- Programmer errors (API misuse): raise with `error()` or `assert()`.
- In non-hot paths, assert argument types at function entry:

```lua
function manif.load_manifest(repo_url, lua_version)
   assert(type(repo_url) == "string")
   assert(type(lua_version) == "string" or not lua_version)
   -- ...
end
```

## Documentation

- Document public functions with [LDoc](https://stevedonovan.github.io/ldoc/) comments above
  the function (what it does), including param/return types. Use LuaLS `---@param` annotations
  instead if the project already uses them.
- Prefer a clear function over inline "how" comments; split complex functions instead.
- `TODO:` for missing features, `FIXME:` for known problems.

```lua
--- Load a manifest describing a repository.
-- @param repo_url string: URL or pathname for the repository.
-- @return table or (nil, string): The manifest, or nil and an error message.
function manif.load_manifest(repo_url)
```

## File structure

- Lowercase filenames.
- Libraries: sources in `src/`, main file `src/<modulename>.lua`, executables in `src/bin/`,
  tests in `spec/` (Busted).

## Static checking

- Code should pass [luacheck](https://github.com/mpeterv/luacheck); add a `.luacheckrc` with
  explicit exceptions when defaults do not fit (e.g. `globals = { "vim" }` for Neovim).
- Ignorable luacheck warnings:
  - 6xx (whitespace).
  - 211/212/213 (unused variable/argument/loop var) when the name was spelled out
    deliberately, e.g. a callback matching a required signature.
  - 542 (empty `if` branch) for an intentional "pass" case in an `if`/`elseif` chain.

## Review checklist

- [ ] No implicit globals; every variable is `local`
- [ ] Variables declared at minimal scope
- [ ] `snake_case` names; `CamelCase` only for classes; `is_` for predicates
- [ ] `local function` for private functions, `function mod.fn` for public
- [ ] `require("x")` assigned to a local named after the last path component
- [ ] Module returns a table, has no side effects or mutable state
- [ ] Expected failures return `nil, err`; misuse raises
- [ ] No `and/or` ternary where the middle value can be `nil`/`false`
- [ ] Methods called with `:`
- [ ] Formatting matches project config (`.stylua.toml`, `.editorconfig`)
