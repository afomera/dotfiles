#!/usr/bin/env sh
set -e

# Detect VS Code or Cursor CLI
if command -v code >/dev/null 2>&1; then
  CODE_CMD="code"
elif command -v cursor >/dev/null 2>&1; then
  CODE_CMD="cursor"
else
  echo "Neither 'code' nor 'cursor' CLI found, skipping VS Code extensions"
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
