#!/usr/bin/env zsh

# gh: generate completion file if missing or outdated
if command -v gh &>/dev/null; then
  local _gh_comp="${0:h}/_gh"
  local _gh_bin="$(whence -p gh)"
  if [[ ! -f "$_gh_comp" || "$_gh_bin" -nt "$_gh_comp" ]]; then
    gh completion -s zsh > "$_gh_comp" 2>/dev/null
  fi
fi
