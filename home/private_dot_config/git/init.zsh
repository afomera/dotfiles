#!/usr/bin/env zsh

# git-gtr: register as a git subcommand for completion (before compinit)
if command -v git-gtr &>/dev/null; then
  zstyle ':completion:*:*:git:*' user-commands gtr:'Git worktree management'
fi
