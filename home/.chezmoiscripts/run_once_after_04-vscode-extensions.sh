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

$CODE_CMD \
  --install-extension Shopify.ruby-lsp \
  --install-extension Shopify.ruby-extensions-pack \
  --install-extension waderyan.gitblame \
  --install-extension GitHub.copilot-chat \
  --install-extension GitHub.github-vscode-theme \
  --install-extension herbcss.herb-lsp \
  --install-extension ybaumes.highlight-trailing-white-spaces \
  --install-extension yagudaev.run-specs \
  --install-extension marcoroth.stimulus-lsp \
  --install-extension tomoki1207.pdf \
  --install-extension CraigMaslowski.erb \
  --force 2>/dev/null || true
