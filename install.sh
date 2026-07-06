#!/usr/bin/env bash
set -euo pipefail

# Dotfiles installer.
#
# Usage:
#   ./install.sh              # full install — packages + stow
#   DOTFILES_CONTAINER=1 ./install.sh   # container mode — stow only
#
# Adding a new config:
#   1. mkdir <name>          (e.g. mkdir alacritty)
#   2. Drop the file at the path it should land relative to $HOME, e.g.
#      alacritty/.config/alacritty/alacritty.yml → ~/.config/alacritty/alacritty.yml
#   3. Re-run ./install.sh
#
# Stow handles the symlinking. Conflicts (existing real files) fail loudly
# rather than silently overwriting — move the existing file out of the way
# first, or let stow refuse and decide what to do.

cd "$(dirname "$0")"

if [[ -z "${DOTFILES_CONTAINER:-}" ]]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
  elif [[ -f /etc/debian_version ]]; then
    OS="ubuntu "
    echo "Detected Ubuntu, updating apt..."
    sudo apt-get update
  else
    echo "Unsupported OS for package installs. Will still run stow." >&2
    OS="unknown"
  fi
  echo "Detected OS: $OS"

  install_package() {
    local package=$1
    local brew_name=${2:-$1}
    echo "Installing $package..."
    if [[ "$OS" == "macos" ]]; then
      command -v brew >/dev/null 2>&1 || {
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      }
      brew install "$brew_name"
    elif [[ "$OS" == "ubuntu" ]]; then
      sudo apt-get install -y "$package"
    fi
  }

  # Oh My Zsh
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "=== Installing Oh My Zsh ==="
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Stow itself
  command -v stow >/dev/null 2>&1 || install_package stow

  # Tooling
  install_package tmux
  install_package neovim
  install_package ripgrep
  install_package urlview
  # Modern bash (5.x). macOS ships bash 3.2, which lacks associative arrays
  # and breaks scripts like the tokyo-night-tmux theme (whole status bar
  # renders in one colour). brew shellenv in .zshrc puts it ahead of /bin.
  install_package bash

  # mise
  if ! command -v mise >/dev/null 2>&1; then
    echo "=== Installing Mise ==="
    curl https://mise.run | sh
    echo 'eval "$(~/.local/bin/mise activate bash)"' >> "$HOME/.bashrc"
    # mise activation belongs in the local override (not the stowed .zshrc)
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> "$HOME/.zshrc.local"
  fi

  # Tailscale
  if [[ "$OS" == "macos" ]]; then
    brew list --cask tailscale >/dev/null 2>&1 || brew install --cask tailscale
  elif [[ "$OS" == "ubuntu" ]]; then
    command -v tailscale >/dev/null 2>&1 || curl -fsSL https://tailscale.com/install.sh | sh
  fi

  # TPM (Tmux Plugin Manager)
  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
fi

# Stow every top-level package directory ----------------------------------
echo "=== Stowing dotfiles ==="
command -v stow >/dev/null 2>&1 || {
  echo "ERROR: stow not found. Install it first (apt install stow / brew install stow)." >&2
  exit 1
}

for pkg in */; do
  pkg="${pkg%/}"
  [ -d "$pkg" ] || continue
  echo "  stow $pkg"
  stow --restow --target="$HOME" "$pkg"
done

echo
echo "=== Done ==="
echo "Notes:"
echo "  - Create ~/.gitconfig.local with your signing config:"
echo "      [commit] gpgsign = true"
echo "      [user]   signingkey = <your fingerprint or SSH pubkey path>"
echo "  - tmux: prefix + I to install plugins (TPM)"
if [[ -z "${DOTFILES_CONTAINER:-}" ]]; then
  echo "  - Restart your shell, or 'source ~/.zshrc'"
  echo "  - Tailscale: 'sudo tailscale up' to connect"
fi
