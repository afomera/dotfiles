#!/usr/bin/env sh
set -e

echo "==> Setting macOS defaults"

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Screenshots: save as PNG
defaults write com.apple.screencapture type -string "png"

# TextEdit: use plain text mode by default
defaults write com.apple.TextEdit RichText -int 0

echo "macOS defaults set. Some changes may require a logout/restart."
