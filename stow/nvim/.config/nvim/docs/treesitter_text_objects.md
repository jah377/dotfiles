# Treesitter Text Objects Reference

Comprehensive guide to nvim-treesitter-textobjects keybindings with Lua examples.

**Notation:**

- `|` = cursor position
- Text objects work with operators: `d` (delete), `y` (yank), `c` (change), `v` (visual select)

**See related python file:** [test_nvim_treesitter_textobjects.py](/Users/jharris/dotfiles/tests/nvim/tests_py/test_nvim_treesitter_textobjects.py)

## Quick Reference Table

| Keybinding  | Description              | Example Usage             |
| ----------- | ------------------------ | ------------------------- |
| `af` / `if` | Function outer/inner     | `daf` delete function     |
| `ac` / `ic` | Class outer/inner        | `yac` yank class          |
| `aa` / `ia` | Parameter outer/inner    | `cia` change parameter    |
| `ai` / `ii` | Conditional outer/inner  | `dai` delete if statement |
| `al` / `il` | Loop outer/inner         | `vil` select loop body    |
| `a/`        | Comment                  | `da/` delete comment      |
| `]m` / `[m` | Next/prev function start | Jump to function          |
| `]M` / `[M` | Next/prev function end   | Jump to end               |
| `]c` / `[c` | Next/prev class start    | Navigate classes          |
| `]a` / `[a` | Next/prev parameter      | Navigate params           |
| `<leader>a` | Swap param with next     | Reorder parameters        |
| `<leader>A` | Swap param with prev     | Reorder parameters        |

## Common Workflows

### Workflow 1: Refactor function

1. Navigate to function: `]m`
2. Select entire function: `vaf`
3. Delete and rewrite: `daf` then type new function

### Workflow 2: Extract conditional logic

1. Jump to conditional: `]m` (if inside function)
2. Select inner conditional: `vii`
3. Yank to clipboard: `y`
4. Paste elsewhere: `p`

### Workflow 3: Reorder function parameters

1. Position cursor on parameter to move
2. Swap with next: `<leader>a`
3. Repeat until in desired position

### Workflow 4: Delete all loop code

1. Position cursor anywhere in loop
2. Delete outer loop: `dal`
3. Code inside loop is removed

### Workflow 5: Quick navigation between functions

1. Jump to next function: `]m`
2. Jump to previous function: `[m`
3. Jump to function end: `]M`
