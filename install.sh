#!/bin/bash

set -e

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ -f /etc/debian_version ]]; then
    OS="ubuntu"
else
    echo "Unsupported OS. This script supports macOS and Ubuntu/Debian."
    exit 1
fi

echo "Detected OS: $OS"

# Install packages based on OS
install_package() {
    local package=$1
    local brew_name=${2:-$1}

    echo "Installing $package..."

    if [[ "$OS" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install "$brew_name"
    elif [[ "$OS" == "ubuntu" ]]; then
        sudo apt-get update
        sudo apt-get install -y "$package"
    fi
}

# Oh My Zsh
echo "=== Installing Oh My Zsh ==="
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed"
fi

# Tmux
echo "=== Installing Tmux ==="
install_package tmux

# Neovim
echo "=== Installing Neovim ==="
install_package neovim

# Ripgrep
echo "=== Installing Ripgrep ==="
install_package ripgrep

# urlview for tmux plugin
echo "=== Installing urlview ==="
install_package urlview

# Mise (asdf replacement)
echo "=== Installing Mise ==="
if ! command -v mise &> /dev/null; then
    curl https://mise.run | sh
    echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
else
    echo "Mise already installed"
fi

# Tailscale
echo "=== Installing Tailscale ==="
if [[ "$OS" == "macos" ]]; then
    brew install --cask tailscale
elif [[ "$OS" == "ubuntu" ]]; then
    curl -fsSL https://tailscale.com/install.sh | sh
fi

# Claude Code
echo "=== Installing Claude Code ==="
if [[ "$OS" == "macos" ]]; then
    brew install --cask claude-code
elif [[ "$OS" == "ubuntu" ]]; then
    curl -fsSL https://claude.ai/install.sh | bash
fi

# Docker (macOS) / Podman (Ubuntu)
echo "=== Installing Docker/Podman ==="
if [[ "$OS" == "macos" ]]; then
    brew install --cask docker
elif [[ "$OS" == "ubuntu" ]]; then
    sudo apt-get update
    sudo apt-get install -y podman podman-compose
fi

# TMUX Plugin Manager setup
echo "=== Setting up TMUX Plugin Manager ==="
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM already installed"
fi

# Symlink tmux config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ ! -L "$HOME/.tmux.conf" ]]; then
    ln -s "$SCRIPT_DIR/tmux.conf" ~/.tmux.conf
else
    echo "tmux.conf symlink already exists"
fi

# Symlink nvim config
if [[ -d "$SCRIPT_DIR/nvim" ]]; then
    mkdir -p ~/.config
    if [[ ! -L "$HOME/.config/nvim" ]]; then
        ln -s "$SCRIPT_DIR/nvim" ~/.config/nvim
        echo "Neovim config symlinked"
    else
        echo "nvim config symlink already exists"
    fi
fi

echo ""
echo "=== Installation Complete ==="
echo "Post-install steps:"
echo "  - Tmux: Press prefix + I to install plugins"
echo "  - Tailscale: Run 'sudo tailscale up' to connect"
echo "  - Mise: Restart your shell or run 'source ~/.bashrc' / 'source ~/.zshrc'"
echo "  - Docker (macOS): Open Docker.app from Applications to complete setup"
echo "  - Podman (Ubuntu): Use 'podman' command (docker-compatible CLI)"



