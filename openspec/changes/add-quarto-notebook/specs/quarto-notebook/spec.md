## ADDED Requirements

### Requirement: Jupyter kernel initialization
The system SHALL allow the user to initialize a Jupyter kernel for the current `.qmd` buffer via `:MoltenInit`, presenting a selection list of registered kernels.

#### Scenario: Kernel initialized successfully
- **WHEN** user runs `<leader>ji` in a `.qmd` buffer
- **THEN** a kernel selection prompt appears listing all registered Jupyter kernels

#### Scenario: Kernel initialized from registered uv venv
- **WHEN** user has run `python -m ipykernel install --user --name <project>` in an activated venv
- **THEN** that kernel name appears in the `:MoltenInit` selection list

### Requirement: Cell execution with inline output
The system SHALL execute the code block under the cursor when triggered and render the output inline below the cell in the buffer.

#### Scenario: Python cell executed successfully
- **WHEN** user presses `<leader>jr` with cursor inside a `{python}` code block
- **THEN** the cell executes against the active kernel and output appears as virtual text below the closing fence

#### Scenario: Image output rendered inline
- **WHEN** a cell produces a matplotlib or other image output
- **THEN** the image renders inline in the buffer using the Kitty Graphics Protocol (visible in WezTerm)

#### Scenario: Cell execution while kernel is busy
- **WHEN** user triggers cell execution while the kernel is processing another cell
- **THEN** the cell is queued and executes after the current execution completes

### Requirement: Run all cells
The system SHALL provide a command to execute all cells in the buffer sequentially.

#### Scenario: All cells run in order
- **WHEN** user presses `<leader>jR`
- **THEN** all `{python}` cells execute top-to-bottom against the active kernel

### Requirement: Output visibility management
The system SHALL allow the user to show, hide, and delete cell outputs.

#### Scenario: Output toggled
- **WHEN** user presses `<leader>jo` with cursor on a cell that has output
- **THEN** the output display toggles between visible and hidden

#### Scenario: Output deleted
- **WHEN** user presses `<leader>jd` with cursor on a cell
- **THEN** the stored output for that cell is deleted and no longer displayed

### Requirement: LSP inside code blocks
The system SHALL provide pyright LSP completions, diagnostics, and hover documentation inside `{python}` code blocks in `.qmd` files via otter.nvim.

#### Scenario: Completion triggered inside code block
- **WHEN** user triggers completion (via nvim-cmp) with cursor inside a `{python}` fenced block
- **THEN** pyright-backed completions appear for the Python code context

#### Scenario: Diagnostics shown inside code block
- **WHEN** a `{python}` block contains a type error or undefined name
- **THEN** pyright diagnostics appear inline, identical to behavior in `.py` files

### Requirement: Format on save for .qmd files
The system SHALL format `.qmd` files on save, applying `prettierd` to the markdown structure and `ruff_fix`/`ruff_format`/`isort` to embedded `{python}` blocks via the `injected` formatter.

#### Scenario: Python block formatted on save
- **WHEN** user saves a `.qmd` file containing a `{python}` block with unformatted Python
- **THEN** the Python inside the block is formatted by ruff and isort

#### Scenario: Markdown structure formatted on save
- **WHEN** user saves a `.qmd` file with inconsistent markdown spacing
- **THEN** prettierd normalizes the markdown structure outside code blocks

#### Scenario: Format disabled per buffer
- **WHEN** user sets `vim.b.disable_autoformat = true` for the buffer
- **THEN** format on save is skipped for that buffer (inheriting existing conform behavior)

### Requirement: Jupyter keymaps under <leader>j
The system SHALL expose all kernel and cell operations under the `<leader>j` prefix, visible in which-key, and active only in `.qmd` buffers.

#### Scenario: Which-key shows jupyter group
- **WHEN** user presses `<leader>j` in a `.qmd` buffer
- **THEN** which-key displays the "jupyter" group with all available subcommands

#### Scenario: Keymaps absent in non-qmd buffers
- **WHEN** user presses `<leader>j` in a `.py` or `.lua` buffer
- **THEN** no jupyter keymaps are triggered (bindings are buffer-local to `.qmd`)
