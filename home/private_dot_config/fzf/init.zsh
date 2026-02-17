#!/usr/bin/env zsh
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)

  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

  # Use ripgrep for file search if available
  if command -v rg &>/dev/null; then
    export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi
