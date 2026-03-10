# Mini Surround Tutorial

Mini-surround provides actions to add, delete, replace, find, and highlight surrounding pairs (quotes, brackets, tags, etc.).

**Reference**: https://github.com/echasnovski/mini.surround

## Keybindings

| Key  | Action                        |
|------|-------------------------------|
| `sa` | **S**urround **A**dd          |
| `sd` | **S**urround **D**elete       |
| `sr` | **S**urround **R**eplace      |
| `sf` | **S**urround **F**ind (next)  |
| `sF` | **S**urround **F**ind (prev)  |
| `sh` | **S**urround **H**ighlight    |
| `sn` | Update `n_lines` (search range) |

## Common Surrounding Characters

| Input | Surrounding Pair |
|-------|------------------|
| `)`   | `(` `)` (no padding) |
| `(`   | `( ` ` )` (with padding) |
| `]`   | `[` `]` (no padding) |
| `[`   | `[ ` ` ]` (with padding) |
| `}`   | `{` `}` (no padding) |
| `{`   | `{ ` ` }` (with padding) |
| `>`   | `<` `>` (no padding) |
| `<`   | `< ` ` >` (with padding) |
| `'`   | `'` `'` |
| `"`   | `"` `"` |
| `` ` `` | `` ` `` `` ` `` |
| `t`   | HTML/XML tag (prompts for tag name) |
| `f`   | Function call (prompts for function name) |

## Adding Surroundings

`sa{motion}{char}` - Add surrounding around motion

### Examples

Starting text: `word`

| Keystrokes   | Result       | Explanation                      |
|--------------|--------------|----------------------------------|
| `saiw"`      | `"word"`     | Surround inner word with `"`    |
| `saiw(`      | `( word )`   | Surround with padded parens     |
| `saiw)`      | `(word)`     | Surround with tight parens      |
| `sa2aw]`     | `[two words]`| Surround 2 words with brackets  |
| `saiwt`      | `<div>word</div>` | Surround with tag (prompts) |
| `saiwf`      | `func(word)` | Surround as function arg        |

### With Visual Mode

1. Select text with `v`, `V`, or `<C-v>`
2. Press `sa`
3. Enter surrounding character

Example:
```
1. v3w          -- Select 3 words
2. sa           -- Initiate surround add
3. "            -- Result: "three words here"
```

## Deleting Surroundings

`sd{char}` - Delete surrounding character

### Examples

| Starting Text    | Keystrokes | Result       |
|------------------|------------|--------------|
| `"word"`         | `sd"`      | `word`       |
| `(word)`         | `sd)`      | `word`       |
| `( word )`       | `sd(`      | `word`       |
| `<div>text</div>`| `sdt`      | `text`       |
| `func(arg)`      | `sdf`      | `arg`        |
| `[[nested]]`     | `sd]`      | `[nested]`   |
| `[nested]`       | `sd]`      | `nested`     |

## Replacing Surroundings

`sr{old}{new}` - Replace old surrounding with new

### Examples

| Starting Text | Keystrokes | Result       |
|---------------|------------|--------------|
| `"word"`      | `sr"'`     | `'word'`     |
| `(word)`      | `sr)}`     | `{word}`     |
| `(word)`      | `sr){`     | `{ word }`   |
| `'word'`      | `sr'"`     | `"word"`     |
| `[item]`      | `sr])`     | `(item)`     |
| `<p>text</p>` | `srtdiv`   | `<div>text</div>` |

## Finding Surroundings

`sf{char}` - Move cursor to next surrounding
`sF{char}` - Move cursor to previous surrounding

### Examples

In text: `The "first" and "second" quotes`

| Position        | Keystrokes | Cursor moves to |
|-----------------|------------|-----------------|
| Start of line   | `sf"`      | Opening `"` of "first" |
| Inside "first"  | `sf"`      | Opening `"` of "second" |
| Inside "second" | `sF"`      | Closing `"` of "first" |

## Highlighting Surroundings

`sh{char}` - Highlight surrounding pair temporarily

Useful for identifying matching pairs in complex nested structures.

## Working with Nested Structures

Mini-surround finds the **innermost** surrounding pair containing the cursor.

### Example: Nested Brackets

Text: `( outer [ inner ] outer )`

| Cursor Position | `sd]` Result              | `sd)` Result              |
|-----------------|---------------------------|---------------------------|
| Inside "inner"  | `( outer  inner  outer )` | N/A (no `)` inside `[]`)  |
| Inside "outer"  | `( outer  inner  outer )` | `outer [ inner ] outer`   |

### Example: Nested Quotes

Text: `"She said 'hello' today"`

| Cursor Position | `sd'` Result                | `sd"` Result              |
|-----------------|-----------------------------|---------------------------|
| Inside 'hello'  | `"She said hello today"`    | N/A                       |
| Outside 'hello' | `"She said hello today"`    | `She said 'hello' today`  |

## Practical Workflows

### Convert String Type

Change Python f-string to regular string:
```python
# Before: f"Hello {name}"
# After:  "Hello {name}"
# Keys:   Place cursor inside string, type: sd"saiw"
```

### Wrap Function Argument

```javascript
// Before: getValue()
// After:  String(getValue())
// Keys:   Place cursor on getValue, type: safawf then type String
```

### Change HTML Tag

```html
<!-- Before: <span>text</span> -->
<!-- After:  <strong>text</strong> -->
<!-- Keys:   Place cursor inside, type: srtstrong<CR> -->
```

### Remove All Surrounding

```python
# Before: ("value")
# After:  value
# Keys:   sd"sd)
```

### Add Multiple Surroundings

```python
# Before: value
# After:  ("value")
# Keys:   saiw"sa2aw)
```

## Operator-Pending Mode

`sa` waits for a motion, so standard Vim motions work:

| Keystrokes | Motion          | Effect                            |
|------------|-----------------|-----------------------------------|
| `saip"`    | inner paragraph | Surround paragraph with quotes    |
| `sa$)`     | to end of line  | Surround to EOL with parens       |
| `saf)`     | around function | Surround function with parens     |
| `sat"`     | around tag      | Surround tag with quotes          |
| `sa/pat<CR>"` | to pattern   | Surround to pattern with quotes   |

## Dot Repeat

All mini-surround actions support `.` (dot repeat):

1. `saiw"` on first word
2. Move to next word
3. `.` repeats the surround action

## Troubleshooting

### Surround Not Found

Mini-surround searches within `n_lines` above and below cursor (default: 5).

- Use `sn` to change search range
- Move cursor closer to the surrounding

### Wrong Pair Selected

For nested structures, cursor position determines which pair is affected:
- Move cursor inside the pair you want to modify
- Use `sh{char}` to highlight and verify before modifying

### Tag Input Not Working

When using `t` for tags:
- Type the tag name without `<>` (e.g., `div` not `<div>`)
- Press `<CR>` to confirm

### Function Input Not Working

When using `f` for functions:
- Type the function name without `()`
- Press `<CR>` to confirm
