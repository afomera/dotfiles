#!/usr/bin/env zsh

# History
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

# Completion
setopt COMPLETE_IN_WORD
setopt complete_aliases

# Misc
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt NO_LIST_BEEP
