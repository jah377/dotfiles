# Introduction

The directory `tests_py/` organizes files used to test python functionality in Neovim.

# Create tests_py dir

```bash
cd ~/dotfiles/nvim/.config/nvim/tests
uv init tests_py
```

# Create virtual environment

```bash
uv add matplotlib numpy pandas
```

# Activate venv

The following ensures the correct environment is used to test the LSP. After
opening nvim, the LSP should work after opening `main.py`.

```bash
cd tests_py
uv run nvim
```
