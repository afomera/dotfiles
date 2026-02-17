#!/usr/bin/env sh
set -e
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"
for f in .zshrc .zshenv .gitconfig .gitmessage .tmux.conf .gemrc .irbrc .ssh/config; do
  [ -e "$HOME/$f" ] && cp -L "$HOME/$f" "$BACKUP_DIR/$f" 2>/dev/null || true
done
echo "Backed up existing dotfiles to $BACKUP_DIR"
