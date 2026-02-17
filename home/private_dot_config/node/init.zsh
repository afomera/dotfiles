#!/usr/bin/env zsh
if command -v fnm &>/dev/null; then
  # Cache fnm env output; regenerate only when fnm binary changes
  _fnm_cache="${XDG_CACHE_HOME:-$HOME/.cache}/fnm-env.zsh"
  _fnm_bin="$(whence -p fnm)"
  if [[ ! -f "$_fnm_cache" || "$_fnm_bin" -nt "$_fnm_cache" ]]; then
    fnm env --use-on-cd > "$_fnm_cache"
  fi
  source "$_fnm_cache"
  unset _fnm_cache _fnm_bin
fi
