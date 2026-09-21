#!/usr/bin/env zsh

# Check if the machine is macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script is intended for macOS only."
  exit 1
fi

# Check if the machine is Apple Silicon
is_apple_silicon=false
if [[ "$(uname -m)" == "arm64" ]]; then
  is_apple_silicon=true
fi

# Install Xcode CLI tools (only for macOS)
if $is_apple_silicon; then
  echo "Detected Apple Silicon architecture."
else
  echo "Detected Intel architecture."
fi

echo "Checking for Xcode CLI tools..."
xcode-select --install &>/dev/null || echo "Xcode CLI tools already installed."

# Prompt for and write a per-machine git identity file (~/.dotfiles/git/.gitconfig.work
# or .gitconfig.private), if it doesn't already exist. These files are gitignored -
# they never get committed.
configure_git_identity() {
  local target="$1"

  if [[ -f "$target" ]]; then
    echo "Git identity already configured at $target, skipping."
    return
  fi

  echo "Configuring git identity ($target)..."
  read "git_name?  Git user.name: "
  read "git_email?  Git user.email: "
  git config -f "$target" user.name "$git_name"
  git config -f "$target" user.email "$git_email"

  read "git_sign?  Sign commits with GPG? (y/N): "
  if [[ "$git_sign" == "y" || "$git_sign" == "Y" ]]; then
    read "git_signingkey?  GPG signing key ID: "
    git config -f "$target" user.signingkey "$git_signingkey"
    git config -f "$target" commit.gpgsign true
  else
    git config -f "$target" commit.gpgsign false
  fi
}

# On a work machine, the global git identity is the work identity - but when committing,
# changes to this project, a local (repo-only) identity should be used.
# This function writes to ~/.dotfiles/.git/config and creates a local git identity for the dotfiles repo,
# which is never committed/pushed. GPG signing is always off here since the
# personal signing key isn't expected to be present on a work machine.
configure_dotfiles_repo_identity() {
  if git -C ~/.dotfiles config --local user.email &>/dev/null; then
    echo "Local git identity for the dotfiles repo already configured, skipping."
    return
  fi

  echo "Configuring a non-work git identity for this dotfiles repo (used only when pushing ~/.dotfiles)..."
  read "repo_name?  Git user.name for ~/.dotfiles: "
  read "repo_email?  Git user.email for ~/.dotfiles: "
  git -C ~/.dotfiles config --local user.name "$repo_name"
  git -C ~/.dotfiles config --local user.email "$repo_email"
  git -C ~/.dotfiles config --local commit.gpgsign false
}

# Interactive menu to select environment
echo "Select your environment:"
PS3="Please enter your choice: "
unset options
typeset -a options
options=("Workstation" "Private" "Quit")
select opt in "${options[@]}"; do
  case $opt in
    "Workstation")
      echo "Setting up Workstation environment..."
      brew bundle --file=~/.dotfiles/homebrew/Brewfile.common
      brew bundle --file=~/.dotfiles/homebrew/Brewfile.mac.common
      brew bundle --file=~/.dotfiles/homebrew/Brewfile.mac.work
      configure_git_identity ~/.dotfiles/git/.gitconfig.work
      ln -sf ~/.dotfiles/git/.gitconfig.work ~/.gitconfig.local
      configure_dotfiles_repo_identity
      break
      ;;
    "Private")
      echo "Setting up Private environment..."
      brew bundle --file=~/.dotfiles/homebrew/Brewfile.common
      brew bundle --file=~/.dotfiles/homebrew/Brewfile.mac.common
      brew bundle --file=~/.dotfiles/homebrew/Brewfile.mac.private
      configure_git_identity ~/.dotfiles/git/.gitconfig.private
      ln -sf ~/.dotfiles/git/.gitconfig.private ~/.gitconfig.local
      break
      ;;
    "Quit")
      echo "Exiting setup."
      exit 0
      ;;
    *)
      echo "Invalid option. Please try again."
      ;;
  esac
done

# Apply configurations using stow (common for all environments)
echo "Applying configurations..."
./stow.sh

echo "Setup complete!"
