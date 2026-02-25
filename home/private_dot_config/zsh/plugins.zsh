#!/usr/bin/env zsh

# Zsh plugins (managed by .chezmoiexternal.toml.tmpl)
[[ -f "$HOME/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$HOME/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

[[ -f "$HOME/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$HOME/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Syntax highlighting theme (must be sourced after zsh-syntax-highlighting)
[[ -f "${ZDOTDIR:-$HOME/.config/zsh}/theme.zsh" ]] && \
  source "${ZDOTDIR:-$HOME/.config/zsh}/theme.zsh"
