#!/usr/bin/env zsh

# Git aliases
alias gs="git status"
alias gf="git fetch"
alias ga="git add"
alias ga.="git add ."
alias gc="git commit"
alias gp="git push"
alias gpl="git pull"
alias gitclean='git branch --merged | egrep -v "(^\*|master|develop|main)" | xargs git branch -d; git remote prune origin'
alias gitgone='git fetch -p && git branch -vv | grep ": gone]" | awk "{print \$1}" | xargs git branch -D'
