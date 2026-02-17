#!/usr/bin/env sh
if command -v direnv >/dev/null 2>&1 && [ -f "$HOME/.envrc" ]; then
  echo "==> Allowing global direnv"
  direnv allow ~
fi
