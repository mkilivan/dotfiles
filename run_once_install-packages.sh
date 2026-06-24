#!/bin/bash
# Installs tools referenced in dotfiles. Runs once; re-runs only if this file changes.
set -e

BOLD='\033[1m'
RESET='\033[0m'
OS="$(uname)"

info()    { echo -e "${BOLD}==> $1${RESET}"; }
skip()    { echo "==> $1 already installed ($2), skipping"; }
done_()   { echo "==> $1 $2 installed"; }
version() { "$@" 2>&1 | grep -oE '[0-9]+\.[0-9]+[a-z]?[0-9]*(\.[0-9]+[a-z]?)?' | head -1; }

# starship
if command -v starship &>/dev/null; then
  skip "starship" "$(version starship --version)"
else
  info "Installing starship"
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
  done_ "starship" "$(version starship --version)"
fi

# zoxide
if command -v zoxide &>/dev/null; then
  skip "zoxide" "$(version zoxide --version)"
else
  info "Installing zoxide"
  if [ "$OS" = "Darwin" ]; then
    brew install zoxide
  else
    sudo apt-get install -y zoxide
  fi
  done_ "zoxide" "$(version zoxide --version)"
fi

# fzf
if command -v fzf &>/dev/null; then
  skip "fzf" "$(version fzf --version)"
elif [ -d ~/.fzf ]; then
  skip "fzf" "$(version ~/.fzf/bin/fzf --version)"
else
  info "Installing fzf"
  if [ "$OS" = "Darwin" ]; then
    brew install fzf
  else
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-update-rc
  fi
  done_ "fzf" "$(version fzf --version)"
fi

# eza
if command -v eza &>/dev/null; then
  skip "eza" "$(version eza --version)"
else
  info "Installing eza"
  if [ "$OS" = "Darwin" ]; then
    brew install eza
  else
    sudo apt-get install -y eza
  fi
  done_ "eza" "$(version eza --version)"
fi

# delta (git diff pager)
if command -v delta &>/dev/null; then
  skip "delta" "$(version delta --version)"
else
  info "Installing delta"
  if [ "$OS" = "Darwin" ]; then
    brew install git-delta
  else
    sudo apt-get install -y git-delta
  fi
  done_ "delta" "$(version delta --version)"
fi

# tmux
if command -v tmux &>/dev/null; then
  skip "tmux" "$(version tmux -V)"
else
  info "Installing tmux"
  if [ "$OS" = "Darwin" ]; then
    brew install tmux
  else
    sudo apt-get install -y tmux
  fi
  done_ "tmux" "$(version tmux -V)"
fi

# tpm (tmux plugin manager)
if [ -d ~/.tmux/plugins/tpm ]; then
  echo "==> tpm already installed, skipping"
else
  info "Installing tpm"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "==> tpm installed"
fi

# JetBrains Mono Nerd Font
if [ "$OS" = "Darwin" ]; then
  info "Installing JetBrains Mono Nerd Font (macOS)"
  brew install --cask font-jetbrains-mono-nerd-font
else
  if fc-list | grep -qi "JetBrainsMono"; then
    echo "==> JetBrains Mono Nerd Font already installed, skipping"
  else
    info "Installing JetBrains Mono Nerd Font (Linux)"
    if command -v unzip &>/dev/null; then
      skip "unzip" "$(version unzip -v)"
    else
      info "Installing unzip"
      sudo apt-get install -y unzip
      done_ "unzip" "$(version unzip -v)"
    fi
    curl -fLo /tmp/JetBrainsMono.zip \
      "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    mkdir -p ~/.local/share/fonts/JetBrainsMono
    unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono/ '*.ttf'
    fc-cache -fv
    rm /tmp/JetBrainsMono.zip
    echo "==> JetBrains Mono Nerd Font installed"
  fi
fi
