#!/usr/bin/env zsh

# chezmoi: generate completion file if missing or outdated
if command -v chezmoi &>/dev/null; then
  local _chezmoi_comp="${0:h}/_chezmoi"
  local _chezmoi_bin="$(whence -p chezmoi)"
  if [[ ! -f "$_chezmoi_comp" || "$_chezmoi_bin" -nt "$_chezmoi_comp" ]]; then
    chezmoi completion zsh > "$_chezmoi_comp" 2>/dev/null
  fi
fi
