#!/usr/bin/env zsh
export DIRENV_LOG_FORMAT=""
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
