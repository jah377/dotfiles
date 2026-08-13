---
name: improve-naming
description: >
  Audits the naming of identifiers in a Python (.py), Quarto (.qmd), or Jupyter (.ipynb) file
  or directory. Analyzes file names, class names, method names, standalone functions, parameters,
  instance variables, and properties to determine whether each name accurately represents what
  the code actually does. Produces a read-only naming-audit.md report organized by file and
  construct, with each name labeled "rename required", "rename recommended", or "ok as is".
  Use this skill whenever the user asks to "review names", "improve naming", "check if names
  make sense", "audit identifiers", "rename things", or says a file "has bad names" or "names
  don't match what the code does". Also trigger when the user shares a .py, .qmd, or .ipynb
  file and asks for a code quality or readability review — naming is always worth auditing.
---

# Improve Naming

Audit identifier names across a Python file, Quarto file, Jupyter notebook, or directory. The
goal is a `naming-audit.md` report the user can edit and then hand to an AI to implement.

---

## Naming conventions (authoritative standard for this audit)

Apply these throughout — they are non-negotiable for Python:

- **Functions, methods, parameters, variables**: `snake_case`
- **Classes**: `PascalCase`
- **Module-level constants**: `SCREAMING_SNAKE_CASE`
- **Boolean properties and attributes**: `is_` or `has_` prefix (`is_ready`, `has_data`)
- **Mutating methods**: verb-first (`load_`, `save_`, `set_`, `clear_`, `build_`)
- **Pure/returning methods**: noun phrase or `get_`/`compute_`/`fetch_` (`get_active_users`,
  `compute_growth_rate`)
- **Abbreviations**: acceptable only when they are unambiguous community conventions in the
  domain (e.g., `df` for a pandas DataFrame, `cfg` if the type annotation makes it obvious).
  Single-letter names are rarely acceptable outside loop variables and standard math contexts.
- **Parameter names should match the field names they correspond to** in related classes.
  If `Session.ip_address` exists, a parameter receiving that value should be `ip_address`,
  not `ip`. Consistency within a codebase is part of good naming.

---

## Step 1 — Read the full file(s)

**Do not evaluate any names while reading.** Read the entire file (or all files in scope) first,
building a complete understanding of what each construct does before forming any opinions.

For **Jupyter notebooks** (`.ipynb`): read all code cells in sequence, treating them as a
single flat module.

For **Quarto files** (`.qmd`): read only the Python code blocks, ignoring markdown prose.

For a **directory**: traverse recursively. Skip these directories entirely:
`__pycache__`, `.venv`, `venv`, `.git`, `node_modules`, `build`, `dist`, `*.egg-info`,
`.tox`, `.pytest_cache`, `.mypy_cache`. Include `__init__.py` files only if they contain
more than import statements.

---

## Step 2 — Evaluate each name

For each name in scope, ask: **If a reader saw only this name with no other context, would they
correctly predict what this construct does?**

### What to audit

| Identifier | Included | Notes |
|---|---|---|
| File name | ✅ | |
| Class names | ✅ | |
| Method names | ✅ | |
| Standalone functions | ✅ | |
| Parameters | ✅ | Exclude `self`, `cls`, bare `*args`, bare `**kwargs` |
| Instance variables | ✅ | `__init__` assignments and dataclass fields only |
| Properties (`@property`) | ✅ | |
| `__dunder__` methods | ❌ | Names are contractually fixed by Python |
| Nested functions | ❌ | Too implementation-internal |
| Module-level constants | ❌ | |
| Type aliases / TypeVar | ❌ | |

### Severity labels

- **rename required**: The name actively creates a wrong mental model. A reader would form an
  incorrect understanding of the code's behavior, inputs, or outputs. Examples: `get_user()`
  that deletes a record; a parameter `path` that expects an integer; a class `Parser` that
  only formats output; a boolean property `ok` that gives no hint of what condition it tests.

- **rename recommended**: The name is imprecise, over-abbreviated, or too generic to be
  useful, but doesn't actively mislead. The reader would be confused or forced to guess.
  Examples: `process_data`, `handle`, `d`, `res`, `tmp`, `stored` when the value is a hash.

