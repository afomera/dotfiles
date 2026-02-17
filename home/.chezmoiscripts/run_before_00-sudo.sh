#!/usr/bin/env zsh

# Acquire sudo upfront so later scripts (brew cask installs, etc.) don't prompt mid-apply.
echo "==> Requesting sudo access (for brew cask installs, etc.)"
sudo -v

# Kill any previous keepalive from a failed run
if [ -f /tmp/.chezmoi-sudo-keepalive-pid ]; then
  kill "$(cat /tmp/.chezmoi-sudo-keepalive-pid)" 2>/dev/null
  rm -f /tmp/.chezmoi-sudo-keepalive-pid
fi

# Keep sudo alive in a detached process that survives this script's exit.
# Uses sudo -n (non-interactive) so it never prompts — just silently dies
# when the timestamp eventually expires after chezmoi is long done.
(while true; do sudo -n true; sleep 50; done) &!
echo $! > /tmp/.chezmoi-sudo-keepalive-pid
