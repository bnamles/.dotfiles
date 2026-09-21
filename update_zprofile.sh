#!/bin/zsh

# Define the .zprofile file path
ZPROFILE="$HOME/.zprofile"

# Add GPG_TTY export
echo '# gpg' >>"$ZPROFILE"
echo 'export GPG_TTY=$(tty)' >>"$ZPROFILE"

# Dynamically find the DOCKER_HOST value (example for Podman socket location)
DOCKER_SOCKET=$(find /var/folders -name "podman-machine-default-api.sock" 2>/dev/null | head -n 1)

if [[ -n $DOCKER_SOCKET ]]; then
  echo '# Podman *remove when changing to docker' >>"$ZPROFILE"
  echo "export DOCKER_HOST='unix://$DOCKER_SOCKET'" >>"$ZPROFILE"
else
  echo "Podman socket not found. Skipping DOCKER_HOST export."
fi

# Reload .zprofile to apply changes
source "$ZPROFILE"

echo "Environment variables added to .zprofile."
