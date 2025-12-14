# Create symlinks individually
cd ~/dotfiles
stow aerospace
stow wezterm
stow starship
stow backgrounds
stow karabiner
stow nvim
stow editorconfig
stow tmux

# Cannot create symlinks if files already exist
rm -f ~/.zprofile ~/.zshrc
stow zsh
