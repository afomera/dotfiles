#!/usr/bin/env zsh

# fnm: generate completion file if missing or outdated
if command -v fnm &>/dev/null; then
  local _fnm_comp="${0:h}/_fnm"
  local _fnm_bin="$(whence -p fnm)"
  if [[ ! -f "$_fnm_comp" || "$_fnm_bin" -nt "$_fnm_comp" ]]; then
    fnm completions --shell zsh > "$_fnm_comp" 2>/dev/null
  fi
fi
