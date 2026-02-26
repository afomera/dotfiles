#!/bin/bash
# Auto-approve read-only bash commands

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

READONLY_PATTERNS=(
  '^ls'
  '^find'
  '^pwd'
  '^cat'
  '^head'
  '^tail'
  '^grep'
  '^rg'
  '^which'
  '^whoami'
  '^echo'
  '^date'
  '^wc'
  '^file'
  '^stat'
)

for pattern in "${READONLY_PATTERNS[@]}"; do
  if [[ "$COMMAND" =~ $pattern ]]; then
    jq -n '{
      "hookSpecificOutput": {
        "hookEventName": "PermissionRequest",
        "decision": {
          "behavior": "allow"
        }
      }
    }'
    exit 0
  fi
done

exit 0
