#!/usr/bin/env sh
set -e

# Xcode CLI tools
if ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Installing Xcode CLI tools"
  xcode-select --install
  echo "Press Enter after Xcode CLI tools installation completes..."
  read -r
fi

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
