#!/bin/bash
# BDK Hook: Post-Edit Lint Check
# Runs appropriate linter after file edits
# Non-blocking: exit 0 always, feedback via stdout

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

EXTENSION="${FILE_PATH##*.}"
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
ISSUES=""

case "$EXTENSION" in
  js|jsx|ts|tsx|mjs|cjs)
    # Check for ESLint
    if [ -f "$CWD/node_modules/.bin/eslint" ]; then
      RESULT=$("$CWD/node_modules/.bin/eslint" --no-eslintrc --rule '{"no-unused-vars":"warn","no-undef":"error"}' "$FILE_PATH" 2>&1) || true
      if [ -n "$RESULT" ]; then
        ISSUES="ESLint issues in $FILE_PATH:\n$RESULT"
      fi
    fi
    ;;
  py)
    # Check for ruff (fast Python linter)
    if command -v ruff &>/dev/null; then
      RESULT=$(ruff check "$FILE_PATH" --select E,F --no-fix 2>&1) || true
      if [ -n "$RESULT" ]; then
        ISSUES="Ruff issues in $FILE_PATH:\n$RESULT"
      fi
    elif command -v python3 &>/dev/null; then
      RESULT=$(python3 -m py_compile "$FILE_PATH" 2>&1) || true
      if [ -n "$RESULT" ]; then
        ISSUES="Syntax error in $FILE_PATH:\n$RESULT"
      fi
    fi
    ;;
  json)
    # JSON syntax validation
    if command -v jq &>/dev/null; then
      RESULT=$(jq empty "$FILE_PATH" 2>&1) || true
      if [ -n "$RESULT" ]; then
        ISSUES="JSON syntax error in $FILE_PATH:\n$RESULT"
      fi
    fi
    ;;
  yaml|yml)
    if command -v python3 &>/dev/null; then
      RESULT=$(python3 -c "import yaml; yaml.safe_load(open('$FILE_PATH'))" 2>&1) || true
      if [ -n "$RESULT" ]; then
        ISSUES="YAML syntax error in $FILE_PATH:\n$RESULT"
      fi
    fi
    ;;
esac

# Output issues as context for Claude (non-blocking)
if [ -n "$ISSUES" ]; then
  echo -e "$ISSUES"
fi

exit 0
