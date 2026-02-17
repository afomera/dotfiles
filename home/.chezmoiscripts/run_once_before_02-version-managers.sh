#!/usr/bin/env sh
set -e

# Rustup
if ! command -v rustup >/dev/null 2>&1; then
  echo "==> Installing rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  . "$HOME/.cargo/env"
fi

# Node LTS via fnm
if command -v fnm >/dev/null 2>&1; then
  echo "==> Installing latest Node LTS via fnm"
  fnm install --lts
fi