- **ok as is**: A reader with no surrounding context could correctly describe the construct's
  purpose from the name alone. The reason should still justify this briefly.

### Calibration

- Short names in narrow, obvious scope (`i` in a loop, `e` in `except`) → `ok as is`
- `df` for a pandas DataFrame, `cfg` for config when annotated → `ok as is`
- Short names at module level or as parameters without annotation context → `rename recommended`
- Wrong verb for the side effects (`calculate_` for something that writes; `load_` for
  something that also transforms) → `rename required`
- Convention violations (camelCase function, missing `is_` on boolean property) → `rename required`
- Parameter name inconsistent with the field name it corresponds to elsewhere in the codebase
  (e.g., `ip` when `Session.ip_address` exists) → `rename recommended`

---

## Step 3 — Write the report

Save the report:
- **Single file**: output as markdown in the conversation — do not write a file
- **Directory**: write `naming-audit.md` at the directory root — the output is too long for chat

Use the format below. Every class, property, method, function, parameter, and field in scope
must appear — do not omit anything, even if the verdict is `ok as is`.

---

## Report format

Use compact list entries throughout. No tables. Each identifier gets one line with an inline
verdict badge, followed by an indented reason on the next line.

**Verdict badge syntax:**
- `**[rename required]**` — name actively misleads
- `**[rename recommended]**` — name is imprecise or unclear
- `**[ok as is]**` — name is clear and accurate

**Entry format:**

```
- `identifier_name` **[verdict]** → `suggested_name`
  Reason sentence. One sentence only.
```

For `ok as is`, omit the `→ suggested_name` part:

```
- `identifier_name` **[ok as is]**
  Reason sentence confirming why.
```

---

## Report structure

```markdown
# Naming Audit

> Generated: <date>
> Target: <file path or directory path>

---

## File: `<filename>`

> *For directory mode, nest file sections under `# <subdirectory>/` headings.*

### File name

- `filename.py` **[rename required]** → `database_config_loader.py`
  Current name hides the domain; a reader cannot tell what the module contains.

---

### Class: `ClassName`

- `ClassName` **[rename recommended]** → `SalesRecordProcessor`
  "Proc" suffix is an abbreviation; the domain (sales records) is invisible.

#### Fields

- `self.d` **[rename required]** → `self.raw_dataframe`
  Single-letter at instance scope; type and domain are both invisible to readers.
- `self.result` **[ok as is]**
  Name matches its single, obvious responsibility.

#### Properties

- `ok` **[rename required]** → `is_data_loaded`
  Boolean property missing `is_` prefix; "ok" reveals nothing about what condition is tested.
- `active_session_count` **[ok as is]**
  Noun phrase with no ambiguity; count of active sessions is exactly what it returns.

#### Method: `method_name()`

- `method_name` **[rename required]** → `aggregate_revenue_by_region`
  Most generic verb possible; completely hides what the method filters, groups, and returns.

  Parameters:
  - `n` **[rename recommended]** → `max_rows`
    Single letter; the unit and constraint it enforces are invisible.
  - `drop_null` **[ok as is]**
    Boolean flag name is self-documenting; effect is unambiguous.

*(Repeat `#### Method` block for each method. If a class has no fields, properties, or
auditable methods beyond the class name, note "No members to audit.")*

---

### Standalone Functions

#### `function_name()`

- `function_name` **[rename required]** → `has_required_columns`
  Opaque abbreviation; also missing boolean predicate naming convention (`has_`).

  Parameters:
  - `cols` **[rename recommended]** → `required_columns`
    Abbreviation when the full name costs nothing and makes the role explicit.
  - `df` **[ok as is]**
    Standard pandas community convention; unambiguous in this context.

*(Repeat for each standalone function.)*
```

---

## Notes on report tone

- One sentence per reason. Name the specific problem — what does the current name hide, or
  what does the suggested name reveal?
- For `ok as is`, the reason should still be specific — "Standard pandas convention" or "Name
  matches its single, obvious responsibility" — not left empty.
- Do not flag something if the only issue is a style preference. Flag real reading problems.
- For Jupyter notebooks, replace the file name section with a "Notebook name" heading.
