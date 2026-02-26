#!/usr/bin/env zsh

# rustup + cargo: generate completion files if missing or outdated
if command -v rustup &>/dev/null; then
  local _rustup_comp="${0:h}/_rustup"
  local _cargo_comp="${0:h}/_cargo"
  local _rustup_bin="$(whence -p rustup)"
  if [[ ! -f "$_rustup_comp" || "$_rustup_bin" -nt "$_rustup_comp" ]]; then
    rustup completions zsh > "$_rustup_comp" 2>/dev/null
    rustup completions zsh cargo > "$_cargo_comp" 2>/dev/null
  fi
fi
