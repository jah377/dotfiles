# Spelling in nvim

## Enable Spell Checking

```vim
:set spell          " Enable spell checking
:set nospell        " Disable spell checking
:set spell!         " Toggle spell checking
```

To set the language (defaults to English):

```vim
:set spelllang=en_us
```

## Interactive Walk-Through

### Step 1: Enable Spell Check

1. Open a file with text
2. Enter command mode with `:`
3. Type `set spell` and press Enter
4. Misspelled words now appear highlighted (typically red underline or similar)

### Step 2: Navigate Between Errors

| Key  | Action                                |
| ---- | ------------------------------------- |
| `]s` | Jump to next misspelled word          |
| `[s` | Jump to previous misspelled word      |
| `]S` | Jump to next bad word (skip rare)     |
| `[S` | Jump to previous bad word (skip rare) |

**Practice**: Press `]s` repeatedly to cycle through all spelling errors in your file.

### Step 3: Fix a Misspelled Word

1. Move cursor to a misspelled word (or use `]s`)
2. Press `z=` to open the suggestion list
3. Type the number next to the correct spelling
4. Press Enter

**Practice**: missspelled word

**Shortcut**: `1z=` accepts the first suggestion without showing the list.

### Step 4: Add Words to Dictionary

When a word is correct but flagged (technical terms, names, etc.):

| Key   | Action                                    |
| ----- | ----------------------------------------- |
| `zg`  | Add word under cursor to spellfile (good) |
| `zw`  | Mark word as wrong (bad)                  |
| `zug` | Undo `zg` (remove from good list)         |
| `zuw` | Undo `zw` (remove from bad list)          |

**Practice**:

1. Find a correctly-spelled word marked as misspelled
2. Press `zg` to add it to your personal dictionary
3. The highlight disappears

### Step 5: Internal Word Errors

For compound words or camelCase:

| Key  | Action                                        |
| ---- | --------------------------------------------- |
| `]S` | Jump to next bad word (ignores rare/regional) |
| `[S` | Jump to previous bad word                     |

## Quick Reference Card

```
Navigation:
  ]s  →  next misspelled
  [s  →  previous misspelled

Correction:
  z=  →  show suggestions
  1z= →  accept first suggestion

Dictionary:
  zg  →  add to dictionary
  zw  →  mark as wrong
  zug →  undo add
  zuw →  undo mark wrong

Toggle:
  :set spell!  →  toggle on/off
```

## Example Session

1. Open a markdown file: `nvim notes.md`
2. Enable spell check: `:set spell`
3. Jump to first error: `]s`
4. See suggestions: `z=`
5. Pick option 1: type `1` then Enter
6. Continue to next: `]s`
7. If word is valid, add to dictionary: `zg`
8. Repeat until no errors remain

## Spell File Location

Words added with `zg` are stored in:

```
~/.config/nvim/spell/en.utf-8.add
```

This file is plain text—one word per line. You can edit it directly.
