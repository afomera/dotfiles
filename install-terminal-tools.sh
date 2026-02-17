#!/bin/bash

# Install xcode command line tools
if ! command -v xcode-select > /dev/null; then
  printf "Installing Xcode CLI tools...\n"
  xcode-select --install

  printf "%s\n" "💡 ALT+TAB to view and accept Xcode license window."
  read -p "Have you completed the Xcode CLI tools install (y/n)? " xcode_response
  if [[ "$xcode_response" != "y" ]]; then
    printf "ERROR: Xcode CLI tools must be installed before proceeding.\n"
    exit 1
  fi
fi

# Start things off with Homebrew
if ! command -v brew > /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH="/opt/homebrew/bin:$PATH"
fi

# Check for Oh My Zsh and install if we don't have it
# also installs zsh-autosuggestions when we first install oh-my-zsh
if ! command -v omz > /dev/null; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # Install zsh-autosuggestions plugin
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if test ! $(which asdf); then
  # Install asdf
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf

  # Re-source asdf into the current shell
  source ~/.asdf/asdf.sh

  # Install asdf-ruby
  asdf plugin add ruby

  # Install asdf-nodejs
  asdf plugin-add nodejs
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
fi

# Re-source asdf into the current shell
source ~/.asdf/asdf.sh

# Install local dependencies
asdf install
