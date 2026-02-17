#!/usr/bin/env sh
set -e

# Detect VS Code or Cursor CLI
if command -v code >/dev/null 2>&1; then
  CODE_CMD="code"
elif [ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
  CODE_CMD="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
elif command -v cursor >/dev/null 2>&1; then
  CODE_CMD="cursor"
elif [ -x "/Applications/Cursor.app/Contents/Resources/app/bin/cursor" ]; then
  CODE_CMD="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
else
  echo "Neither VS Code nor Cursor found, skipping extensions"
  exit 0
fi

echo "==> Installing VS Code extensions via $CODE_CMD"

extensions="
Shopify.ruby-lsp
Shopify.ruby-extensions-pack
waderyan.gitblame
GitHub.copilot-chat
GitHub.github-vscode-theme
herbcss.herb-lsp
ybaumes.highlight-trailing-white-spaces
yagudaev.run-specs
marcoroth.stimulus-lsp
tomoki1207.pdf
CraigMaslowski.erb
"

for ext in $extensions; do
  $CODE_CMD --install-extension "$ext" --force 2>/dev/null || true
done
