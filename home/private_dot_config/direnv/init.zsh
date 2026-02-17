#!/usr/bin/env zsh
export DIRENV_LOG_FORMAT=""
if command -v direnv &>/dev/null; then
  _direnv_cache="${XDG_CACHE_HOME:-$HOME/.cache}/direnv-hook.zsh"
  _direnv_bin="$(whence -p direnv)"
  if [[ ! -f "$_direnv_cache" || "$_direnv_bin" -nt "$_direnv_cache" ]]; then
    direnv hook zsh > "$_direnv_cache"
  fi
  source "$_direnv_cache"
  unset _direnv_cache _direnv_bin
fi
