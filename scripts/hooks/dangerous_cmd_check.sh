#!/bin/bash
# BDK Hook: Dangerous Command Detection
# Blocks destructive bash commands before execution
# Exit 0 = allow, Exit 2 = block (stderr fed to Claude)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Normalize: lowercase for case-insensitive matching
CMD_LOWER=$(echo "$COMMAND" | tr '[:upper:]' '[:lower:]')

# Pattern list: destructive commands
BLOCKED_PATTERNS=(
  "rm -rf /"
  "rm -rf /*"
  "rm -rf ~"
  "rm -rf \$home"
  ":(){:|:&};:"
  "mkfs."
  "dd if=/dev/zero"
  "dd if=/dev/random"
  "> /dev/sda"
  "chmod -r 777 /"
  "chown -r"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if [[ "$CMD_LOWER" == *"$pattern"* ]]; then
    echo "BLOCKED: Destructive command detected: '$pattern'. This command could cause irreversible damage." >&2
    exit 2
  fi
done

# SQL destructive operations (case-insensitive)
SQL_PATTERNS=(
  "drop database"
  "drop table"
  "truncate table"
  "delete from .* where 1"
  "delete from .* without"
)

for pattern in "${SQL_PATTERNS[@]}"; do
  if echo "$CMD_LOWER" | grep -qE "$pattern"; then
    echo "BLOCKED: Destructive SQL detected: '$pattern'. Use targeted queries with WHERE clauses." >&2
    exit 2
  fi
done

# Git force operations warning (exit 2 = block)
GIT_FORCE_PATTERNS=(
  "git push.*--force"
  "git push.*-f"
  "git reset --hard"
  "git clean -fd"
  "git checkout -- \\."
)

for pattern in "${GIT_FORCE_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "BLOCKED: Destructive git command detected. '$COMMAND' can cause data loss. Use safer alternatives (e.g., --force-with-lease)." >&2
    exit 2
  fi
done

exit 0
