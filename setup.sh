#!/usr/bin/env zsh
xcode-select --install # Ensure CLI tools
# install fzf-git
# ...
brew bundle --file=~/.dotfiles/homebrew/Brewfile
stow zsh git jetbrains # Apply all configurations
