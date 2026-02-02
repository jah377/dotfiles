# Dotfiles Repository Context

## Role & Expectations

You are a senior software developer with an expertise in macOS, configuration
dotfiles, command-line tools, neovim, and good coding practices. You are tasked
with assisting a team member build their dotfiles.

When working with this dotfiles repository, you should:

- **Follow XDG specifications**: Respect the XDG Base Directory structure already established
- **Maintain consistency**: Match existing code style, naming conventions, and patterns
- **Test assumptions**: Never assume tools are installed; check for existence before use
- **Be conservative**: Don't add features or "improvements" unless explicitly requested
- **Document non-obvious choices**: Add comments for complex logic or platform-specific workarounds
- **Respect minimalism**: Keep configurations lean; this is a dotfiles repo, not a framework

## Repository Overview

**Purpose**: Personal development environment configuration managed with GNU Stow

**Primary Platform**: macOS (Apple Silicon)

**Philosophy**:

- Clean `$HOME` directory using XDG Base Directory specification
- Modular, readable configuration files
- Minimal dependencies
- Version-controlled dotfiles with easy deployment via stow

## Structure

```
dotfiles/
├── stow/                    # Stow packages (each subdirectory is a package)
│   ├── zsh/                 # Zsh shell configuration
│   │   ├── .zshenv          # Bootstrap file (must be in $HOME)
│   │   └── .config/zsh/     # Actual configs (XDG-compliant)
│   │       ├── .zshenv      # Environment variables
│   │       ├── .zprofile    # Login shell config
│   │       ├── .zshrc       # Interactive shell config
│   │       └── *.zsh        # Modular config files auto-sourced by .zshrc
│   └── [other tools]/       # Additional tool configurations
└── README.md                # Repository documentation
```

**Key Pattern**: Bootstrap `.zshenv` in `$HOME` redirects zsh to load configs from `~/.config/zsh/`

## Configured Tools

### Shell Environment

- **zsh**: Primary shell with extensive customization
- **Homebrew**: Package manager (required dependency)

### ZSH Plugins

- `zsh-autosuggestions`: Command suggestions based on history
- `zsh-syntax-highlighting`: Real-time syntax highlighting
- `zsh-vi-mode`: Vi key bindings in the shell

### CLI Tools

- **starship**: Fast, customizable prompt
- **fzf**: Fuzzy finder for files and history
- **zoxide**: Smarter `cd` command (aliased to `cd`)
- **eza**: Modern `ls` replacement with icons
- **lazygit**: Terminal UI for git
- **neovim**: Text editor (set as `$EDITOR`)

## Installation

### Prerequisites

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required packages
brew install \
  zsh \
  starship \
  fzf \
  zoxide \
  eza \
  lazygit \
  neovim \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-vi-mode \
  stow
```

### Deployment

```bash
# Clone the repository
git clone <repository-url> ~/dotfiles
cd ~/dotfiles

# Deploy zsh configuration
stow -t ~ stow/zsh

# Deploy other configurations as needed
stow -t ~ stow/emacs
# ... etc
```

### Post-Installation

1. Restart your shell or run `exec zsh`
2. Verify Homebrew is in PATH: `which brew`
3. Verify plugins loaded: `echo $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE`

## Critical Implementation Details

### XDG Directory Structure

- Bootstrap `.zshenv` lives in `$HOME` (zsh requirement, cannot be relocated)
- Actual configs live in `~/.config/zsh/` (XDG-compliant)
- History should be in `$ZDOTDIR` or `$XDG_DATA_HOME`, NOT `$HOME`

## Coding Practices & Standards

### Shell Scripting

1. **Quote variables**: `"$variable"` not `$variable`
2. **Check existence**: Use `[[ -f file ]]` before sourcing
3. **Test commands**: Use `command -v tool` before using tool
4. **Handle errors**: Don't assume operations succeed
5. **Avoid globbing issues**: Quote glob patterns in loops
6. **Use absolute paths**: Or verify PWD before using relative paths

### File Organization

1. **One concern per file**: Each `.zsh` file handles one tool/feature
2. **Descriptive names**: `zsh_highlighting.zsh` not `hl.zsh`
3. **Comments at top**: Explain purpose and link to documentation
4. **Group related configs**: Keep tool configs together

### Environment Variables

1. **Set in `.zshenv`**: For universal variables needed by all shells
2. **Set in `.zprofile`**: For login shell setup (PATH modifications)
3. **Set in `.zshrc`**: For interactive shell options only
4. **Use XDG variables**: Prefer `$XDG_CONFIG_HOME` over hardcoded paths

### Documentation

1. **Explain "why" not "what"**: Code shows what, comments explain why
2. **Link to official docs**: Reference upstream documentation
3. **Note platform-specific code**: Mark macOS/Linux-only sections
4. **Document dependencies**: Note required packages

## Troubleshooting

### Shell won't start / immediate exit

```bash
# Check syntax errors
zsh -n ~/.config/zsh/.zshrc
zsh -n ~/.config/zsh/.zprofile

