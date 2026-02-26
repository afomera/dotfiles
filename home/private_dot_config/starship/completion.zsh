#!/usr/bin/env zsh

# starship: generate completion file if missing or outdated
if command -v starship &>/dev/null; then
  local _starship_comp="${0:h}/_starship"
  local _starship_bin="$(whence -p starship)"
  if [[ ! -f "$_starship_comp" || "$_starship_bin" -nt "$_starship_comp" ]]; then
    starship completions zsh > "$_starship_comp" 2>/dev/null
  fi
fi
