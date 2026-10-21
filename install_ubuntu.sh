#!/usr/bin/env bash
set -e

sudo apt-get update
sudo apt-get upgrade

# required to download everything below
sudo apt install curl

# required for appimages
sudo apt install fuse

# required for sumneko language server and also for general decompressing
sudo apt install unzip
# required for some neovim lsp lanaguage servers
sudo apt install npm

# gcc toolchain so we can compile rust binaries
sudo apt install build-essential

# required to link dotfiles in and just so we have the shell...
sudo apt install zsh

# build latest version of tmux from source
curl -LO "$(curl -s https://api.github.com/repos/tmux/tmux/releases/latest | grep browser_download_url | cut -d '"' -f 4)"
tar -xf tmux-*.tar.gz
sudo apt-get install libevent-dev ncurses-dev build-essential bison pkg-config
cd tmux-*/ || exit
./configure
make && sudo make install
cd ..
rm -rf tmux-*

# install tmux plugin manager (you'll need to prefix-I manually to install the plugins)
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install cargo, and add it to the path of this script, as rustup only does that for new shells
curl https://sh.rustup.rs -sSf | sh -s -- -y
# shellcheck source=/dev/null
. "$HOME/.cargo/env"

# install rust binaries to $HOME/.cargo/bin
cargo install eza fd-find bat ripgrep sd stylua

# install fzf, without letting it edit the shell rc files (zshrc already sources ~/.fzf.zsh)
[ -d ~/.fzf ] || git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc

# install zsh autosuggestions
[ -d ~/.zsh/zsh-autosuggestions ] || git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# install neovim
sudo apt-get install ninja-build gettext cmake curl build-essential \
&& git clone --depth 1 --branch stable https://github.com/neovim/neovim \
&& (
  cd neovim \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo \
  && sudo make install
) \
&& rm -rf neovim

# install starship prompt
curl -sS https://starship.rs/install.sh | sh -s -- --yes

# install hunk, the git pager
curl -fsSL https://hunk.dev/install.sh | sh
# link it into ~/.local/bin, which zprofile puts on the path
mkdir -p ~/.local/bin
ln -sf ~/.hunk/bin/hunk ~/.local/bin/hunk

~/.dotfiles/link.sh
chsh -s "$(which zsh)"
