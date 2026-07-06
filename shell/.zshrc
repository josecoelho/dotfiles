# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Homebrew — prepend /opt/homebrew/bin so brew-installed tools (e.g. modern
# bash 5.x) take priority over the ancient macOS system versions in /bin.
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Plugins. Add wisely — too many slow shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# User configuration ----------------------------------------------------------

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Aliases
alias vim=nvim

# Add user-installed binaries onto PATH
export PATH="$HOME/.local/bin:$PATH"

# Disable Copilot telemetry
export CO_PILOT_TELEMETRY=off

# Machine-specific extras (silently no-op on machines that don't have them) ---

# asdf — install location varies by OS / install method
[ -f "$HOME/.asdf/asdf.sh" ] && {
  export ASDF_DIR="$HOME/.asdf"
  source "$HOME/.asdf/asdf.sh"
  fpath=(${ASDF_DIR}/completions $fpath)
  autoload -Uz compinit && compinit
}

# Go installed via asdf
[ -d "$HOME/.asdf/installs/golang" ] && {
  GO_PKG_BIN=$(find "$HOME/.asdf/installs/golang" -maxdepth 3 -type d -name bin -path '*/packages/bin' | head -1)
  [ -n "$GO_PKG_BIN" ] && export PATH="$GO_PKG_BIN:$PATH"
}

# Android SDK — Mac path
[ -d "$HOME/Library/Android/sdk" ] && {
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
}

# Docker app on macOS
[ -d "/Applications/Docker.app/Contents/Resources/bin" ] && \
  export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin"

# Homebrew libyaml flags (Mac, Apple Silicon)
[ -d "/opt/homebrew/opt/libyaml" ] && {
  export LDFLAGS="-L/opt/homebrew/opt/libyaml/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/libyaml/include"
}

# direnv
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# Local overrides — never committed
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
