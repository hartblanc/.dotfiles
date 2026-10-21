# Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew
xcode-select --install

# Clone repo into new hidden directory
git clone https://github.com/hartblanc/.dotfiles.git ~/.dotfiles

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew bundle --file=~/.dotfiles/Brewfile

~/.dotfiles/link.sh
