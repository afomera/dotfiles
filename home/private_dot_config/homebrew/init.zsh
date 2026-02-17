#!/usr/bin/env zsh
# Cache brew shellenv; regenerate only when brew binary changes
_brew_cache="${XDG_CACHE_HOME:-$HOME/.cache}/brew-shellenv.zsh"
_brew_bin="/opt/homebrew/bin/brew"
if [[ ! -f "$_brew_cache" || "$_brew_bin" -nt "$_brew_cache" ]]; then
  "$_brew_bin" shellenv > "$_brew_cache"
fi
source "$_brew_cache"
unset _brew_cache _brew_bin
