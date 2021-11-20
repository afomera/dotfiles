#!/bin/bash

# Install xcode command line tools
xcode-select --install

# Start things off with Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf

# Re-source asdf into the current shell
source ~/.asdf/asdf.sh

# Install asdf-ruby
asdf plugin add ruby

# Install asdf-nodejs
asdf plugin-add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

# Install global asdf versions
asdf install
