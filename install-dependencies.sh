#!/bin/bash

# Install homebrew packages
brew install yarn
brew install neovim --head
brew install tree
brew install tree-sitter
brew install tmux
brew install tmuxinator
brew install imagemagick
brew install ffmpeg
brew install python

# Useful tools
brew install ripgrep
brew install angle-grinder
brew install bat

# Tools for Rails development / deployment
brew install heroku/brew/heroku
brew install stripe/stripe-cli/stripe

# Install (and update) vim plugins for vim-plug and close vim
nvim +PlugInstall +PlugUpdate +qall

echo "NeoVim installed the plugins!"
