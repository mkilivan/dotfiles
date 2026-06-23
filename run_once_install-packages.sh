#!/bin/bash
# Installs tools referenced in dotfiles. Runs once; re-runs only if this file changes.
set -e

BOLD='\033[1m'
RESET='\033[0m'

info() { echo -e "${BOLD}==> $1${RESET}"; }

# starship
if ! command -v starship &>/dev/null; then
  info "Installing starship"
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# zoxide
if ! command -v zoxide &>/dev/null; then
  info "Installing zoxide"
  sudo apt-get install -y zoxide 2>/dev/null \
    || curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# fzf
if ! command -v fzf &>/dev/null; then
  info "Installing fzf"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all --no-update-rc
fi

# eza
if ! command -v eza &>/dev/null; then
  info "Installing eza"
  sudo apt-get install -y eza 2>/dev/null \
    || cargo install eza
fi

# delta (git diff pager)
if ! command -v delta &>/dev/null; then
  info "Installing delta"
  sudo apt-get install -y git-delta 2>/dev/null \
    || cargo install git-delta
fi

# tpm (tmux plugin manager)
if [ ! -d ~/.tmux/plugins/tpm ]; then
  info "Installing tpm"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
