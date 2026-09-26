#!/usr/bin/env zsh

# List of conflicting files
conflicting_files=(
  "$HOME/.zshrc"
  "$HOME/.zshenv"
  "$HOME/.p10k.zsh"
  "$HOME/.ideavimrc"
  "$HOME/.wezterm.lua"
  "$HOME/.gitconfig"
  "$HOME/.config/ghostty/config"
  "$HOME/.config/zed/settings.json"
  "$HOME/.config/zed/keymap.json"
)

# Remove each conflicting file, but only if it doesn't already resolve into this
# dotfiles repo. Checking `[ -L "$file" ]` alone isn't enough: stow can fold a
# whole parent directory into a symlink (e.g. ~/.config/ghostty -> .dotfiles/...),
# in which case a file inside it (~/.config/ghostty/config) is a real file on
# disk, reached through a symlinked ancestor - not a symlink itself. rm -rf on
# that path deletes the actual repo file, not a mere pointer. `${file:A}` (zsh's
# realpath-equivalent) resolves the full chain, so this catches both cases.
dotfiles_dir="$HOME/.dotfiles"
for file in "${conflicting_files[@]}"; do
  if [ -e "$file" ] || [ -L "$file" ]; then
    resolved="${file:A}"
    if [[ "$resolved" == "$dotfiles_dir"/* ]]; then
      echo "$file already resolves into $dotfiles_dir, leaving it for stow to manage..."
    else
      echo "Removing $file..."
      rm -rf "$file"
    fi
  else
    echo "File $file does not exist, skipping..."
  fi
done

# Run stow to create symlinks (--restow realigns anything already stowed)
stow --restow zsh jetbrains wezterm git ghostty zed
