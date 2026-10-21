#!/usr/bin/env bash
set -e

# Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.
# The installer runs in a GUI dialog and `xcode-select --install` returns straight away, so wait for it.
if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    echo "Waiting for the Command Line Tools to finish installing..."
    until xcode-select -p >/dev/null 2>&1; do
        sleep 5
    done
fi

# Clone repo into new hidden directory
[ -d ~/.dotfiles ] || git clone https://github.com/hartblanc/.dotfiles.git ~/.dotfiles

# Install homebrew, and add it to the path of this script, as zprofile only does that for new shells
[ -x /opt/homebrew/bin/brew ] || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew bundle --file=~/.dotfiles/Brewfile

# install tmux plugin manager (you'll need to prefix-I manually to install the plugins)
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# generate ~/.fzf.zsh, without letting it edit the shell rc files (zshrc already sources it)
"$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

~/.dotfiles/link.sh

# use Homebrew's zsh as the login shell; chsh only accepts shells listed in /etc/shells
grep -qx "$(brew --prefix)/bin/zsh" /etc/shells || echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells
chsh -s "$(brew --prefix)/bin/zsh"
