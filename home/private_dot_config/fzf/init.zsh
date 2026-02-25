#!/usr/bin/env zsh
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)

  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border \
    --color=fg:#e6edf3,bg:#0d1117,hl:#79c0ff \
    --color=fg+:#e6edf3,bg+:#161b22,hl+:#79c0ff \
    --color=info:#8b949e,prompt:#7ee787,pointer:#d2a8ff \
    --color=marker:#ffa657,spinner:#d2a8ff,header:#8b949e \
    --color=border:#30363d,gutter:#0d1117"

  # Use ripgrep for file search if available
  if command -v rg &>/dev/null; then
    export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi
