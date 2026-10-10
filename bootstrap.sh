#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOMEBREW_BIN=/opt/homebrew/bin/brew
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
VIMRC_REPO=git@github.com:rainbowkenny/vimrc.git
VIMRC_DIR="$HOME/vimrc"
TAILSCALE_CLI=/Applications/Tailscale.app/Contents/MacOS/Tailscale

install_command_line_tools() {
  if xcode-select -p >/dev/null 2>&1; then return; fi
  xcode-select --install
  echo "Finish the Command Line Tools install dialog, then rerun this script."
  exit 1
}

install_homebrew() {
  if [ ! -x "$HOMEBREW_BIN" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$("$HOMEBREW_BIN" shellenv)"
}

install_brew_packages() {
  brew bundle --file="$DOTFILES_DIR/Brewfile"
}

install_uv() {
  if command -v uv >/dev/null || [ -x "$HOME/.local/bin/uv" ]; then return; fi
  curl -LsSf https://astral.sh/uv/install.sh | sh
}

install_oh_my_zsh() {
  if [ -d "$OH_MY_ZSH_DIR" ]; then return; fi
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$OH_MY_ZSH_DIR"
}

link_with_backup() {
  local source_path="$1" link_path="$2"
  if [ -e "$link_path" ] && [ ! -L "$link_path" ]; then
    mv "$link_path" "$link_path.pre-dotfiles"
    echo "Backed up $link_path to $link_path.pre-dotfiles"
  fi
  ln -sfn "$source_path" "$link_path"
}

link_zsh_config() {
  link_with_backup "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
  link_with_backup "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
}

install_vim_config() {
  if [ -e "$HOME/.vim" ]; then return; fi
  [ -d "$VIMRC_DIR" ] || git clone "$VIMRC_REPO" "$VIMRC_DIR"
  ln -s "$VIMRC_DIR" "$HOME/.vim"
  vim +PlugInstall +qall
}

prompt_tailscale_login() {
  if "$TAILSCALE_CLI" status >/dev/null 2>&1; then return; fi
  open -a Tailscale
  echo "Log in to Tailscale from its menu bar icon."
}

install_command_line_tools
install_homebrew
install_brew_packages
install_uv
install_oh_my_zsh
link_zsh_config
install_vim_config
prompt_tailscale_login
echo "Done. Open a new terminal to load the shell config."