# Check for errors in modular files
for file in ~/.config/zsh/*.zsh; do
  echo "Checking $file"
  zsh -n "$file"
done

# Start zsh in debug mode
zsh -x
```

### Plugins not loading

```bash
# Verify Homebrew packages installed
brew list | grep zsh-

# Check file exists (Apple Silicon)
ls -la /opt/homebrew/share/zsh-*

# Check file exists (Intel)
ls -la /usr/local/share/zsh-*

# Verify HOMEBREW_PREFIX set
echo $HOMEBREW_PREFIX

# Check for sourcing errors
grep "source.*zsh" ~/.config/zsh/*.zsh
```

### Commands not found after Homebrew install

```bash
# Reload shell environment
exec zsh

# Verify brew shellenv ran
echo $HOMEBREW_PREFIX  # Should output path

# Check PATH includes Homebrew
echo $PATH | grep -o "/.*homebrew.*/bin"

# Manually run brew shellenv
eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon
# or
eval "$(/usr/local/bin/brew shellenv)"     # Intel
```

### Slow shell startup

```bash
# Profile startup time
time zsh -i -c exit

# Identify slow components
zsh -x -i -c exit 2>&1 | head -50

# Common culprits:
# - Too many plugins
# - Unoptimized plugin loading
# - Network calls during init
# - Large history files
```

### History not saving

```bash
# Check HISTFILE location
echo $HISTFILE

# Verify file exists and is writable
ls -la $HISTFILE

# Check history options
setopt | grep HIST
```

### fzf / zoxide / starship not working

```bash
# Check if installed
command -v fzf
command -v zoxide
command -v starship

# Verify initialization ran
type __zoxide_z  # Should show function definition
echo $STARSHIP_CONFIG  # Should show config path

# Check for init commands
grep -r "eval.*fzf" ~/.config/zsh/
grep -r "eval.*zoxide" ~/.config/zsh/
grep -r "eval.*starship" ~/.config/zsh/
```

## Performance Considerations

### Shell Startup Time

**Target**: <200ms for interactive shell startup

**Measure**:

```bash
time zsh -i -c exit
```

**Common Bottlenecks**:

1. Plugin sourcing (especially syntax highlighting)
2. `eval` calls (brew, starship, zoxide, fzf)
3. Large history files
4. Network operations during init

**Optimization Strategies**:

```bash
# Lazy load heavy plugins
# Instead of sourcing immediately, defer until needed

# Use zsh-defer for non-critical plugins
# source zsh-defer.plugin.zsh
# zsh-defer source /path/to/heavy-plugin.zsh

# Profile specific sections
# time source ~/.config/zsh/plugin.zsh
```

### History File Size

- Current limit: 5000 lines (HISTSIZE, SAVEHIST)
- Monitor size: `wc -l $HISTFILE`
- Large files slow shell exit
- Consider periodic cleanup of old entries

## Tool Configuration Locations

Understanding where each tool stores its configuration:

- **Zsh**: `~/.config/zsh/` (via `$ZDOTDIR`)
- **Starship**: `~/.config/starship/starship.toml` (via `$STARSHIP_CONFIG`)
- **Neovim**: `~/.config/nvim/`
- **Eza**: `~/.config/eza/`
- **Git**: `~/.config/git/config`
- **fzf**: Configuration in `~/.config/zsh/fzf.zsh` (no separate config file)
- **Homebrew**: `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)

**Pattern**: Most tools follow XDG Base Directory spec, looking in `$XDG_CONFIG_HOME` (defaults to `~/.config`)

## Maintenance Guidelines

### What to Avoid

- ❌ Don't add unused features "for future use"
- ❌ Don't install plugins without understanding their impact
- ❌ Don't hardcode paths (use `command -v` or existence checks)
- ❌ Don't ignore errors (check if operations succeed)
- ❌ Don't commit secrets, credentials, or history files

### What to Prefer

- ✅ Simple, readable code over clever one-liners
- ✅ Explicit error handling over silent failures
- ✅ Portable solutions over platform-specific hacks
- ✅ Minimal dependencies over feature-rich alternatives
- ✅ Modular configs over monolithic files
- ✅ Comments explaining "why" for non-obvious choices

## Security Considerations

### Repo-Specific Concerns

- **`.zsh_history`**: Now gitignored. Contains command history which may include secrets, tokens, passwords
- **Machine-specific configs**: Use `*.local` suffix (already in `.gitignore`)
- **Plugin auditing**: All plugins (`zsh-*`, starship, etc.) execute arbitrary code - verify sources before installing
- **`eval` usage**: Review all `eval` statements (brew shellenv, tool init) for injection risks

## References

- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [Zsh Documentation](https://zsh.sourceforge.io/Doc/)
- [Zsh History Options](https://postgresqlstan.github.io/cli/zsh-history-options/)
- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Homebrew Documentation](https://docs.brew.sh/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Neovim documentation](https://neovim.io/doc/user/)

---

**Last Updated**: 2025-12-21
**Maintained By**: jharris
