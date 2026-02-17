#!/usr/bin/env zsh

# Add zsh-completions to fpath
[[ -d "$HOME/.local/share/zsh-completions/src" ]] && \
  fpath=("$HOME/.local/share/zsh-completions/src" $fpath)
